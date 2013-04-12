struct = require 'struct/struct'
Camera = require 'hump.camera'
require 'utils'
require 'SkillTree'
require 'Vector'

function loadImages()
    background = love.graphics.newImage('resources/background.png')
    instant = love.graphics.newImage('resources/instant.png')
    dot = love.graphics.newImage('resources/dot.png')
end


function love.load()
    loadImages()

    width = love.graphics.getWidth() 
    height = love.graphics.getHeight()
    camera = Camera(width/2, height/2)

    skill_tree = SkillTree()
    skill_tree:addNode(Node('Instant', SkillNode(Vector(100, 100), instant, 1)))

    last_mouse = Vector() 
    current_mouse = Vector() 

    -- Logic controls
    at_least_one_selected = false
end

function love.update(dt)
    -- Move around the tree
    last_mouse.x, last_mouse.y = current_mouse.x, current_mouse.y
    current_mouse.x, current_mouse.y = love.mouse.getPosition()
    local d = current_mouse - last_mouse

    if love.mouse.isDown('l') then
        if not at_least_one_selected then
            camera:move(-d.x*(1/camera.scale), -d.y*(1/camera.scale))
        else 
            skill_tree:moveNodeTo(at_least_one_selected, d.x*(1/camera.scale), d.y*(1/camera.scale))
        end
    end

    skill_tree:update(dt, camera:mousepos())
end

function love.draw()
    camera:attach()
    love.graphics.draw(background, 0, 0)
    skill_tree:draw()
    camera:detach()
end

function love.mousepressed(x, y, button)
    -- Zoom in
    if button == 'wu' then 
        if camera.scale < 2 then camera:zoom(1.2) end

    -- Zoom out
    elseif button == 'wd' then 
        if camera.scale > 0.5 then camera:zoom(0.8) end
    end
end

