-- Error checking for every language: Mason installs language servers,
-- nvim-lspconfig knows how to run them, and blink.cmp adds completion.
-- Need another language? Run :Mason, press `i` on its server, done —
-- it starts automatically from then on.

local servers = {
  "lua_ls",        -- Lua
  "pyright",       -- Python
  "ts_ls",         -- JavaScript / TypeScript
  "html", "cssls", "jsonls",
  "clangd",        -- C / C++
  "rust_analyzer", -- Rust
  "gopls",         -- Go
  "bashls",        -- Bash / sh
  "yamlls", "taplo", "marksman", -- YAML, TOML, Markdown
}

-- Extra settings for particular servers
local settings = {
  lua_ls = { -- teach lua_ls about Neovim's API
    Lua = { runtime = { version = "LuaJIT" }, workspace = { library = { vim.env.VIMRUNTIME } } },
  },
}

-- Neovim 0.10/0.11 use the older Mason v1 stack, which sets servers up through
-- nvim-lspconfig's setup() instead of vim.lsp.config (pinned in lazy-lock-legacy.json)
local legacy = vim.fn.has("nvim-0.12") == 0

-- Non-LSP tools: shellcheck powers bash error checking, tree-sitter builds highlighting parsers
local tools = { "shellcheck", "tree-sitter-cli" }

return {
  {
    "mason-org/mason.nvim",
    version = legacy and "^1.0.0" or nil,
    lazy = false,
    config = function()
      require("mason").setup()
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(tools) do
          if not registry.is_installed(name) then registry.get_package(name):install() end
        end
      end)
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    version = legacy and "^1.0.0" or nil,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      { "neovim/nvim-lspconfig", tag = legacy and "v2.5.0" or nil }, -- later 2.x warn on 0.10
      "saghen/blink.cmp",
    },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { spacing = 2, prefix = "●" },
        float = { source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚",
            [vim.diagnostic.severity.WARN] = "󰀪",
            [vim.diagnostic.severity.INFO] = "󰋽",
            [vim.diagnostic.severity.HINT] = "󰌶",
          },
        },
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Installs any missing servers above, and starts every installed one.
      if legacy then
        require("mason-lspconfig").setup({
          ensure_installed = servers,
          handlers = {
            function(name)
              require("lspconfig")[name].setup({ capabilities = capabilities, settings = settings[name] })
            end,
          },
        })
      else
        vim.lsp.config("*", { capabilities = capabilities })
        for name, s in pairs(settings) do vim.lsp.config(name, { settings = s }) end
        require("mason-lspconfig").setup({ ensure_installed = servers })
      end

      -- Built in already: K hover, grn rename, gra code action, grr references, [d / ]d jump to diagnostics
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local function map(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc }) end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format file")
          map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
          if vim.fn.has("nvim-0.11") == 0 then -- built in from 0.11 on
            map("grn", vim.lsp.buf.rename, "Rename symbol")
            map("gra", vim.lsp.buf.code_action, "Code action")
            map("grr", vim.lsp.buf.references, "References")
          end
        end,
      })
    end,
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = { preset = "super-tab" }, -- Tab accepts, Ctrl-n/p or arrows to move
      completion = { documentation = { auto_show = true } },
      signature = { enabled = true },
    },
  },
}
