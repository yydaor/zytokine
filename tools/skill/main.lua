struct = require 'struct/struct'
Camera = require 'hump.camera'
require 'utils'
require 'SkillTree'

function loadImages()
    background = love.graphics.newImage('background.png')
    reflecting_image = love.graphics.newImage('reflecting.png')
end


function love.load()
    loadImages()
    width = love.graphics.getWidth() 
    height = love.graphics.getHeight()
    camera = Camera(width/2, height/2)
    skill_tree = SkillTree()
    last_mouse = {x = 0, y = 0}
end

function love.update(dt)
    skill_tree:update(dt)

    last_mouse.x, last_mouse.y = love.mouse.getPosition()
    if love.mouse.isDown('l') then
        
    end
end

function love.draw()
    camera:attach()
    love.graphics.draw(background, 0, 0)
    skill_tree:draw()
    camera:detach()
end
