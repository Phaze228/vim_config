return {
   {
    'rose-pine/neovim',
    as = 'rose-pine',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'rose-pine-moon'
      vim.cmd 'hi Normal ctermbg=None guibg=None'
      vim.cmd 'hi NormalNC ctermbg=None guibg=None'
      vim.cmd 'hi @keyword guifg=#c4a7e7 gui=None'
      vim.cmd 'hi Exception guifg=#dda15e gui=None'
      vim.cmd 'hi Operator guifg=#fca311 gui=None'
      vim.cmd 'hi @lsp.type.property guifg=#a3b18a gui=None'
      vim.cmd 'hi @lsp.type.parameter guifg=#b5838d gui=italic'
      vim.cmd 'hi @lsp.type.declaration guifg=#d19a66 gui=None'
      vim.cmd 'hi Type guifg=#d19a66 gui=None'
      vim.cmd 'hi @constant guifg=#bc6c25 gui=bold' --d4a373
      vim.cmd 'hi @variable gui=None'
      vim.cmd 'hi @keyword.exception guifg=#d90429'
      vim.cmd 'hi @function.builtin.zig guifg=#00B4D8'
      vim.cmd 'hi @lsp.type.enumMember.zig guifg=#e9c46a'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  { 'folke/tokyonight.nvim' },
  { 'sainnhe/gruvbox-material', as = 'gruvbox' },
  { 'navarasu/onedark.nvim', as = 'onedark' },
  { 'sainnhe/everforest', as = 'everforest' },
  }
