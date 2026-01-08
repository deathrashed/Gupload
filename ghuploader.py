#!/usr/bin/env python3
import base64
import datetime as dt
import hashlib
import json
import mimetypes
import os
import re
import subprocess
import sys
import time
import urllib.parse
import urllib.request
import urllib.error

CONFIG_PATH = os.path.expanduser("~/.config/ghuploader/config.json")

AUDIO_EXT = {".mp3",".m4a",".aac",".wav",".flac",".ogg",".opus",".aiff",".alac",".wma"}
IMAGE_EXT = {".png",".jpg",".jpeg",".webp",".gif",".tif",".tiff",".bmp",".svg",".heic",".avif"}
VIDEO_EXT = {".mp4",".mov",".mkv",".webm",".avi",".m4v"}
DOC_EXT   = {".pdf",".txt",".md",".rtf",".doc",".docx",".ppt",".pptx",".xls",".xlsx",".csv",".json",".yaml",".yml",".xml"}
ARCH_EXT  = {".zip",".7z",".rar",".tar",".gz",".tgz",".bz2",".xz"}

def eprint(*a):
    print(*a, file=sys.stderr)

def load_config():
    if not os.path.exists(CONFIG_PATH):
        eprint(f"Missing config: {CONFIG_PATH}")
        sys.exit(2)
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        return json.load(f)

def run(cmd):
    return subprocess.check_output(cmd, text=True).strip()

def get_token(cfg):
    for k in ("GITHUB_TOKEN", "GH_TOKEN"):
        v = os.environ.get(k)
        if v:
            return v
    if cfg.get("allow_gh_cli_token", True):
        try:
            return run(["gh", "auth", "token"])
        except Exception:
            pass
    eprint("No GitHub token found. Set GITHUB_TOKEN or run `gh auth login`.")
    sys.exit(2)

def api_request(method, url, token, data=None, headers=None):
    h = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {token}",
        "X-GitHub-Api-Version": "2022-11-28",
        "User-Agent": "ghuploader",
    }
    if headers:
        h.update(headers)
    body = None
    if data is not None:
        body = json.dumps(data).encode("utf-8")
        h["Content-Type"] = "application/json"
    req = urllib.request.Request(url, data=body, headers=h, method=method)
    try:
        with urllib.request.urlopen(req) as resp:
            raw = resp.read()
            if raw:
                return json.loads(raw.decode("utf-8"))
            return None
    except urllib.error.HTTPError as err:
        msg = err.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"{method} {url} -> {err.code}\n{msg}") from None

def sanitize_filename(name: str) -> str:
    name = name.strip()
    name = name.replace(" ", "-")
    name = re.sub(r"[^A-Za-z0-9._-]+", "-", name)
    name = re.sub(r"-{2,}", "-", name).strip("-")
    return name or "file"

def sha1_file(path):
    h = hashlib.sha1()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

def clipboard_set(text: str):
    try:
        p = subprocess.Popen(["pbcopy"], stdin=subprocess.PIPE)
        p.communicate(text.encode("utf-8"))
    except Exception:
        pass

def category_for_path(path: str) -> str:
    ext = os.path.splitext(path)[1].lower()
    if ext in AUDIO_EXT: return "Audio"
    if ext in IMAGE_EXT: return "Images"
    if ext in VIDEO_EXT: return "Video"
    if ext in DOC_EXT:   return "Docs"
    if ext in ARCH_EXT:  return "Archives"
    # fallback by mimetype
    mt = mimetypes.guess_type(path)[0] or ""
    if mt.startswith("audio/"): return "Audio"
    if mt.startswith("image/"): return "Images"
    if mt.startswith("video/"): return "Video"
    return "Other"

def build_repo_path(cfg, local_path):
    base = cfg.get("repo_path_prefix", "uploads")
    cat = category_for_path(local_path)

    fname = sanitize_filename(os.path.basename(local_path))

    # Optional: strip common garbage patterns (very conservative)
    if cfg.get("clean_filename", True):
        # remove bracket tags like [MacKed], (1080p), etc. but keep extension
        root, ext = os.path.splitext(fname)
        root = re.sub(r"[\[\(].{1,40}?[\]\)]", "", root).strip("-_. ")
        root = re.sub(r"-{2,}", "-", root).strip("-")
        fname = (root or "file") + ext

    # Collision safety
    if cfg.get("append_short_hash", True):
        short = sha1_file(local_path)[:8]
        root, ext = os.path.splitext(fname)
        fname = f"{root}-{short}{ext}"

    return f"{base}/{cat}/{fname}", cat

def upload_contents_api(cfg, token, local_path, remote_path, category):
    owner = cfg["owner"]
    repo = cfg["repo"]
    branch = cfg.get("branch", "main")

    url = f"https://api.github.com/repos/{owner}/{repo}/contents/{remote_path}"

    with open(local_path, "rb") as f:
        blob = f.read()
    b64 = base64.b64encode(blob).decode("ascii")

    # Date in commit message (not in folder name)
    now = dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    msg = f"Upload ({category}) {os.path.basename(local_path)} @ {now}"

    payload = {"message": msg, "content": b64, "branch": branch}
    resp = api_request("PUT", url, token, data=payload)
    content = resp.get("content") if resp else None
    if not content:
        raise RuntimeError("GitHub API returned no content object.")
    return content.get("download_url")

def get_or_create_release(cfg, token):
    owner = cfg["owner"]
    repo = cfg["repo"]
    tag = cfg.get("release_tag", "gupload-uploads")
    name = cfg.get("release_name", "Uploads")
    draft = bool(cfg.get("release_draft", True))
    prerelease = bool(cfg.get("release_prerelease", False))

    url_get = f"https://api.github.com/repos/{owner}/{repo}/releases/tags/{tag}"
    try:
        rel = api_request("GET", url_get, token)
        return rel["upload_url"]
    except Exception:
        pass

    url_create = f"https://api.github.com/repos/{owner}/{repo}/releases"
    payload = {
        "tag_name": tag,
        "name": name,
        "draft": draft,
        "prerelease": prerelease,
        "generate_release_notes": False,
        "body": "Automated uploads via Gupload.",
    }
    rel = api_request("POST", url_create, token, data=payload)
    return rel["upload_url"]

def upload_release_asset(cfg, token, local_path, category):
    upload_url_tmpl = get_or_create_release(cfg, token)
    upload_url = upload_url_tmpl.split("{")[0]

    fname = sanitize_filename(os.path.basename(local_path))
    # Prefix category for releases (no folders there)
    root, ext = os.path.splitext(fname)
    if cfg.get("release_prefix_category", True):
        root = f"{category}-{root}"
    if cfg.get("release_append_timestamp", True):
        root = f"{root}-{int(time.time())}"
    fname = root + ext

    ctype = mimetypes.guess_type(local_path)[0] or "application/octet-stream"
    url = f"{upload_url}?name={urllib.parse.quote(fname)}"

    cmd = [
        "curl", "-sS", "-L",
        "-X", "POST",
        "-H", "Accept: application/vnd.github+json",
        "-H", f"Authorization: Bearer {token}",
        "-H", "X-GitHub-Api-Version: 2022-11-28",
        "-H", f"Content-Type: {ctype}",
        "--data-binary", f"@{local_path}",
        url
    ]
    out = subprocess.check_output(cmd)
    resp = json.loads(out.decode("utf-8"))
    return resp.get("browser_download_url")

def format_links(cfg, local_path, url):
    fname = os.path.basename(local_path)
    mode = cfg.get("output_mode", "markdown")  # markdown | url | both
    extra_audio = bool(cfg.get("also_audio_html", True))

    md = f"[{fname}]({url})"
    lines = []
    if mode in ("markdown", "both"):
        lines.append(md)
        if extra_audio and os.path.splitext(fname)[1].lower() in AUDIO_EXT:
            lines.append(f'<audio controls src="{url}"></audio>')
    if mode in ("url", "both"):
        lines.append(url)
    return "\n".join(lines)

def main(argv):
    cfg = load_config()
    token = get_token(cfg)

    if len(argv) < 2:
        eprint("Usage: ghu <file1> [file2 ...]")
        sys.exit(2)

    max_contents_mb = float(cfg.get("contents_max_mb", 95))
    out_blocks = []

    for p in argv[1:]:
        p = os.path.expanduser(p)
        if not os.path.exists(p) or not os.path.isfile(p):
            eprint(f"Skip (not a file): {p}")
            continue

        category = category_for_path(p)
        size_mb = os.path.getsize(p) / (1024 * 1024)

        if size_mb <= max_contents_mb:
            remote_path, cat = build_repo_path(cfg, p)
            url = upload_contents_api(cfg, token, p, remote_path, cat)
            if not url:
                raise RuntimeError("No download_url returned for contents upload.")
            out_blocks.append(format_links(cfg, p, url))
        else:
            if os.path.getsize(p) > 2 * 1024 * 1024 * 1024:
                raise RuntimeError(f"File too large (>2 GiB): {p}")
            url = upload_release_asset(cfg, token, p, category)
            if not url:
                raise RuntimeError("No browser_download_url returned for release upload.")
            out_blocks.append(format_links(cfg, p, url))

    if not out_blocks:
        eprint("No files uploaded.")
        sys.exit(1)

    combined = "\n\n".join(out_blocks).strip() + "\n"
    print(combined)
    clipboard_set(combined)

if __name__ == "__main__":
    main(sys.argv)