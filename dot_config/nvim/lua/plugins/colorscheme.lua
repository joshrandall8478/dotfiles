-- Colour schemes, all with every background removed so the terminal's own
-- background (opacity, blur, wallpaper) shows through everywhere.
-- Pick one with `Space f c` (live preview); your choice is remembered.
--
-- Legend (see "Colors" in manual.md):
--   [ORIGINAL] the first version of this config: Catppuccin Mocha, transparent
--   [CUSTOM]   my changes to how colours look: backgrounds stripped everywhere
--   [NEW]      added with the extra schemes: 7 more schemes, picker, remembering your choice

-- [CUSTOM] These keep their background because it's the only thing that makes
-- them visible. Empty this list to strip literally everything.
local keep = {
  Visual = true, VisualNOS = true,                                          -- selected text
  Search = true, IncSearch = true, CurSearch = true, Substitute = true,     -- search matches
  PmenuSel = true, BlinkCmpMenuSelection = true, TelescopeSelection = true, -- selected menu item
  DiffAdd = true, DiffChange = true, DiffDelete = true, DiffText = true,    -- diff mode
}

local function brightness(rgb)
  return 0.299 * math.floor(rgb / 65536) + 0.587 * (math.floor(rgb / 256) % 256) + 0.114 * (rgb % 256)
end

-- [CUSTOM] Drop the background of every highlight group. Text that was drawn on a
-- coloured block (titles, badges) takes the block's colour so it stays readable.
local function clear_backgrounds()
  local dark = vim.o.background == "dark"
  for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
    if hl.bg and not keep[name] then
      if hl.fg and (brightness(hl.fg) < brightness(hl.bg)) == dark then hl.fg = hl.bg end
      hl.bg, hl.ctermbg = nil, nil
      vim.api.nvim_set_hl(0, name, hl)
    end
  end
end

local saved = vim.fn.stdpath("data") .. "/colorscheme" -- [NEW] last scheme you picked

return {
  {
    "catppuccin/nvim", -- [ORIGINAL] default scheme: catppuccin(-latte/-frappe/-macchiato/-mocha)
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({ -- [ORIGINAL]
        flavour = "mocha",
        transparent_background = true,
        float = { transparent = true },
      })

      -- [CUSTOM] strip backgrounds whenever a scheme or plugin adds colours
      vim.api.nvim_create_autocmd("ColorScheme", { callback = clear_backgrounds })
      vim.api.nvim_create_autocmd("User", { pattern = "LazyLoad", callback = clear_backgrounds })

      -- [NEW] Light-only variants switch 'background' to light; switch it back when
      -- leaving them, so e.g. latte -> tokyonight gives dark tokyonight, not tokyonight-day
      local from_light = false
      vim.api.nvim_create_autocmd("ColorSchemePre", {
        callback = function()
          if from_light then
            vim.g.colors_name = nil -- stops Neovim reloading the old scheme
            vim.o.background = "dark"
          end
        end,
      })

      -- [NEW] remember the scheme you pick (and light/dark) for next time
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function(ev)
          pcall(vim.fn.writefile, { ev.match, vim.o.background }, saved)
          from_light = vim.iter({ "latte", "dawn", "day", "lotus" }):any(function(l) return ev.match:find(l) ~= nil end)
        end,
      })

      -- [NEW] restore the last scheme you picked, or fall back to [ORIGINAL] Catppuccin
      local ok, last = pcall(vim.fn.readfile, saved)
      if ok and last[2] then vim.o.background = last[2] end
      if not (ok and last[1] and pcall(vim.cmd.colorscheme, last[1])) then
        vim.cmd.colorscheme("catppuccin")
      end
    end,
  },

  -- [NEW] Extra schemes: only loaded when you switch to them
  { "sainnhe/everforest", lazy = true },                    -- everforest
  { "rose-pine/neovim", name = "rose-pine", lazy = true },  -- rose-pine(-main/-moon/-dawn)
  { "folke/tokyonight.nvim", lazy = true },                 -- tokyonight(-night/-storm/-moon/-day)
  { "rebelot/kanagawa.nvim", lazy = true },                 -- kanagawa(-wave/-dragon/-lotus)
  { "ellisonleao/gruvbox.nvim", lazy = true },              -- gruvbox
  { "EdenEast/nightfox.nvim", lazy = true },                -- nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
  { "Mofiqul/dracula.nvim", lazy = true },                  -- dracula(-soft)
}
