-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- paste from outside vim

local map = vim.keymap.set
vim.keymap.del("t", "<C-l>")
map("v", "<leader>p", '"_dP<CR>', {
  noremap = true,
  silent = true,
  desc = "Paste from outside vim",
})
map("n", "<leader>p", '"+p<CR>', {
  noremap = true,
  silent = true,
})

map("n", "<leader>p", '"0p', {
  noremap = true,
  silent = true,
  desc = "paste below current line",
})
map("n", "<leader>P", '"0P', {
  noremap = true,
  silent = true,
  desc = "paste on top of current line",
})

map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
-- Change text without putting it into the vim register,
-- see https://stackoverflow.com/q/54255/6064933
map("n", "c", '"_c')
map("n", "C", '"_C')
map("n", "cc", '"_cc')
map("x", "c", '"_c')

map("n", "^", "g^")
map("n", "0", "g0")
map("x", "$", "g_")

map("n", "/", [[/\v]])


if vim.g.vscode then
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }

  -- remap leader key
  keymap("n", "<Space>", "", opts)
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  -- yank to system clipboard
  keymap({ "n", "v" }, "<leader>y", '"+y', opts)

  -- paste from system clipboard
  keymap({ "n", "v" }, "<leader>p", '"+p', opts)

  -- better indent handling
  keymap("v", "<", "<gv", opts)
  keymap("v", ">", ">gv", opts)

  -- move text up and down
  keymap("v", "J", ":m .+1<CR>==", opts)
  keymap("v", "K", ":m .-2<CR>==", opts)
  keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
  keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

  -- paste preserves primal yanked piece
  keymap("v", "p", '"_dP', opts)

  -- removes highlighting after escaping vim search
  keymap("n", "<Esc>", "<Esc>:noh<CR>", opts)

  -- call vscode commands from Neovim
  keymap(
    { "n", "v" },
    "<leader>t",
    "<cmd>lua require('vscode').action('workbench.action.terminal.toggleTerminal')<CR>"
  )
  keymap({ "n", "v" }, "<leader>b", "<cmd>lua require('vscode').action('editor.debug.action.toggleBreakpoint')<CR>")
  keymap({ "n", "v" }, "S-k", "<cmd>lua require('vscode').action('editor.action.showHover')<CR>")
  keymap({ "n", "v" }, "<leader>a", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>")
  keymap({ "n", "v" }, "<leader>sp", "<cmd>lua require('vscode').action('workbench.actions.view.problems')<CR>")
  keymap({ "n", "v" }, "<leader>cn", "<cmd>lua require('vscode').action('notifications.clearAll')<CR>")
  keymap({ "n", "v" }, "<leader>ff", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>")
  keymap({ "n", "v" }, "<leader>cp", "<cmd>lua require('vscode').action('workbench.action.showCommands')<CR>")
  keymap({ "n", "v" }, "<leader>fd", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>")
  keymap({ "n", "v" }, "<C-W>o", "<cmd>lua require('vscode').action('workbench.action.toggleSidebarVisibility')<CR>")

  keymap({ "n" }, "<esc>", "<cmd>lua require('vscode').action('vsnetrw.close')<CR>")

  vim.opt.clipboard = "unnamedplus"
  vim.opt.updatetime = 50
end
