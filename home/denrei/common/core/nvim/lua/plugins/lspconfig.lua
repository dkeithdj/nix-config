local nvim_lsp = require("lspconfig")
return {
    -- add pyright to lspconfig
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
        ----@type lspconfig.options
        servers = {
            -- nginx_language_server = {},
            solc = {},
            nixd = {
                settings = {
                    nixd = {
                        formatting = {
                            command = { "alejandra" },
                        },
                    },
                },
            },
            -- pyright will be automatically installed with mason and loaded with lspconfig
            -- pyright = {},
            lua_ls = {
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = { "use", "vim" },
                        },
                        hint = {
                            enable = true,
                            setType = true,
                        },
                        telemetry = {
                            enable = false,
                        },
                        workspace = {
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                                [vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true,
                                [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
                            },
                            maxPreload = 100000,
                            preloadFileSize = 10000,
                        },
                    },
                },
            },
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
}
