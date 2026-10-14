-- Catppuccin, with a transparent background so the terminal's own
-- background (opacity, blur, wallpaper) shows through.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      float = { transparent = true },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
