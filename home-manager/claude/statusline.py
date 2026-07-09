#!/usr/bin/env python3
"""Statusline: model/context/rate-limit indicators + git info"""

import json, subprocess, sys
from datetime import datetime

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8")

data = json.load(sys.stdin)

R = "\033[0m"
DIM = "\033[2m"
BOLD = "\033[1m"
BLUE = "\033[38;2;118;159;240m"
YELLOW = "\033[38;2;230;180;80m"


def gradient(pct):
    if pct < 50:
        r = int(pct * 5.1)
        return f"\033[38;2;{r};200;80m"
    else:
        g = int(200 - (pct - 50) * 4)
        return f"\033[38;2;255;{max(g, 0)};60m"


def dot(pct):
    p = round(pct)
    return f"{gradient(pct)}●{R} {BOLD}{p}%{R}"


def reset_str(ts, with_date=False):
    if not ts:
        return ""
    try:
        dt = datetime.fromtimestamp(ts)
        fmt = "%m/%d %H:%M" if with_date else "%H:%M"
        return f"{DIM}(更新 {dt.strftime(fmt)}){R}"
    except Exception:
        return ""


def git_info(cwd):
    def _run(*args):
        try:
            r = subprocess.run(
                ["git", "-C", cwd] + list(args),
                capture_output=True,
                text=True,
                timeout=2,
            )
            return r.stdout.strip() if r.returncode == 0 else ""
        except Exception:
            return ""

    branch = _run("symbolic-ref", "--short", "HEAD") or _run(
        "rev-parse", "--short", "HEAD"
    )
    if not branch:
        return ""
    dirty = (
        "!"
        if _run("diff", "--quiet") == ""
        and subprocess.run(
            ["git", "-C", cwd, "diff", "--quiet"],
            capture_output=True,
            timeout=2,
        ).returncode
        != 0
        else ""
    )
    untracked = "?" if _run("ls-files", "--others", "--exclude-standard") else ""
    status = dirty + untracked
    return f"{BLUE} {branch}{R}" + (f" {YELLOW}{status}{R}" if status else "")


# --- build parts ---
model = data.get("model", {}).get("display_name", "Claude")
parts = [f"{BOLD}{model}{R}"]

cwd = data.get("cwd", "")
gi = git_info(cwd) if cwd else ""
if gi:
    parts.append(gi)

ctx = data.get("context_window", {}).get("used_percentage")
if ctx is not None:
    parts.append(f"ctx {dot(ctx)}")

five_hour = data.get("rate_limits", {}).get("five_hour", {})
five = five_hour.get("used_percentage")
if five is not None:
    parts.append(f"5h {dot(five)} {reset_str(five_hour.get('resets_at'))}".rstrip())

seven_day = data.get("rate_limits", {}).get("seven_day", {})
week = seven_day.get("used_percentage")
if week is not None:
    parts.append(
        f"7d {dot(week)} {reset_str(seven_day.get('resets_at'), with_date=True)}".rstrip()
    )

print(f"  {DIM}·{R}  ".join(parts), end="")
