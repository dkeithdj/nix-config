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

        "lazyvim.plugins.extras.coding.codeium",
        "lazyvim.plugins.extras.coding.copilot",
        "lazyvim.plugins.extras.coding.mini-surround",

        "lazyvim.plugins.extras.dap.core",
        "lazyvim.plugins.extras.dap.nlua",

        "lazyvim.plugins.extras.formatting.black",
        "lazyvim.plugins.extras.formatting.prettier",

        "lazyvim.plugins.extras.lang.astro",
        "lazyvim.plugins.extras.lang.clangd",
        "lazyvim.plugins.extras.lang.docker",
        "lazyvim.plugins.extras.lang.elixir",
        "lazyvim.plugins.extras.lang.git",
        "lazyvim.plugins.extras.lang.go",
        "lazyvim.plugins.extras.lang.json",
        "lazyvim.plugins.extras.lang.markdown",
        "lazyvim.plugins.extras.lang.nix", -- use nixd
        "lazyvim.plugins.extras.lang.omnisharp",
        "lazyvim.plugins.extras.lang.python",
        "lazyvim.plugins.extras.lang.rust",
        "lazyvim.plugins.extras.lang.svelte",
        "lazyvim.plugins.extras.lang.tailwind",
        "lazyvim.plugins.extras.lang.yaml",
        "lazyvim.plugins.extras.lang.typescript",

        "lazyvim.plugins.extras.linting.eslint",
        "lazyvim.plugins.extras.ui.treesitter-context",

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
