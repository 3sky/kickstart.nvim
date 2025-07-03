local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  s('note', {
    t '# ',
    f(function()
      return vim.fn.expand '%:t:r'
    end),
    t { '', '', '## Overview', '' },
    i(1),
    t { '', '', '## Content', '' },
    i(2),
    t { '', '', '---', '*Created: ' },
    f(function()
      return os.date '%Y-%m-%d'
    end),
    t '*',
    i(0),
  }),
}
