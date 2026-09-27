# Fork baseline

- Upstream: `https://github.com/openscad/openscad.git` (`upstream`).
- Base: official `openscad-2021.01` tag, peeled commit `41f58fe57c03457a3a8b4dc541ef5654ec3e8c78`.
- Fork remote: `https://github.com/Tiocarre/openscad-2021.01-fork.git` (`origin`, to be created under Tiocarre).
- Local work branch: `codex/ui-refonte`.

The source was cloned from the upstream Git repository at the release tag, retaining its history. Fetch new upstream branches with `git fetch upstream`; review and merge or rebase selected upstream changes onto the fork branch. Keep GUI changes in small commits prefixed `[UI]`, `[THEME]`, or `[AI-UI]`; reserve `[UPSTREAM]` for an intentional upstream sync. Do not reformat upstream files as part of a sync.

GUI/theme files touched for this milestone: `CMakeLists.txt`, `openscad.pro`, `openscad.qrc`, `src/openscad.cc`, `src/Preferences.cc`, `src/mainwin.cc`, `src/AiPanel.h`, `src/AiPanel.cc`, and `themes/workstation.qss`. The OpenSCAD parser, geometry, renderers, exports, and language implementation have not been changed.
