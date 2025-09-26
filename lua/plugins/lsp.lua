return {

  { -- for lsp features in code cells / embedded code
    'jmbuhr/otter.nvim',
    dev = false,
    dependencies = {
      {
        'neovim/nvim-lspconfig',
        'nvim-treesitter/nvim-treesitter',
      },
    },
    opts = {},
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
      {
        'j-hui/fidget.nvim',
        enabled = false,
        opts = {},
      },
      {
        {
          'folke/lazydev.nvim',
          ft = 'lua',
          opts = {
            library = {
              { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            },
          },
        },
        { 'Bilal2453/luvit-meta', lazy = true },
      },
      { 'folke/neoconf.nvim', opts = {}, enabled = false },
    },
    config = function()
      local util = require 'lspconfig.util'

      require('mason').setup {
        ensure_installed = {
          'lua-language-server',
          'bash-language-server',
          'css-lsp',
          'html-lsp',
          'json-lsp',
          'haskell-language-server',
          'pyright',
          'r-languageserver',
          'texlab',
          'dotls',
          'svelte-language-server',
          'typescript-language-server',
          'yaml-language-server',
          'clangd',
          'emmet-ls',
          'sqlls',
        },
      }
      require('mason-tool-installer').setup {
        ensure_installed = {
          'black',
          'stylua',
          'shfmt',
          'isort',
          'tree-sitter-cli',
          'jupytext',
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local function map(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          assert(client, 'LSP client not found')

          ---@diagnostic disable-next-line: inject-field
          client.server_capabilities.document_formatting = true

          map('gd', vim.lsp.buf.definition, '[g]o to [d]efinition')
          map('gD', vim.lsp.buf.type_definition, '[g]o to type [D]efinition')
          map('<leader>lq', vim.diagnostic.setqflist, '[l]sp diagnostic [q]uickfix')
        end,
      })

      local lsp_flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 150,
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities({}, true)

      -------------------------------------------------------------------
      -- Example: R language server
      -------------------------------------------------------------------
      vim.lsp.config('r_language_server', {
        capabilities = capabilities,
        flags = lsp_flags,
        filetypes = { 'r', 'rmd', 'rmarkdown' },
        settings = {
          r = {
            lsp = {
              rich_documentation = true,
              diagnostics = { linters = 'none' },
            },
          },
        },
      })

      vim.lsp.config('cssls', { capabilities = capabilities, flags = lsp_flags })
      vim.lsp.config('svelte', { capabilities = capabilities, flags = lsp_flags })
      vim.lsp.config('yamlls', {
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          yaml = { schemaStore = { enable = true, url = '' } },
        },
      })
      vim.lsp.config('jsonls', { capabilities = capabilities, flags = lsp_flags })
      vim.lsp.config('texlab', { capabilities = capabilities, flags = lsp_flags })
      vim.lsp.config('dotls', { capabilities = capabilities, flags = lsp_flags })
      vim.lsp.config('tsserver', {
        capabilities = capabilities,
        flags = lsp_flags,
        filetypes = { 'js', 'javascript', 'typescript', 'ojs' },
      })

      local function get_quarto_resource_path()
        local function strsplit(s, delimiter)
          local result = {}
          for match in (s .. delimiter):gmatch('(.-)' .. delimiter) do
            table.insert(result, match)
          end
          return result
        end
        local f = assert(io.popen('quarto --paths', 'r'))
        local s = assert(f:read '*a')
        f:close()
        return strsplit(s, '\n')[2]
      end

      local lua_library_files = vim.api.nvim_get_runtime_file('', true)
      local resource_path = get_quarto_resource_path()
      if resource_path then
        table.insert(lua_library_files, resource_path .. '/lua-types')
      else
        vim.notify_once 'quarto not found, lua library files not loaded'
      end

      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            runtime = { version = 'LuaJIT' },
            diagnostics = { disable = { 'trailing-space' } },
            workspace = { checkThirdParty = false },
            doc = { privateName = { '^_' } },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config('vimls', { capabilities = capabilities, flags = lsp_flags })
      vim.lsp.config('julials', { capabilities = capabilities, flags = lsp_flags })
      vim.lsp.config('bashls', {
        capabilities = capabilities,
        flags = lsp_flags,
        filetypes = { 'sh', 'bash' },
      })
      vim.lsp.config('clangd', { capabilities = capabilities, flags = lsp_flags })
      vim.lsp.config('rust_analyzer', { capabilities = capabilities, flags = lsp_flags })

      -- Disable watchers (pyright issue on Linux)
      if capabilities.workspace == nil then
        capabilities.workspace = {}
        capabilities.workspace.didChangeWatchedFiles = {}
      end
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      vim.lsp.config('pyright', {
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'workspace',
            },
          },
        },
        root_dir = function(fname)
          return util.root_pattern('.git', 'setup.py', 'setup.cfg', 'pyproject.toml', 'requirements.txt')(fname)
        end,
      })

      -------------------------------------------------------------------
      -- Finally enable all defined servers
      -------------------------------------------------------------------
      vim.lsp.enable {
        'r_language_server',
        'cssls',
        'svelte',
        'yamlls',
        'jsonls',
        'texlab',
        'dotls',
        'tsserver',
        'lua_ls',
        'vimls',
        'julials',
        'bashls',
        'clangd',
        'rust_analyzer',
        'pyright',
      }
    end,
  },
}
