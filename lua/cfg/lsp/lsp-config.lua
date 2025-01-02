return {

    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Mason LSP Installer; Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim', -- NOTE: Aids in using Mason with lsp-config
      'WhoIsSethDaniel/mason-tool-installer.nvim', -- NOTE: Convenient updater for LSPs installed by Mason

      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      -- { 'j-hui/fidget.nvim', opts = {} },
      'j-hui/fidget.nvim', -- NOTE: Status updates for LSP

      'hrsh7th/cmp-nvim-lsp', -- NOTE: Extra capes from nvim-cmp
    },
    config = function()

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_augroup('lsp-attach', {clear = true})
      vim.api.nvim_create_autocmd('LspAttach', 
         {
           group = 'lsp-attach', 
           callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local tbi = require('telescope.builtin')
          map('gd', tbi.lsp_definitions, '[G]oto [D]efinition') -- NOTE: Jump to definition of word
          --                                                                             -- <C-t> to jump back
          map('gr', tbi.lsp_references, '[G]oto [R]eferences') 

          map('gI', tbi.lsp_implementations, '[G]oto [I]mplementation') -- NOTE: To Implementation; useful for language type definitions without actual implementations

          map('gT', tbi.lsp_type_definitions, '[G]oto [T]ype')  -- NOTE: Jumps to type definition of variable

          map('<leader>ds', tbi.lsp_document_symbols, '[D]ocument [S]ymbols') -- NOTE: Fuzzy find all symbols(vars, funcs, types, etc) in current document

          map('<leader>ws', tbi.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols') -- NOTE: Fuzzy find all symbols over the project
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame') -- NOTE: Renames variable across all files

          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction') -- NOTE: Executes code action or hint on an error

          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration') -- WARN: Declaration not, Definition. In C would take you to the header file.

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities() -- NOTE: Grants neovim more capabilities with nvim-cmp,luasnip etc, and broadcasts it to the LSPS
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {             -- NOTE: Enable these LSP's
                                    --  Add any additional override configuration in the following tables. Available keys are:
                                    --  - cmd (table): Override the default command used to start the server
                                    --  - filetypes (table): Override the default list of associated filetypes for the server
                                    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
                                    --  - settings (table): Override the default settings passed when initializing the server.
                                    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --
        --
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      require('mason').setup() -- NOTE: Setup Mason with defaults

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  }




-- LSP Info
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`
