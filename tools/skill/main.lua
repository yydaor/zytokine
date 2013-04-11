struct = require 'struct/struct'
Camera = require 'hump.camera'
require 'utils'
require 'Graph'

Node = struct('name', 'data')

function love.load()
    skill_graph = Graph()
    skill_graph:addNode(Node('A', 1))
    skill_graph:print()
end

