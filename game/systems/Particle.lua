Particle = class('Particle')
local ParticleSystem = struct('creation_time', 'name', 'id', 'x', 'y', 'ps')

function Particle:initialize()
    self.templates = loadstring("return " .. love.filesystem.read(main_pso))()
    self.particle_systems = {}
    self.to_be_removed = {}
    self.uid = 0
end

function Particle:spawn(name, settings)
    self.uid = self.uid + 1
    local ps = self:createPS(self:findTemplateByName(name))
    table.insert(self.particle_systems, ParticleSystem(love.timer.getTime(), name, self.uid, nil, nil, ps))
    self:set(self.uid, settings)
end

function Particle:findTemplateByName(name)
    for k, v in ipairs(self.templates) do
        if v.name == name then return v.template end
    end
end

function Particle:set(id, settings)
    if settings then
        for k, v in pairs(settings) do
            -- if k == 'rotation' then self.particle_systems[findIndexByID(..., id)].ps:setRotation(settings.rotation) end
            -- add particle parameters as needed
            if k == 'position' then 
                self.particle_systems[findIndexByID(self.particle_systems, id)].x = v.x
                self.particle_systems[findIndexByID(self.particle_systems, id)].y = v.y
            end
        end
    end
end

function Particle:createPS(template)
    local ps = love.graphics.newParticleSystem(square, template.buffer_size)
    ps:setBufferSize(template.buffer_size)
    local colors = {}
    for i = 1, 8 do
        if template.colors[i] then
            table.insert(colors, template.colors[i][1])
            table.insert(colors, template.colors[i][2])
            table.insert(colors, template.colors[i][3])
            table.insert(colors, template.colors[i][4])
        end
    end
    ps:setColors(unpack(colors))
    ps:setDirection(degToRad(template.direction))
    ps:setEmissionRate(template.emission_rate)
    ps:setGravity(template.gravity[1], template.gravity[2])
    ps:setLifetime(template.lifetime)
    ps:setOffset(template.offset[1], template.offset[2])
    ps:setParticleLife(template.particle_life[1], template.particle_life[2])
    ps:setRadialAcceleration(template.radial_acc[1], template.radial_acc[2])
    ps:setRotation(degToRad(template.rotation[1]), degToRad(template.rotation[2]))
    ps:setSizeVariation(template.size_variation)
    ps:setSizes(unpack(template.sizes))
    ps:setSpeed(template.speed[1], template.speed[2])
    ps:setSpin(degToRad(template.spin[1]), degToRad(template.spin[2]))
    ps:setSpinVariation(template.spin_variation)
    ps:setSpread(degToRad(template.spread))
    ps:setTangentialAcceleration(template.tangent_acc[1], template.tangent_acc[2])
    return ps
end

function Particle:remove(id)
    table.remove(self.particle_systems, findIndexByID(self.particle_systems, id))
end

function Particle:removePostUpdate()
    for _, id in ipairs(self.to_be_removed) do
        self:remove(id)
    end
    self.to_be_removed = {}
end

function Particle:update(dt)
    for i, p in ipairs(self.particle_systems) do
        p.ps:update(dt)
        if not p.ps:isActive() then
            table.insert(self.to_be_removed, p.id)
        end
    end
    self:removePostUpdate()
end

function Particle:draw()
    for _, p in ipairs(self.particle_systems) do 
        love.graphics.draw(p.ps, p.x, p.y)
    end
end
