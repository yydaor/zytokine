require 'systems/Collision'
require 'systems/Spawner'
require 'systems/CameraShake'

Level = class('Level')

function Level:initialize(name)
    self.name = name

    -- Systems
    self.chrono = Chrono()
    self.collision = Collision()
    self.spawner = nil
    self.camera = Camera(GAME_WIDTH/2, GAME_HEIGHT/2)
    self.camera_shake = CameraShake(self.camera)
    
    -- Physics
    love.physics.setMeter(PHYSICS_METER)
    self.world = love.physics.newWorld(0, PHYSICS_METER*PHYSICS_GRAVITY, true)
    self.world:setCallbacks(self.collision.onEnter, self.collision.onExit) 

    -- Game objects
    self.player = nil
    self.itembox = nil
    self.solids = {}
    self.projectiles = {}
    self.enemies = {}
    self.areas = {}
    self.texts = {}
    self:load()

    -- Aux
    self.to_be_created = {}

    -- Messages
    beholder.observe('REMOVE', function(object) self:remove(object) end)

    beholder.observe('CREATE PROJECTILE', function(x, y, angle, 
        projectile_movement_type, projectile_movement_subtype, projectile_modifier)
        table.insert(self.to_be_created, {type = 'Projectile', values = {x, y, angle, 
        projectile_movement_type, projectile_movement_subtype, projectile_modifier}})
    end)

    beholder.observe('CREATE ENEMY', function(x, y, direction)
        table.insert(self.enemies, Enemy(self.chrono, self.world, x, y, direction))
    end)

    beholder.observe('CREATE ITEMBOX', function(box_type)
        local getItemboxId = function() if self.itembox then return self.itembox.id else return nil end end
        local id = getItemboxId()
        local x, y = math.random(64, 736), table.choose(ITEMBOX_POSSIBLE_Y)
        self.itembox.body:destroy()
        self.itembox = nil
        table.insert(self.to_be_created, {type = 'ItemBox', values = {box_type, x, y}})
        table.insert(self.texts, MovingText(self.chrono, id, x, y, box_type))
    end)

    beholder.observe('SHAKE', function(intensity, duration)
        self.camera_shake:add(intensity, duration)
    end)
end

function Level:update(dt)
    self.chrono:update(dt)
    self.camera_shake:update(dt)
    self.player:update(dt)
    if self.itembox then self.itembox:update(dt) end
    for _, projectile in ipairs(self.projectiles) do projectile:update(dt) end
    for _, enemy in ipairs(self.enemies) do enemy:update(dt) end
    for _, area in ipairs(self.areas) do area:update(dt) end

    self.world:update(dt)

    self:safeRemoveGroup('projectiles')
    self:safeRemoveGroup('enemies')
    self:safeRemoveGroup('areas')

    self:createObjectsPostWorldStep()
end

function Level:draw()
    self.camera:attach()
    self.player:draw()
    if self.itembox then self.itembox:draw() end
    for _, projectile in ipairs(self.projectiles) do projectile:draw() end
    for _, enemy in ipairs(self.enemies) do enemy:draw() end
    for _, area in ipairs(self.areas) do area:draw() end
    for _, solid in ipairs(self.solids) do solid:draw() end
    for _, text in ipairs(self.texts) do text:draw() end
    self.camera:detach()
end

function Level:load()
    self.player = Player(self.chrono, self.world, levels[self.name].player.x, levels[self.name].player.y)
    self.spawner = Spawner(self.chrono, levels[self.name].spawner.x, levels[self.name].spawner.y)
    self.itembox = ItemBox(self.chrono, self.world, math.random(48, 752), table.choose(ITEMBOX_POSSIBLE_Y), 'UNDEFINED')

    for _, solid in ipairs(levels[self.name].solids) do
        table.insert(self.solids, Solid(self.chrono, self.world, solid.x, solid.y, solid.w, solid.h))
    end
end

function Level:createObjectsPostWorldStep()
    local to_be_removed = {}

    for i, object in ipairs(self.to_be_created) do
        if object.type == 'Projectile' then
            table.insert(self.projectiles, Projectile(self.chrono, self.world, 
                         object.values[1], object.values[2], object.values[3],
                         object.values[4], object.values[5], object.values[6], 
                         object.values[7]))

        elseif object.type == 'ItemBox' then
            self.itembox = ItemBox(self.chrono, self.world, object.values[2], object.values[3], object.values[1])
        end
         
        table.insert(to_be_removed, i)
    end

    
    for i = #to_be_removed, 1, -1 do table.remove(self.to_be_created, to_be_removed[i]) end
end

function Level:remove(object)
    if instanceOf(MovingText, object) then
        table.remove(self.texts, findIndexByID(self.texts, object.id))
    end
end

function Level:safeRemoveGroup(type)
    for i = #self[type], 1, -1 do
        if self[type][i].dead then
            self[type][i].body:destroy()
            table.remove(self[type], i)
        end
    end
end

function Level:keypressed(key)
    self.player:keypressed(key)
end

function Level:keyreleased(key)
    self.player:keyreleased(key)
end
