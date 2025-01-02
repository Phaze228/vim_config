-- NOTE:   https://github.com/echasnovski/mini.nvim
return {

  { --  NOTE: Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 } -- NOTE: Better around/inside textobjects
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote

      require('mini.align').setup() -- NOTE: Align to specific character

      require('mini.surround').setup() -- NOTE:  Add/Delete/Replace surrounding characters
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']

      local statusline = require 'mini.statusline' -- NOTE: Simple, configurable statusline
      statusline.setup { use_icons = vim.g.have_nerd_font } -- Enables icons if nerdfonts

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
