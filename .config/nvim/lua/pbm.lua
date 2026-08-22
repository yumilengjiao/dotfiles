---@class PluginBlock
---@field name string
---@field init function
---@field dependencies string[]
---@field options table | nil

---@class Node
---@field name string
---@field pb PluginBlock
---@field dependencies Node[] | nil

---@class PluginBlockManager
---@field pbCollection PluginBlock[]
---@field nodes table<string,Node>
---@field idCounter integer
---@field nodesInited table<string,boolean>
local PluginBlockManager = {
	pbCollection = {},
	nodes = {},
	idCounter = 0,
	nodesInited = {},
}

function PluginBlockManager:run()
	for _, v in pairs(PluginBlockManager.pbCollection) do
		self:insertNode(v)
	end
	for _, v in pairs(PluginBlockManager.nodes) do
		self:initPlugins(v.name)
	end
end

---@param self PluginBlockManager
---@param pluginBlock PluginBlock
function PluginBlockManager:register(pluginBlock)
	PluginBlockManager.pbCollection[pluginBlock.name] = pluginBlock
end

---@param newPB PluginBlock
function PluginBlockManager:insertNode(newPB)
	---@type Node[]
	local dependencies = {}
	if newPB.dependencies ~= nil and #newPB.dependencies > 0 then
		---收集依赖项节点,依赖项节点不存在会创建
		for _, name in ipairs(newPB.dependencies) do
			local node = PluginBlockManager.nodes[name]
			if node == nil then
				node = PluginBlockManager:insertNode(PluginBlockManager.pbCollection[name])
			end
			table.insert(dependencies, node)
		end
	end

	---@type Node
	local newNode = {
		name = newPB.name,
		pb = newPB,
		dependencies = dependencies,
	}

	PluginBlockManager.nodes[newNode.name] = newNode
	return newNode
end

---@param name string 插件名称/id
function PluginBlockManager:initPlugins(name)
	if PluginBlockManager.nodesInited[name] then
		return
	end

	local node = PluginBlockManager.nodes[name]
	if node.dependencies ~= nil and #node.dependencies > 0 then
		for _, v in ipairs(node.dependencies) do
			PluginBlockManager:initPlugins(v.name)
		end
	end

	node.pb.init()
	PluginBlockManager.nodesInited[name] = true
end

return PluginBlockManager
