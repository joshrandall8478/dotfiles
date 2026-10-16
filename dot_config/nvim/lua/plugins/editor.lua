-- Quality of life: a fuzzy finder, and a popup that shows what keys do.
return {
  {
    "nvim-telescope/telescope.nvim",
    tag = vim.fn.has("nvim-0.12") == 0 and "v0.2.2" or nil, -- newer releases need Neovim 0.11+
    cond = vim.fn.has("nvim-0.10.4") == 1,                  -- and v0.2.2 needs 0.10.4
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Search text in project" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Open buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics (errors)" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols in file" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>fc", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Color schemes (live preview)" },
    },
    opts = {},
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>c", group = "code" },
      },
    },
  },
}
