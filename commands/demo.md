---
description: Create and record demo GIF for copy-path.nvim
argument-hint: [record|preview|push]
---

Activate the `demo` skill: $ARGUMENTS

Modes:
- `/demo record` → run demo/record.sh in Ghostty to create demo.gif, then push to demo branch
- `/demo preview` → run demo/preview.sh to preview the demo in terminal
- `/demo push` → switch to demo branch, commit demo.gif, push, switch back to main

## Context

The demo GIF lives on an orphan `demo` branch (separate from main). README on main references it via raw GitHub URL from the demo branch.

### Demo branch structure
```
demo.gif      ← the rendered GIF
auto.lua      ← nvim automation script (typing simulation + which-key popups)
record.sh     ← one command to setup tmp project, record, convert to GIF
```

### Recording must run in Ghostty
The record script opens nvim interactively — it needs a real terminal. Tell the user to run:
```
cd ~/project/copy-path.nvim && bash demo/record.sh
```

### Record flow (record.sh)
1. Creates `/tmp/copy-path-demo/` with simple plain JS files (no frameworks/deps)
2. Copies `auto.lua` to `.demo/` (hidden from neo-tree)
3. Records nvim session via `asciinema rec -c "nvim ..."`
4. Converts to GIF via `agg` (CaskaydiaCove Nerd Font, `--font-dir ~/Library/Fonts`)
5. Adds macOS window border via ImageMagick (traffic lights + `#282A36` background)
6. Copies GIF back and cleans up `/tmp/copy-path-demo`

### auto.lua design
- Types commands char by char via `nvim_feedkeys` (60ms per char)
- Pauses 1s after typing before pressing Enter so viewer can read
- For keymaps: press `<leader>`, wait 1.5s (which-key popup), press `f`, wait 1.5s (submenu), press key
- Groups related features: `:CopyPath` command then `<leader>fy` keymap right after
- Uses real nvim config (LazyVim) — NOT `-u minimal_init.lua`
- `qa!` exits fast (no typing animation)

### Push flow
After recording, stash if needed, checkout demo branch, commit the GIF and scripts, push, then switch back to main. Use the git author/committer identity from memory.

### Known tool limitations
- **VHS**: no font anti-aliasing — don't use, text looks ugly
- **agg**: can't render Nerd Font PUA glyphs (Powerline icons = squares). Workaround: record only nvim session via `asciinema rec -c "nvim ..."` to skip shell prompt
- **agg background**: default is `#282A36` — match this in ImageMagick border for seamless look
- **agg font**: use `--font-dir ~/Library/Fonts --font-family "CaskaydiaCove Nerd Font"` and `--verbose` to confirm loading

### Dependencies
- `asciinema` — terminal recording
- `agg` — cast to GIF with anti-aliased font rendering
- `magick` (ImageMagick) — macOS window border post-processing
- CaskaydiaCove Nerd Font installed in ~/Library/Fonts
