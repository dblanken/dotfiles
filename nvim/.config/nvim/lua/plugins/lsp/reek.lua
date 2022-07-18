local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

local handle_reek_output = function(params)
  print(vim.inspect(params))
  if params.output then
    local smells = {}

    for _, finding in pairs(params.output) do
      for _, line in pairs(finding.lines) do
        local parser = h.diagnostics.from_json({
          severities = {
            info = h.diagnostics.severities.information,
            refactor = h.diagnostics.severities.hint,
            convention = h.diagnostics.severities.warning,
            warning = h.diagnostics.severities.warning,
            error = h.diagnostics.severities.error,
            fatal = h.diagnostics.severities.fatal,
          },
        })

        table.insert(smells, {
          message = "[reek] " .. finding.message,
          ruleId = finding.smell_type,
          level = "info",
          column = 0,
          line = line,
          endLine = line,
          endColumn = 0,
        })

        return parser({ output = smells })
      end
    end

    return {}
  end
end

return h.make_builtin({
  name = "reek",
  meta = {
    url = "https://github.com/troessner/reek",
    description = "Code smell detector in Ruby",
  },
  method = DIAGNOSTICS,
  filetypes = { "ruby" },
  generator_opts = {
    command = "reek",
    args = { "-f", "json", "$FILENAME" },
    to_stdin = false,
    format = "json",
    check_exit_code = function(code)
      -- return code <= 1
      return true
    end,
    on_output = handle_reek_output,
  },
  factory = h.generator_factory,
})


