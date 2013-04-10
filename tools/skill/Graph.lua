require 'middleclass/middleclass'
require 'struct/struct'

Graph = class('Graph')
GraphNode = struct('name')

function Graph:initialize()
    self.graph = {}
    self.nodes = {}
end

function Graph:addNode(node)
    table.insert(self.nodes, node)
    table.insert(self.graph, {})
end

function Graph:addEdge(node_name1, node_name2)
    local i, j = self:getNodeIndexByName(node_name1), self:getNodeIndexByName(node_name2)
    self.graph[i][j] = true
    self.graph[j][i] = true
end

function Graph:getNode(name)
    return self.nodes[self:getNodeIndexByName(name)]
end

function Graph:getNodeIndexByName(name)
    for i, n in ipairs(self.nodes) do
        if n.name == name then return i end
    end
end

function Graph:removeNode(node_name)
    local n = self:getNodeIndexByName(node_name)
    table.remove(self.nodes, n)
    for i = 1, #self.graph do table.remove(self.graph[i], n) end
    table.remove(self.graph, n)
end

function Graph:removeEdge(node_name1, node_name2)
    local i, j = self:getNodeIndexByName(node_name1), self:getNodeIndexByName(node_name2)
    self.graph[i][j] = nil 
    self.graph[j][i] = nil
end


