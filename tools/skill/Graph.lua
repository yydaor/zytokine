require 'middleclass/middleclass'

Graph = class('Graph')
GraphNode = struct('name', 'data')

function tableToString(table)
    local str = "{"
    for k, v in pairs(table) do
        if type(k) ~= "number" then str = str .. k .. " = " end
        if type(v) == "number" or type(v) == "boolean" then str = str .. tostring(v) .. ", "
        elseif type(v) == "string" then str = str .. "'" .. v .. "'" .. ", "
        elseif type(v) == "table" then str = str .. tableToString(v) .. ", " end
    end
    if #table > 0 then str = string.sub(str, 1, -3) end
    str = str .. "}"
    return str
end

function Graph:initialize()
    self.graph = {}
end

function Graph:addNode(node)
    self.graph[node.name] = {adjacent_to = {}, data = node.data}
end

function Graph:addEdge(node_name1, node_name2)
    table.insert(self.graph[node_name1].adjacent_to, node_name2)
    table.insert(self.graph[node_name2].adjacent_to, node_name1)
end

function Graph:removeNode(node_name)
    self.graph[node_name] = nil
    for k, v in pairs(self.graph) do
        for l, u in pairs(v.adjacent_to) do
            if u == node_name then table.remove(v.adjacent_to, l) end
        end
    end
end

function Graph:removeEdge(node_name1, node_name2)
    for k, v in pairs(self.graph[node_name1].adjacent_to) do
        if v == node_name2 then table.remove(self.graph[node_name1].adjacent_to, k) end
    end

    for k, v in pairs(self.graph[node_name2].adjacent_to) do
        if v == node_name1 then table.remove(self.graph[node_name2].adjacent_to, k) end
    end
end

function Graph:print()
    for k, v in pairs(self.graph) do
        print(k .. ": " .. tableToString(v.adjacent_to))
    end
    print()
end

