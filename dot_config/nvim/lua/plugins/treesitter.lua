-- Treesitter: precise, colourful syntax highlighting. The parser for a
-- language is installed automatically the first time you open one of its files.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = { "mason-org/mason.nvim" }, -- provides the tree-sitter CLI used to build parsers
  config = function()
    local ts = require("nvim-treesitter")
    local tried = {}
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if not lang then return end
        local start = function() pcall(vim.treesitter.start, ev.buf, lang) end

        if vim.treesitter.language.add(lang) then
          start()
        elseif not tried[lang] and vim.fn.executable("tree-sitter") == 1
            and vim.list_contains(ts.get_available(), lang) then
          tried[lang] = true
          ts.install(lang):await(vim.schedule_wrap(start))
        end
      end,
    })
  end,
}
