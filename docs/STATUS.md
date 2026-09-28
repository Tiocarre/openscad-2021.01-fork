# Status

OpenSCAD 2021.01, the shared Qt theme, dark editor/viewport defaults, and offline assistant panel are in source. The CAD engine is unchanged. Windows has MSVC, but Qt 5, qmake, CMake, QScintilla, and a WSL distribution are absent; the UI is uncompiled and unseen.

Next: run the Windows UI preview GitHub Actions workflow on `codex/ui-refonte`. It uses the official prebuilt Qt 5 GUI image (2023-10-10, pinned digest) on a Linux runner and the existing 2021.01 qmake build. No local WSL, Docker, or dependency installation is needed. Compatibility with this older source is pending the first build; no executable or GUI launch is validated yet.

On success, download the `openscad-2021.01-ui-windows-x64-*` artifact (kept for seven days), extract it, run `Open-UI.cmd`, press F5, and inspect the theme, editor, viewport, console and offline ASSIST. Stop for visual feedback. Saved OpenSCAD preferences can override the Tomorrow Night defaults. The private repository must allow Actions and have runner minutes available.
