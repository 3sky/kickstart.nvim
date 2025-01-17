local conf = require('telescope.config').values
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local plenary = require 'plenary'
local log = require('plenary.log').new {
  plugin = 'telescope_docker',
  level = 'info',
}

---@class TDModule
---@field config TDConfig
---@field setup fun(TDConfig): TDModule

---@class TDConfig
local M = {}

---@param args string[]
---@return string[]
M._make_cdk_command = function(args)
  local job_opts = {
    command = 'cdk',
    args = vim.tbl_flatten { args, '--json' },
  }
  log.info('Running job', job_opts)
  local job = plenary.job:new(job_opts):sync()
  log.info('Ran job', vim.inspect(job))
  return job
end

M.docker_list = function(opts)
  pickers
    .new(opts, {
      finder = finders.new_dynamic {
        fn = function()
          return M._make_cdk_command { 'list' }
        end,

        entry_maker = function(entry)
          log.info('Got entry', entry)
          local process = vim.json.decode(entry)
          log.info('Got entry', process)
        end,
      },

      sorter = conf.generic_sorter(opts),
    })
    :find()
end

---@param config TDConfig
M.setup = function(config)
  M.config = config
end

return M
