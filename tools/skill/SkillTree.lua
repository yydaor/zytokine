require 'Graph'

SkillTree = class('SkillTree')
SkillNode = struct('position', 'image', 'scale')
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

function SkillTree:update(dt)
    
end

function SkillTree:draw()
    love.graphics.setLineWidth(1.5)
    for k, v in pairs(self.graph.graph) do
        local x, y = v.data.position.x, v.data.position.y
        local w, h = v.data.image:getWidth(), v.data.image:getHeight()
        local scale = v.data.scale or 1
        love.graphics.draw(v.data.image, x, y, 0, scale)
    end
    love.graphics.setLineWidth(1)
end
