-- Bootstrap Lazy --
--
-- NOTE: Checks for lazy.nvim; if not found, clones; error if fails.
local lazyPath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazyPath) then
  local lazyRepo = 'https://github.com/folke/lazy.nvim.git'
  local cloned = vim.fn.system { 'git', 'clone', '--filiter=blob:none', '--branch=stable', lazyRepo, lazyPath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { '[ERROR] - Could not clone Lazy.nvim:\n', 'ErrorMsg' },
      { cloned, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.runtimepath:prepend(lazyPath) -- NOTE: adds Lazy to the nvim path; Prepends to ensure it's installed before plugins.

-- Setup Lazy --
require('lazy').setup {
  spec = {
    { 'tpope/vim-sleuth' },
    { import = 'cfg.colorschemes' },
    { import = 'cfg.lsp' },
    { import = 'cfg.nav' },
    { import = 'cfg.utils' },
    { import = 'cfg.treesitter' },
    { import = 'cfg.flutter' },
  },
}
