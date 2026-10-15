# Neovim Config Manual

A small, modern Neovim setup: 8 color schemes (Catppuccin by default) with no
backgrounds (your terminal shows through everywhere), Treesitter syntax
highlighting, error checking for many languages, git integration,
autocomplete, and a statusline colored by mode. All of it is about 425 lines in
7 files.

**Leader key: `Space`.** Press it and wait a moment. A popup (which-key) lists
every shortcut you can press next.

---

## Contents

1. [Requirements](#1-requirements)
2. [First launch](#2-first-launch)
3. [File layout](#3-file-layout)
4. [Keymaps](#4-keymaps)
5. [Features](#5-features)
6. [Commands](#6-commands)
7. [Customizing](#7-customizing)
8. [Updating](#8-updating)
9. [Troubleshooting](#9-troubleshooting)

---

## 1. Requirements

| Requirement | Used for |
|---|---|
| Neovim **0.12+** | Required by nvim-treesitter's `main` branch and the built-in LSP setup |
| `git`, `curl`, `tar`, `unzip` | Downloading plugins, parsers and language servers |
| A C compiler (`gcc`) | Building Treesitter parsers |
| A **Nerd Font** set as your terminal font | Icons in the statusline, gutter and file pickers |
| `npm` | Installing pyright, ts_ls, html/css/json, bashls and yamlls |
| `go` | Installing gopls |
| A Rust toolchain (`rustup default stable`) | Running rust-analyzer (it calls `cargo`) |

Optional:

| Tool | Used for |
|---|---|
| `wl-clipboard` (Wayland) or `xclip` (X11) | Sharing yank/paste with the system clipboard |
| `ripgrep` (`rg`) | `Space f g` (search text in the project) |
| `fd` | Faster `Space f f` (find files) |

On an **older Neovim** (Debian's `apt install neovim` ships 0.10 on trixie, 0.7
on bookworm) the config still starts: you get the options and keymaps but no
plugins, and a warning says so. To get everything, install the official release
instead of the Debian package:

```sh
arch=x86_64   # or arm64 on ARM servers
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$arch.tar.gz
sudo rm -rf /opt/nvim-linux-$arch && sudo tar -C /opt -xzf nvim-linux-$arch.tar.gz
sudo ln -sf /opt/nvim-linux-$arch/bin/nvim /usr/local/bin/nvim   # ahead of /usr/bin on PATH
```

You **don't** need to install `tree-sitter-cli` or `shellcheck` yourself. Mason
installs both automatically.

---

## 2. First launch

Run `nvim`. The first launch downloads everything it needs:

1. **lazy.nvim** clones itself and installs every plugin. The exact versions
   are pinned in `lazy-lock.json`, so you get the versions this config was
   tested with.
2. **Mason** installs `tree-sitter-cli` and `shellcheck` straight away.
3. When you **open your first file**, Mason installs the language servers
   (about 30 seconds). Notifications show the progress.
4. The first time you open a file in a new language, its **Treesitter parser**
   downloads and compiles in a few seconds. Until then the file uses Vim's
   regex highlighting, so it is never uncolored.

If a file was already open while its language server was installing, reload it
with `:e` to attach the server.

---

## 3. File layout

```
~/.config/nvim/
├── init.lua                 options, keymaps, and lazy.nvim setup
├── lazy-lock.json           pinned plugin versions (managed by :Lazy)
├── manual.md                this file
└── lua/plugins/             one file per feature; lazy.nvim loads them all
    ├── colorscheme.lua      8 color schemes (Catppuccin default), every background removed
    ├── treesitter.lua       syntax highlighting + automatic parser installs
    ├── lsp.lua              error checking (Mason + LSP) and autocomplete (blink.cmp)
    ├── git.lua              gitsigns (gutter, blame, hunks) + fugitive (:Git)
    ├── statusline.lua       lualine statusline (no background, colored by mode)
    └── editor.lua           Telescope fuzzy finder + which-key popup
```

| Plugin | Purpose |
|---|---|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [catppuccin](https://github.com/catppuccin/nvim) | Default color scheme **[ORIGINAL]** |
| everforest, rose-pine, tokyonight, kanagawa, gruvbox, nightfox, dracula | Extra color schemes, loaded only when picked **[NEW]** ([list](#color-schemes)) |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Parser installer for syntax highlighting |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | Installs language servers and tools |
| [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim) | Starts every server Mason installs |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Ready-made settings for each language server |
| [blink.cmp](https://github.com/saghen/blink.cmp) + friendly-snippets | Autocomplete and snippets |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git markers, inline blame, hunk actions |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Full git interface (`:Git`) |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) + nvim-web-devicons | Statusline and file icons |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) + plenary | Fuzzy finder |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Popup listing available keys |

---

## 4. Keymaps

`Space` is the leader key, so `Space f f` means press Space, then `f`, then `f`.

### General

| Key | Mode | Action |
|---|---|---|
| `Space w` | Normal | Save file |
| `Space q` | Normal | Quit everything (asks first if anything is unsaved) |
| `Esc` | Normal | Clear search highlighting |
| `Ctrl-h` / `Ctrl-j` / `Ctrl-k` / `Ctrl-l` | Normal | Move to the split on the left / below / above / right |
| `<` / `>` | Visual | Indent left / right and keep the selection |

**Mouse** works in every mode. You can click to move the cursor, drag to
select, scroll, and drag split borders to resize them.

### Find (`Space f`, Telescope)

| Key | Action |
|---|---|
| `Space f f` | Find files |
| `Space f g` | Search text across the project (needs ripgrep) |
| `Space f b` | Switch between open buffers |
| `Space f r` | Recently opened files |
| `Space f d` | List all diagnostics (errors and warnings) |
| `Space f s` | Symbols (functions, classes…) in the current file |
| `Space f h` | Search Neovim's help |
| `Space f c` | Switch color scheme, with live preview |

Inside a picker, type to filter and use these keys:

| Key | Action |
|---|---|
| `Ctrl-n` / `Ctrl-p` or arrow keys | Move through results |
| `Enter` | Open |
| `Ctrl-x` / `Ctrl-v` / `Ctrl-t` | Open in a horizontal split / vertical split / new tab |
| `Ctrl-q` | Send all results to the quickfix list |
| `Ctrl-c`, or `Esc` twice | Close |

### Code and errors (LSP)

These keys work only in buffers where a language server is running.

**Added by this config:**

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `Space c a` | Code action (quick fixes, refactors) |
| `Space c r` | Rename symbol everywhere |
| `Space c f` | Format file |
| `Space c d` | Show the full diagnostics for the current line |

**Built into Neovim 0.12:**

| Key | Action |
|---|---|
| `K` | Hover documentation |
| `grn` | Rename |
| `gra` | Code action |
| `grr` | List references |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `grx` | Run code lens |
| `gO` | Symbols in this file |
| `Ctrl-s` (Insert) | Signature help |
| `]d` / `[d` | Next / previous diagnostic |
| `Ctrl-w d` | Diagnostic popup for the cursor position |
| `Ctrl-o` / `Ctrl-i` | Jump back / forward (for example, after `gd`) |

### Autocomplete (blink.cmp)

The completion menu opens on its own as you type, with documentation beside it.

| Key (Insert) | Action |
|---|---|
| `Tab` | Accept the selected item (the first item if none is selected); inside a snippet, jump to the next placeholder |
| `Shift-Tab` | Jump to the previous snippet placeholder |
| `Ctrl-n` / `Ctrl-p` or `↓` / `↑` | Select the next / previous item |
| `Ctrl-Space` | Open the menu, or toggle the documentation |
| `Ctrl-e` | Close the menu |
| `Ctrl-f` / `Ctrl-b` | Scroll the documentation |
| `Ctrl-k` | Toggle function signature help |

### Git (`Space g`)

| Key | Action |
|---|---|
| `]h` / `[h` | Next / previous changed hunk |
| `Space g p` | Preview the hunk under the cursor |
| `Space g s` | Stage the hunk (press again to unstage it) |
| `Space g r` | Reset (discard) the hunk |
| `Space g b` | Full blame for the current line in a popup |
| `Space g B` | Toggle inline blame at the end of the line |
| `Space g d` | Diff the file against the staged version |
| `Space g g` | Git status window (fugitive) |

Keys inside the **`:Git` status window**:

| Key | Action |
|---|---|
| `s` / `u` / `-` | Stage / unstage / toggle the file or hunk under the cursor |
| `=` | Show or hide the inline diff |
| `X` | Discard the change |
| `cc` | Commit (write the message, then `:wq`) |
| `ca` | Amend the last commit |
| `gq` | Close the window |
| `g?` | Show all keys |

---

## 5. Features

### Error checking (LSP)

Mason downloads the language servers. mason-lspconfig starts **every server
Mason has installed**, and nvim-lspconfig provides each one's settings.
Problems show up in four places:

- **Underlines** on the problem code
- **Virtual text** (`●` and the message) at the end of the line
- **Icons in the gutter** for errors, warnings, info and hints
- **Counts in the statusline**

Errors are listed before warnings. Diagnostics refresh when you leave Insert
mode, not on every keystroke.

**Servers installed automatically:**

| Language | Server |
|---|---|
| Lua | `lua_ls` (already set up for Neovim's API) |
| Python | `pyright` |
| JavaScript / TypeScript | `ts_ls` |
| HTML / CSS / JSON | `html`, `cssls`, `jsonls` |
| C / C++ | `clangd` |
| Rust | `rust_analyzer` |
| Go | `gopls` |
| Bash / sh | `bashls` (uses `shellcheck` for warnings) |
| YAML / TOML / Markdown | `yamlls`, `taplo`, `marksman` |

**To add another language:**

1. Run `:Mason`. Press `Ctrl-f` to filter by language, or `/` to search.
2. Move to the server and press `i`.
3. Open a file in that language. The server starts on its own.

To have the server installed automatically on a new machine too, add its name
to the `servers` list at the top of `lua/plugins/lsp.lua`. Server names are
listed with `:help lspconfig-all`.

**Per-language notes:**

- **Rust** needs a default toolchain: `rustup default stable`.
- **C/C++**: clangd works best with a `compile_commands.json` in the project.
  CMake can generate one with `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`.
- **Go**: projects need a `go.mod`.

### Syntax highlighting

- `syntax enable` turns on Vim's regex highlighting for every filetype Vim knows.
- **Treesitter** replaces it with more accurate, more colorful highlighting
  once a language's parser is installed. Parsers install **on their own** the
  first time you open a file in that language. Mason provides the
  `tree-sitter` CLI that compiles them.
- To manage parsers yourself: `:TSInstall <lang>`, `:TSUninstall <lang>`,
  `:TSUpdate`, and `:TSLog` (shows install output).

### Colors and transparency

Everything about colors lives in `lua/plugins/colorscheme.lua` (and the theme
part of `lua/plugins/statusline.lua`). Each piece is labeled in the code and in
this section:

| Label | Meaning |
|---|---|
| **[ORIGINAL]** | Part of the first version of this config |
| **[CUSTOM]** | A change to how colors look: backgrounds removed everywhere |
| **[NEW]** | Added with the extra color schemes |

#### Color schemes

Press **`Space f c`** to open a picker with a **live preview**: move through the
list to try each scheme, press `Enter` to keep it, `Esc` to cancel. You can also
type `:colorscheme <name>`. The scheme you pick, and whether it's light or dark,
is **remembered** the next time you start Neovim.

| Scheme | Variants (`:colorscheme …`) | Status |
|---|---|---|
| [Catppuccin](https://github.com/catppuccin/nvim) | `catppuccin` (= mocha), `catppuccin-mocha`, `catppuccin-macchiato`, `catppuccin-frappe`, `catppuccin-latte` (light) | **[ORIGINAL]**: default if you haven't picked one |
| [Everforest](https://github.com/sainnhe/everforest) | `everforest` (dark; `:set background=light` for light) | **[NEW]** |
| [Rosé Pine](https://github.com/rose-pine/neovim) | `rose-pine`, `rose-pine-main`, `rose-pine-moon`, `rose-pine-dawn` (light) | **[NEW]** |
| [Tokyo Night](https://github.com/folke/tokyonight.nvim) | `tokyonight`, `tokyonight-night`, `tokyonight-storm`, `tokyonight-moon`, `tokyonight-day` (light) | **[NEW]** |
| [Kanagawa](https://github.com/rebelot/kanagawa.nvim) | `kanagawa`, `kanagawa-wave`, `kanagawa-dragon`, `kanagawa-lotus` (light) | **[NEW]** |
| [Gruvbox](https://github.com/ellisonleao/gruvbox.nvim) | `gruvbox` (dark; `:set background=light` for light) | **[NEW]** |
| [Nightfox](https://github.com/EdenEast/nightfox.nvim) | `nightfox`, `duskfox`, `nordfox`, `terafox`, `carbonfox`, `dayfox` (light), `dawnfox` (light) | **[NEW]** |
| [Dracula](https://github.com/Mofiqul/dracula.nvim) | `dracula`, `dracula-soft` | **[NEW]** |

The new schemes are **lazy-loaded**: each one is downloaded once but only loads
when you switch to it, so they don't slow down startup.

#### What each part does

| Piece | What it does | Status |
|---|---|---|
| Catppuccin Mocha + `transparent_background` / `float.transparent` | The main theme, with the editor and popup backgrounds made transparent | **[ORIGINAL]** |
| `clear_backgrounds()` + the `keep` list | Removes the background from every other color group (see below) | **[CUSTOM]** |
| Statusline theme with `bg = "NONE"` | Mode color on the text instead of in a bubble | **[CUSTOM]** |
| 7 extra scheme plugins | Everforest, Rosé Pine, Tokyo Night, Kanagawa, Gruvbox, Nightfox, Dracula | **[NEW]** |
| `Space f c` picker | Switch schemes with a live preview | **[NEW]** |
| Remembered choice | Saves the scheme name and light/dark to `~/.local/share/nvim/colorscheme` and restores it on startup | **[NEW]** |
| Light-variant reset | After a light-only variant (latte, dawn, day, lotus), the next scheme opens dark, so `latte` → `tokyonight` doesn't give you `tokyonight-day` | **[NEW]** |
| Statusline follows the scheme | The statusline uses the active scheme's colors, falling back to colors generated from the scheme | **[NEW]** (previously Catppuccin only) |

#### No backgrounds **[CUSTOM]**

This applies to **every** scheme above.

- `colorscheme.lua` **removes the background from every color group**: the editor, cursor line,
  gutter, popups, menus, error messages, inlay hints, titles and the statusline.
  It does this again whenever the color scheme changes or a plugin loads, so
  colors added by plugins are stripped too.
- Some text is drawn as dark text on a colored block, such as popup titles or
  the mode name. That text **takes the block's color** instead, so it stays
  readable. This works for light themes too.
- A few groups **keep** their background, because without it you couldn't see
  them at all:

  | Kept | Why |
  |---|---|
  | `Visual` | Selected text |
  | `Search`, `IncSearch`, `CurSearch`, `Substitute` | Search matches |
  | `PmenuSel`, `BlinkCmpMenuSelection`, `TelescopeSelection` | The selected item in menus and pickers |
  | `DiffAdd`, `DiffChange`, `DiffDelete`, `DiffText` | Changed lines in diff mode (`Space g d`) |

  To strip literally everything, empty the `keep` list at the top of
  `lua/plugins/colorscheme.lua`. To keep another group's background, add it to
  the list.
- The **terminal draws the background**. In kitty, set `background_opacity
  0.85` (and `background_blur` if your compositor supports it) in `kitty.conf`.
- Every floating window gets rounded borders (`winborder = "rounded"`), so
  popups stay easy to see without a background. **[ORIGINAL]**

### Statusline

There is a single statusline at the bottom, shared by all windows. Like
everything else it has no background: the current mode's color from the active
color scheme is used for the text. With Catppuccin that's blue for Normal,
green for Insert, mauve for Visual, peach for Command and red for Replace. From
left to right:

| Segment | Shows |
|---|---|
| **Mode** | Current mode (NORMAL, INSERT, VISUAL…) with a Vim icon; the color changes with the mode |
| **Git** | Branch name, plus live `+added ~changed -removed` line counts that update as you type |
| **File** | File type icon, path relative to the working directory, `●` if unsaved, a lock if read-only |
| **Diagnostics** | Error, warning, info and hint counts for the buffer |
| **Macro** | `@q` (in red) while you're recording a macro |
| **Search** | `[3/12]`: which match you're on, out of how many |
| **Selection** | Size of the selection in Visual mode |
| **Updates** | Number of plugin updates available (checked quietly in the background) |
| **LSP** | Names of the running language servers, with a spinner while they're busy |
| **Progress** | `Top`, `Bot`, or how far through the file you are |
| **Location** | `line:column` |

The Lazy, Mason, fugitive and quickfix windows get their own simplified
statuslines.

### Git

- **Gutter markers** next to the line numbers show added, changed and deleted
  lines.
- **Inline blame**: half a second after the cursor rests on a line, its author,
  age and commit message appear at the end of the line. Toggle it with
  `Space g B`.
- **Hunks** can be previewed, staged and reset without leaving the file (see
  [Git keymaps](#git-space-g)).
- **`:Git`** (fugitive) runs any git command: `:Git push`, `:Git pull`,
  `:Git log --oneline`, `:Git blame`, and `:Gvdiffsplit` for a side-by-side diff.

### Editor options

| Option | Effect |
|---|---|
| `mouse = "a"` | Mouse works in every mode |
| `number` + `relativenumber` | The current line shows its real number; other lines show their distance from it (handy with `5j`, `3dk`, …) |
| `cursorline` | Highlights the line the cursor is on |
| `signcolumn = "yes"` | The gutter is always shown, so text doesn't shift when signs appear |
| `clipboard = "unnamedplus"` | Yank and paste use the system clipboard (needs wl-clipboard or xclip) |
| `ignorecase` + `smartcase` | Searches ignore case unless the search contains a capital letter |
| `expandtab`, `shiftwidth = 4`, `tabstop = 4` | Indent with 4 spaces |
| `undofile` | Undo history is kept after you close a file |
| `scrolloff = 8` | Keeps 8 lines visible above and below the cursor |
| `wrap = false` | Long lines aren't wrapped |
| `splitright`, `splitbelow` | New splits open to the right / below |
| `inccommand = "split"` | Shows a live preview of `:s/old/new/` |
| `confirm` | Asks whether to save instead of failing on `:q` |
| `list` | Shows tabs as `»` and trailing spaces as `·` |
| Yank highlight | Yanked text briefly flashes |

---

## 6. Commands

| Command | What it does |
|---|---|
| `:Lazy` | Plugin manager. Keys: `U` update, `S` sync, `X` clean, `C` check, `R` restore lockfile, `P` profile startup, `?` help |
| `:Mason` | Language server/tool manager. Keys: `i` install, `X` uninstall, `u` update, `U` update all, `Ctrl-f` filter by language, `g?` help |
| `:Telescope` | Opens a list of every picker |
| `:Git …` | Runs any git command through fugitive |
| `:LspInfo` | Shows which language servers are attached, with their settings |
| `:LspRestart` / `:LspLog` | Restart the servers / open the LSP log |
| `:TSUpdate` / `:TSInstall <lang>` | Update / install Treesitter parsers |
| `:checkhealth` | Full diagnostic report; add a name to narrow it, e.g. `:checkhealth vim.lsp` |

---

## 7. Customizing

All changes go in the files described above. Restart Neovim afterwards.

**Change the color scheme**: press `Space f c` and pick one. Your choice is
remembered, so no file editing is needed. To change what plain `catppuccin`
means, edit `flavour` in `lua/plugins/colorscheme.lua`:

```lua
flavour = "macchiato", -- "latte" (light), "frappe", "macchiato", "mocha"
```

**Add another color scheme** by adding a line to the `[NEW]` list at the bottom
of `lua/plugins/colorscheme.lua`. It loses its backgrounds automatically, like
the others:

```lua
{ "navarasu/onedark.nvim", lazy = true }, -- onedark
```

**Bring the backgrounds back**:

1. In `lua/plugins/colorscheme.lua`, delete the two `[CUSTOM]`
   `nvim_create_autocmd` lines that call `clear_backgrounds`.
2. In the same file, set `transparent_background = false` (and remove the
   `float` line) to get the theme's solid background as well.
3. In `lua/plugins/statusline.lua`, delete the loop that sets `bg = "NONE"`.

**Use 2-space indentation for certain languages** by adding this to `init.lua`:

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "javascript", "typescript", "json", "yaml" },
  callback = function() vim.bo.shiftwidth = 2; vim.bo.tabstop = 2 end,
})
```

**Change a language server's settings** in `lua/plugins/lsp.lua`, next to the
existing `lua_ls` example:

```lua
vim.lsp.config("pyright", {
  settings = { python = { analysis = { typeCheckingMode = "strict" } } },
})
```

**Change the completion keys** in `lua/plugins/lsp.lua`:

```lua
keymap = { preset = "enter" },   -- Enter accepts
keymap = { preset = "default" }, -- Ctrl-y accepts (Vim style)
```

**Turn inline blame off by default** in `lua/plugins/git.lua`: set
`current_line_blame = false`. `Space g B` still toggles it.

**Add a plugin** by creating a new file in `lua/plugins/`. For example,
`lua/plugins/autopairs.lua`:

```lua
return { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} }
```

lazy.nvim installs it the next time you start Neovim.

**Remove a plugin** by deleting its spec, then running `:Lazy clean`.

**Add your own keymap** in the Keymaps section of `init.lua`:

```lua
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "File explorer" })
```

Including `desc` makes the keymap appear in the which-key popup.

---

## 8. Updating

| What | How |
|---|---|
| Plugins | `:Lazy update` updates them and records the new versions in `lazy-lock.json`. The statusline shows how many updates are waiting. |
| Undo a bad plugin update | `:Lazy restore` returns to the versions in `lazy-lock.json` |
| Language servers and tools | `:Mason`, then `U` |
| Treesitter parsers | `:TSUpdate` (also runs automatically when nvim-treesitter updates) |

If you keep your dotfiles in git, commit `lazy-lock.json`. That way every
machine runs the same plugin versions.

---

## 9. Troubleshooting

| Symptom | Fix |
|---|---|
| Icons show up as boxes or `?` | Set your terminal font to a Nerd Font. In kitty, run `kitty +list-fonts \| grep Nerd` and put one of the names in `font_family` in `kitty.conf`. |
| Yanking doesn't reach other apps | Install a clipboard tool (`sudo pacman -S wl-clipboard` on Wayland, `xclip` on X11), then restart Neovim. |
| Background isn't transparent | The terminal controls this. Set `background_opacity` below `1.0` in kitty. |
| No errors appear in a file | Run `:LspInfo` to check whether a server is attached. If none is, install one in `:Mason`. If it just finished installing, run `:e`. |
| Rust: rust-analyzer fails with "no default toolchain" | `rustup default stable` |
| Highlighting looks plain | The parser may still be installing, or the install failed. Check `:TSLog` and `:checkhealth nvim-treesitter`, then try `:TSInstall <lang>`. Compiling needs `gcc`. |
| Bash files show no warnings | Make sure `shellcheck` is installed in `:Mason`. |
| Something broke after `:Lazy update` | `:Lazy restore` |
| `:checkhealth lazy` warns about `site/pack/core` | Harmless. Catppuccin creates that empty folder when it checks for Neovim's built-in plugin manager. |
| Slow startup | `:Lazy profile` shows what takes the time. |

**Full reset**: this deletes all plugins, servers and parsers, and also your
undo history. Everything else re-downloads on the next launch:

```sh
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```
