-- if true then return {} end
return {
    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = { style = "moon" },
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "tokyonight-moon",
        },
    },
}
