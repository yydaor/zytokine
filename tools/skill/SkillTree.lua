require 'Graph'

SkillTree = class('SkillTree')
SkillNode = struct('position', 'image', 'scale', 'selected')
Node = struct('name', 'data')

function SkillTree:initialize()
    self.graph = Graph() 
end

function SkillTree:addNode(node)
    self.graph:addNode(node)
end

function SkillTree:addEdge(node_name1, node_name2)
    self.graph:addEdge(node_name1, node_name2)   
end

function SkillTree:moveNodeTo(node_name, dx, dy)
    self.graph.graph[node_name].data.position.x = self.graph.graph[node_name].data.position.x + dx
    self.graph.graph[node_name].data.position.y = self.graph.graph[node_name].data.position.y + dy
end

function SkillTree:update(dt, m_x, m_y)
    at_least_one_selected = false
    for k, v in pairs(self.graph.graph) do
        local x, y = v.data.position.x, v.data.position.y
        local w, h = v.data.image:getWidth(), v.data.image:getHeight()
        local scale = v.data.scale or 1
        if m_x >= x and m_x <= x+w and m_y >= y and m_y <= y+h then
            v.data.selected = true
            at_least_one_selected = k
        else v.data.selected = false end
    end
end

function SkillTree:draw()
    for k, v in pairs(self.graph.graph) do
        local x, y = v.data.position.x, v.data.position.y
        local w, h = v.data.image:getWidth(), v.data.image:getHeight()
        local scale = v.data.scale or 1
        if v.data.selected then
            love.graphics.setColorMode('combine')
            love.graphics.setColor(240, 192, 240)
            love.graphics.draw(v.data.image, x, y, 0, scale)
            love.graphics.setColor(255, 255, 255)
            love.graphics.setColorMode('replace')
        else love.graphics.draw(v.data.image, x, y, 0, scale) end
    end
end
