local nvim_lsp = require("lspconfig")

-- local lsp = vim.g.lazyvim_python_lsp or "pylsp"
-- local ruff = vim.g.lazyvim_python_ruff or "ruff"
return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ----@type lspconfig.options
      servers = {
        -- nginx_language_server = {},
        solc = {},
        -- nil_ls = {
        --   settings = {
        --     nil_ls = {
        --       flake = {
        --         autoEvalInputs = true,
        --         nixpkgsInputName = "nixpkgs",
        --       },
        --     },
        --   },
        -- },
        -- nixd = {
        -- settings = {
        --   nixd = {
        --     nixpkgs = {
        --       expr = "import <nixpkgs> { }",
        --     },
        --     options = {
        --       nixos = {
        --         expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
        --       },
        --       home_manager = {
        --         expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
        --       },
        --     },
        --   },
        -- },
        -- },
        -- pylsp = {
        --   settings = {
        --     pylsp = {
        --       plugins = {
        --         pyflakes = { enabled = false },
        --         pycodestyle = { enabled = false },
        --         autopep8 = { enabled = false },
        --         yapf = { enabled = false },
        --         mccabe = { enabled = false },
        --         pylsp_mypy = { enabled = false },
        --         pylsp_black = { enabled = false },
        --         pylsp_isort = { enabled = false },
        --       },
        --     },
        --   },
        -- },
        -- lua_ls = {
        --     settings = {
        --         Lua = {
        --             runtime = {
        --                 version = "LuaJIT",
        --             },
        --             diagnostics = {
        --                 globals = { "use", "vim" },
        --             },
        --             hint = {
        --                 enable = true,
        --                 setType = true,
        --             },
        --             telemetry = {
        --                 enable = false,
        --             },
        --             workspace = {
        --                 library = {
        --                     [vim.fn.expand("$VIMRUNTIME/lua")] = true,
        --                     [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        --                     [vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true,
        --                     [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
        --                 },
        --                 maxPreload = 100000,
        --                 preloadFileSize = 10000,
        --             },
        --         },
        --     },
        -- },
        denols = {
          filetypes = { "typescript", "typescriptreact" },
          root_dir = function(...) return nvim_lsp.util.root_pattern("deno.jsonc", "deno.json")(...) end,
        },
        vtsls = {
          root_dir = nvim_lsp.util.root_pattern("package.json"),
        },
        -- tsserver = {
        --     -- root_dir = function(...)
        --     --   return require("lspconfig.util").root_pattern(".git")(...)
        --     -- end,
        --     single_file_support = false,
        --     settings = {
        --         typescript = {
        --             inlayHints = {
        --                 includeInlayParameterNameHints = "literal",
        --                 includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        --                 includeInlayFunctionParameterTypeHints = false,
        --                 includeInlayVariableTypeHints = false,
        --                 includeInlayPropertyDeclarationTypeHints = true,
        --                 includeInlayFunctionLikeReturnTypeHints = true,
        --                 includeInlayEnumMemberValueHints = true,
        --             },
        --         },
        --         javascript = {
        --             inlayHints = {
        --                 includeInlayParameterNameHints = "all",
        --                 includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        --                 includeInlayFunctionParameterTypeHints = true,
        --                 includeInlayVariableTypeHints = true,
        --                 includeInlayPropertyDeclarationTypeHints = true,
        --                 includeInlayFunctionLikeReturnTypeHints = true,
        --                 includeInlayEnumMemberValueHints = true,
        --             },
        --         },
        --     },
        -- },
      },
    },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function(_, opts)
  --     local servers = { "pyright", "pylsp", "ruff", "ruff_lsp", ruff, lsp }
  --     for _, server in ipairs(servers) do
  --       opts.servers[server] = opts.servers[server] or {}
  --       opts.servers[server].enabled = server == lsp or server == ruff
  --     end
  --   end,
  -- },
}
