return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
        config = function()
          -- Load snippets from lua files
          require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/snippets/' }

          -- Set up keybindings that don't conflict with blink.cmp
          local ls = require 'luasnip'

          -- Use different keys for LuaSnip to avoid conflicts
          vim.keymap.set({ 'i', 's' }, '<C-j>', function()
            if ls.expand_or_jumpable() then
              ls.expand_or_jump()
            end
          end, { silent = true })

          vim.keymap.set({ 'i', 's' }, '<C-k>', function()
            if ls.jumpable(-1) then
              ls.jump(-1)
            end
          end, { silent = true })

          -- Alternative: Use a specific expansion key
          vim.keymap.set('i', '<C-l>', function()
            if ls.expandable() then
              ls.expand()
            end
          end, { silent = true })
        end,
      },
      'folke/lazydev.nvim',
    },

    opts = {
      keymap = {
        preset = 'default',
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },
      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },
}
