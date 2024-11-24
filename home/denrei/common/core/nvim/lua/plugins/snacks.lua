return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        notifier = { enabled = true, timeout = 3000 },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        styles = {
            notification = {
                wo = { wrap = true }, -- Wrap notifications
            },
        },
        dashboard = {
            preset = {
                header = [[
 ██████╗  ██████╗  ██████╗  ██████╗  ██████╗  ██████╗  ██████╗  ██████╗ 
██╔═████╗██╔═████╗██╔═████╗██╔═████╗██╔═████╗██╔═████╗██╔═████╗██╔═████╗
██║██╔██║██║██╔██║██║██╔██║██║██╔██║██║██╔██║██║██╔██║██║██╔██║██║██╔██║
████╔╝██║████╔╝██║████╔╝██║████╔╝██║████╔╝██║████╔╝██║████╔╝██║████╔╝██║
╚██████╔╝╚██████╔╝╚██████╔╝╚██████╔╝╚██████╔╝╚██████╔╝╚██████╔╝╚██████╔╝
 ╚═════╝  ╚═════╝  ╚═════╝  ╚═════╝  ╚═════╝  ╚═════╝  ╚═════╝  ╚═════╝ 
        ]],
            },
            sections = {
                { section = "header" },
                { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                { section = "startup" },
            },
        },
    },
}
