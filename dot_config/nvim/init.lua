-- ╭──────────────────────────────────────────────────────────╮
-- │  init.lua — options, keymaps, and the plugin manager.    │
-- │  Each feature lives in its own file in lua/plugins/.     │
-- ╰──────────────────────────────────────────────────────────╯

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Options ─────────────────────────────────────────────────
local opt = vim.opt
opt.mouse = "a"                -- mouse in every mode
opt.number = true              -- current line shows its real number…
opt.relativenumber = true      -- …and the rest count up/down from the cursor
opt.cursorline = true
opt.signcolumn = "yes"         -- room for git + diagnostic signs, no jumping
opt.termguicolors = true       -- 24-bit colours
opt.showmode = false           -- the statusline already shows the mode
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true          -- case-insensitive search…
opt.smartcase = true           -- …unless the query has capitals
opt.inccommand = "split"       -- live preview for :s/foo/bar
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.undofile = true            -- undo history survives restarts
opt.updatetime = 250
opt.timeoutlen = 400
opt.confirm = true             -- ask to save instead of erroring on :q
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " " }  -- hide the ~ on empty lines
opt.winborder = "rounded"      -- rounded borders on all floating windows
vim.schedule(function() opt.clipboard = "unnamedplus" end) -- use the system clipboard

vim.cmd("syntax enable")       -- regex highlighting; treesitter upgrades it when a parser exists

-- ── Keymaps ─────────────────────────────────────────────────
local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>qall<cr>", { desc = "Quit" })
map("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Briefly flash yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank() end,
})

-- ── Plugins (lazy.nvim) ─────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true, notify = false }, -- quietly check for updates (shown in the statusline)
  change_detection = { notify = false },
  rocks = { enabled = false },                  -- no plugin here needs luarocks
})
