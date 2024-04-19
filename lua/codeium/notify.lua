local log = require("codeium.log")

---@class codeium.notify
local notify = {}
local opts = {
	title = "Codeium",
}

local function notify_at_level(name, level)
	return function(message, ...)
		local passed = { ... }
		vim.notify(message, level, opts)
		if #passed ~= 0 then
			vim.notify(message, level, opts)
			log[name](message .. ": ", ...)
		end
	end
end

notify.trace = notify_at_level("trace", vim.log.levels.TRACE)
notify.debug = notify_at_level("debug", vim.log.levels.DEBUG)
notify.info = notify_at_level("info", vim.log.levels.INFO)
notify.warn = notify_at_level("warn", vim.log.levels.WARN)
notify.error = notify_at_level("error", vim.log.levels.ERROR)

return notify
