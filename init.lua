-- [Vim Initials] --
--
-- Leader Keys --
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Options --
vim.opt.number = true
vim.opt.relativenumber = true -- NOTE: Relative Numbers
vim.wo.number = true --NOTE:  Default numberline
vim.opt.signcolumn = 'yes' -- NOTE: Displays the sign in the number line
vim.opt.mouse = 'a' --NOTE: Enable Mouse
vim.opt.showmode = false -- NOTE: Disables mode indicator, due to status line
vim.opt.breakindent = true --NOTE:  Matches indent to above line
vim.opt.undofile = true -- NOTE: Keeps undo history
vim.opt.cursorline = true -- NOTE: Shows which line your cursor is on

vim.opt.ignorecase = true -- NOTE: Ignore case when matching
vim.opt.smartcase = true -- NOTE: Overrides ignorecase, if an uppercase is present

vim.opt.updatetime = 250 -- NOTE: Changes swapfile creation time
vim.opt.timeoutlen = 300 --  NOTE: Timeout Length for command to be executed

vim.opt.scrolloff = 10 -- NOTE: Minimal number of screenlines above/below the cursor
vim.opt.expandtab = true -- Convert tabs -> spaces
vim.opt.tabstop = 3 -- NOTE: Number of spaces a tab equates to
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3 -- NOTE: The next indent

vim.opt.hlsearch = true -- Set highlight on search

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus' -- NOTE: Sets clipboard to system; Done after for speed increase
end)
-- Keymaps --
-- NOTE: :help vim.keymap.set()
--
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<M-l>', '<C-w>5<', { desc = 'Resize pane 5 units to the left' })
vim.keymap.set('n', '<M-h>', '<C-w>5>', { desc = 'Resize pane 5 units to the right' })
vim.keymap.set('n', '<M-k>', '<C-w>+', { desc = 'Resize pane taller' })
vim.keymap.set('n', '<M-j>', '<C-w>-', { desc = 'Resize pane shorter' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- NOTE: No Highlight on escape
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic [Q]uickfix list' })

-- vim.keymap.set('n', 'ga', '<cmd>EasyAlign<CR>', { desc = 'Align by character' })
-- vim.keymap.set('x', 'ga', '<cmd>EasyAlign<CR>')

-- Autocommands --
-- NOTE: :help lua-guide-autocommands
--
--
vim.api.nvim_create_augroup('highlight-yank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on Yank',
  group = 'highlight-yank',
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_augroup('remember_folds', { clear = true })
vim.api.nvim_create_autocmd('BufWinLeave', {
  group = 'remember_folds',
  callback = function()
    vim.cmd 'silent! mkview'
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = 'remember_folds',
  callback = function()
    vim.cmd 'silent! loadview'
  end,
})

package.path = package.path .. ';/home/phaze/.dotfiles/nvim/.config/nvim/?.lua' -- Handle the symlink problem with using gnu Stow
require 'pkg.lazy'
