local notify = require("codeium.notify")

---@class codeium.config
---@field options codeium.options
local config = {}

---@return codeium.options
function config.defaults()
	return {
		manager_path = nil,
		bin_path = vim.fn.stdpath("cache") .. "/codeium/bin",
		config_path = vim.fn.stdpath("cache") .. "/codeium/config.json",
		language_server_download_url = "https://github.com",
		api = {
			host = "server.codeium.com",
			port = "443",
			path = "/",
			portal_url = "codeium.com",
		},
		enterprise_mode = nil,
		detect_proxy = nil,
		tools = {},
		wrapper = nil,
		enable_chat = false,
		enable_local_search = false,
		enable_index_service = false,
		search_max_workspace_file_count = 5000,
	}
end

function config.installation_defaults()
	local has_installed, installed_config = pcall(require, "codeium.installation_defaults")
	if has_installed then
		return installed_config
	else
		return {}
	end
end

function config.apply_conditional_defaults(options)
	if options.enterprise_mode then
		if options.api == nil then
			options.api = {}
		end

		if options.api.path == nil then
			options.api.path = "/_route/api_server"
		end

		if options.api.host == nil then
			notify.warn("You need to specify api.host in enterprise mode")
		else
			if options.api.portal_url == nil then
				options.api.portal_url = options.api.host .. ":" .. (options.api.port or "443")
			end
		end
	end

	return options
end

---@class codeium.options
---@field manager_path string
---@field bin_path string
---@field config_path string
---@field language_server_download_url string
---@field api table
---@field enterprise_mode boolean
---@field detect_proxy boolean
---@field tools table
---@field wrapper function
---@field enable_chat boolean
---@field enable_local_search boolean
---@field enable_index_service boolean
---@field search_max_workspace_file_count number
config.options = {}

---@param options codeium.options|nil
function config.setup(options)
	options = options or {}

	options = config.apply_conditional_defaults(options)

	config.options = vim.tbl_deep_extend("force", {}, config.defaults(), config.installation_defaults(), options)
end

return config
