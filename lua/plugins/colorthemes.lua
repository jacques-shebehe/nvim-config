return {
  { 'webhooked/oscura.nvim', enabled = true, lazy = false, priority = 1000, opts = {} },
  { 'Mofiqul/vscode.nvim', enabled = true, lazy = false, priority = 1000, opts = {} },
  { 'slugbyte/lackluster.nvim', enabled = true, lazy = false, priority = 1000, opts = {} },
  { 'projekt0n/github-nvim-theme', enabled = true, lazy = false, priority = 1000 },
  { 'forest-nvim/sequoia.nvim', enabled = false, lazy = false, priority = 1000 },
  { 'shaunsingh/nord.nvim', enabled = false, lazy = false, priority = 1000 },
  { 'folke/tokyonight.nvim', enabled = false, lazy = false, priority = 1000 },
  { 'EdenEast/nightfox.nvim', enabled = false, lazy = false, priority = 1000 },
  { 'p00f/alabaster.nvim', enabled = true, lazy = false, priority = 1000 },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    enabled = false,
    lazy = false,
    priority = 1000,
  },

  {
    'armannikoyan/rusty',
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      underline_current_line = true,
    },
  },

  {
    'oxfist/night-owl.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {},
  },

  {
    'rebelot/kanagawa.nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {},
  },

  {
    'olimorris/onedarkpro.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
  },

  {
    'neanias/everforest-nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
  },
  -- in your lazy.nvim plugin spec:
  {
    -- in your lazy.nvim plugin spec:
    'loctvl842/monokai-pro.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local monokai = require 'monokai-pro'

      -- initial state
      local transparent = false

      local function apply_theme()
        monokai.setup {
          transparent_background = transparent,
          -- ... your other options here ...
          terminal_colors = true,
          devicons = true,
          styles = {
            comment = { italic = true },
            keyword = { italic = true },
            type = { italic = true },
            storageclass = { italic = true },
            structure = { italic = true },
            parameter = { italic = true },
            annotation = { italic = true },
            tag_attribute = { italic = true },
          },
          filter = 'pro',
          background_clear = {
            'float_win',
            'toggleterm',
            'telescope',
            'which-key',
            'renamer',
            'notify',
            -- add others you want cleared
          },
          plugins = {
            bufferline = {
              underline_selected = false,
              underline_visible = false,
            },
            indent_blankline = {
              context_highlight = 'default', -- or "pro"
              context_start_underline = false,
            },
          },
          override = function(colors)
            return {}
          end,
        }

        -- apply the colorscheme
        vim.cmd.colorscheme 'monokai-pro'
      end

      -- call initially
      apply_theme()

      -- define toggle
      local function toggle_transparency()
        transparent = not transparent
        apply_theme()
        vim.notify('Monokai‑Pro transparency: ' .. (transparent and 'ON' or 'OFF'))
      end

      -- map <leader>bg to toggle
      vim.keymap.set('n', '<leader>bg', toggle_transparency, { desc = 'Toggle transparency bg' })
    end,
    -- }
    -- }
    --       require('monokai-pro').setup()
    --       local bg_transparent = true
    --       local toggle_transparency = function()
    --         bg_transparent = not bg_transparent
    --         vim.g.transparent_background = bg_transparent
    --         vim.cmd [[colorscheme monokai-pro]]
    --       end
    --       vim.keymap.set(
    --         'n',
    --         '<leader>bg',
    --         toggle_transparency,
    --         { noremap = true, silent = true, desc = 'Toggle Background' }
    --       )
    --     end,
  },
  -- color html colors
  {
    'NvChad/nvim-colorizer.lua',
    enabled = true,
    opts = {
      filetypes = { '*' },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue or blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = false, -- CSS rgb() and rgba() functions
        hsl_fn = false, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = 'background', -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        -- True is same as normal
        tailwind = false, -- Enable tailwind colors
        -- parsers can contain values used in |user_default_options|
        sass = { enable = false, parsers = { 'css' } }, -- Enable sass colors
        virtualtext = '■',
        -- update color values even if buffer is not focused
        -- example use: cmp_menu, cmp_docs
        always_update = false,
        -- all the sub-options of filetypes apply to buftypes
      },
      buftypes = {},
    },
  },
}
