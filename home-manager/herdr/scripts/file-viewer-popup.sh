#!/bin/sh
# Launcher for the `type = "popup"` prefix+f binding: run the herdr-file-viewer
# binary directly inside the popup terminal. The plugin's install dir is
# hash-suffixed and changes on reinstall, so resolve it by glob instead of
# hardcoding. The viewer roots at this process's cwd (the popup follows the
# focused pane), so it shows the repo you invoked it from.
set -eu

for bin in "$HOME"/.config/herdr/plugins/github/herdr-file-viewer-*/target/release/herdr-file-viewer; do
  if [ -x "$bin" ]; then
    exec "$bin"
  fi
done

echo "herdr-file-viewer is not installed (or not built) under ~/.config/herdr/plugins." >&2
printf 'Press Enter to close.' >&2
read -r _
