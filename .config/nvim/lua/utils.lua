local utils = {}

---@param repo string 仓库名称
---@return string
function utils.gh(repo)
	return 'https://github.com/' .. repo
end

-- 有些插件需要用make等工具编译c代码
---@param name string 构建名，一般用插件名字
---@param cmd string[] 构建指令
---@param cwd string 构建时指定的工作目录
function utils.run_build(name, cmd, cwd)
	local result = vim.system(cmd, { cwd = cwd }):wait()
	if result.code ~= 0 then
		local stderr = result.stderr or ''
		local stdout = result.stdout or ''
		local output = stderr ~= '' and stderr or stdout
		if output == '' then
			output = 'No output from build command.'
		end
		vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
	end
end

return utils
