local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
    spec = {
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },

        -- { import = "lazyvim.plugins.extras.lang.nushell" },

        -- { import = "lazyvim.plugins.extras.coding.codeium" },
        { import = "lazyvim.plugins.extras.ai.copilot" },
        { import = "lazyvim.plugins.extras.coding.mini-surround" },
        { import = "lazyvim.plugins.extras.coding.luasnip" },
        { import = "lazyvim.plugins.extras.editor.leap" },

        -- { import = "lazyvim.plugins.extras.dap.core" },
        -- { import = "lazyvim.plugins.extras.dap.nlua" },

        -- { import = "lazyvim.plugins.extras.formatting.black" },
        { import = "lazyvim.plugins.extras.formatting.prettier" },

        { import = "lazyvim.plugins.extras.lang.astro" },
        { import = "lazyvim.plugins.extras.lang.clangd" },
        { import = "lazyvim.plugins.extras.lang.docker" },
        { import = "lazyvim.plugins.extras.lang.elixir" },
        { import = "lazyvim.plugins.extras.lang.git" },
        { import = "lazyvim.plugins.extras.lang.go" },
        { import = "lazyvim.plugins.extras.lang.json" },
        { import = "lazyvim.plugins.extras.lang.markdown" },
        -- "lazyvim.plugins.extras.lang.nix", -- use nixd
        -- { import = "lazyvim.plugins.extras.lang.omnisharp" },
        { import = "lazyvim.plugins.extras.lang.python" },
        { import = "lazyvim.plugins.extras.lang.rust" },
        { import = "lazyvim.plugins.extras.lang.svelte" },
        { import = "lazyvim.plugins.extras.lang.tailwind" },
        { import = "lazyvim.plugins.extras.lang.yaml" },
        { import = "lazyvim.plugins.extras.lang.typescript" },
        { import = "lazyvim.plugins.extras.lang.terraform" },

        { import = "lazyvim.plugins.extras.linting.eslint" },
        { import = "lazyvim.plugins.extras.ui.treesitter-context" },

        { import = "lazyvim.plugins.extras.vscode" },
        { import = "plugins" },
    },
    lockfile = vim.fn.stdpath("cache") .. "/lazy-lock.json",
    defaults = {
        lazy = false,
        version = false, -- always use the latest git commit
    },
    checker = { enabled = false }, -- automatically check for plugin updates
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
