if true then return {} end
return {
    "jmbuhr/otter.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/nvim-cmp", -- optional, for completion
        "nvim-treesitter/nvim-treesitter",
    },
    config = function() require("otter").activate({ "javascript", "python", "bash", "lua" }, true, true, nil) end,
}
