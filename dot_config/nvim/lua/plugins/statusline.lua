-- Bubble-style statusline (needs a Nerd Font). Left to right:
--   mode · git branch + live diff · file + diagnostics ··· macro · search
--   · plugin updates · active language servers · progress · line:col

-- Nerd Font glyphs, written as escapes so they survive any editor
local icon = {
  vim = "\u{E7C5}",
  cap_left = "\u{E0B6}",
  cap_right = "\u{E0B4}",
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

    return {
      options = {
        theme = "catppuccin-nvim",
        globalstatus = true,
        component_separators = "",
        section_separators = { left = icon.cap_right, right = icon.cap_left },
      },
      sections = {
        lualine_a = { { "mode", icon = icon.vim, separator = { left = icon.cap_left } } },
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
          { macro, color = { fg = "#f38ba8", gui = "bold" } },
          "searchcount",
          "selectioncount",
          { lazy_status.updates, cond = lazy_status.has_updates, color = { fg = "#fab387" } },
          "lsp_status",
        },
        lualine_y = { "progress" },
        lualine_z = { { "location", separator = { right = icon.cap_right } } },
      },
      extensions = { "lazy", "mason", "fugitive", "quickfix" },
    }
  end,
}
