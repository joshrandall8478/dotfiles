-- Git: change markers in the gutter, inline blame, hunk actions (gitsigns)
-- and a full git interface with :Git (fugitive).
return {
  {
    "lewis6991/gitsigns.nvim",
    tag = vim.fn.has("nvim-0.12") == 0 and "v2.1.0" or nil, -- newer releases need Neovim 0.11+
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true, -- "you, 2 days ago • message" at the end of the line
      current_line_blame_opts = { delay = 500 },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc }) end
        map("]h", function() gs.nav_hunk("next") end, "Next git hunk")
        map("[h", function() gs.nav_hunk("prev") end, "Previous git hunk")
        map("<leader>gp", gs.preview_hunk, "Preview hunk")
        map("<leader>gs", gs.stage_hunk, "Stage / unstage hunk")
        map("<leader>gr", gs.reset_hunk, "Reset hunk")
        map("<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("<leader>gB", gs.toggle_current_line_blame, "Toggle inline blame")
        map("<leader>gd", gs.diffthis, "Diff file")
      end,
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = { { "<leader>gg", "<cmd>Git<cr>", desc = "Git status" } },
  },
}
