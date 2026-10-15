-- Background-free statusline in the mode's colour (needs a Nerd Font). Left to right:
--   mode · git branch + live diff · file + diagnostics ··· macro · search
--   · plugin updates · active language servers · progress · line:col

-- Nerd Font glyphs, written as escapes so they survive any editor
local icon = {
  neovim = "\u{E6AE}",
  added = "\u{F457} ",
  modified = "\u{F459} ",
  removed = "\u{F458} ",
  lock = "\u{F023}",
  record = "\u{F044B}",
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local lazy_status = require("lazy.status")

    -- Live +/~/- counts from gitsigns (updates as you type, not just on save)
    local function git_diff()
      local g = vim.b.gitsigns_status_dict
      if g then return { added = g.added, modified = g.changed, removed = g.removed } end
    end

    -- The usual "recording @q" message is hidden along with showmode, so show it here
    local function macro()
      local reg = vim.fn.reg_recording()
      return reg ~= "" and (icon.record .. " @" .. reg) or ""
    end

    -- [NEW] Uses the current colour scheme's statusline colours (re-run by lualine
    -- whenever the scheme changes), [CUSTOM] with backgrounds removed: the mode
    -- colour moves onto the text. (Labels explained in colorscheme.lua / manual.md)
    local function theme()
      local loader = require("lualine.utils.loader")
      local ok, t = pcall(loader.load_theme, vim.g.colors_name or "auto")
      t = vim.deepcopy(ok and type(t) == "table" and t or loader.load_theme("auto"))
      for _, mode in pairs(t) do
        if mode.a and mode.a.bg and mode.a.bg ~= "NONE" then mode.a.fg = mode.a.bg end
        for _, section in pairs(mode) do section.bg = "NONE" end
      end
      return t
    end

    return {
      options = {
        theme = theme,
        globalstatus = true,
        component_separators = "",
        section_separators = "",
      },
      sections = {
        lualine_a = { { "mode", icon = icon.neovim } },
        lualine_b = {
          "branch",
          { "diff", source = git_diff, symbols = { added = icon.added, modified = icon.modified, removed = icon.removed } },
        },
        lualine_c = {
          { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = "●", readonly = icon.lock, unnamed = "[No Name]" } },
          "diagnostics",
        },
        lualine_x = {
          { macro, color = "DiagnosticError" },
          "searchcount",
          "selectioncount",
          { lazy_status.updates, cond = lazy_status.has_updates, color = "DiagnosticWarn" },
          "lsp_status",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "lazy", "mason", "fugitive", "quickfix" },
    }
  end,
}
