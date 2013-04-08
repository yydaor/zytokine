CameraShake = class('CameraShake')
local Shake = struct('creation_time', 'id', 'intensity', 'duration')

function CameraShake:initialize(camera)
    self.camera = camera
    self.x, self.y = camera:pos()
    self.shakes = {}
    self.shake_intensity = 0
    self.uid = 0
end

function CameraShake:add(intensity, duration)
    self.uid = self.uid + 1
    table.insert(self.shakes, Shake(love.timer.getTime(), self.uid, intensity, duration))
end

function CameraShake:remove(id)
    table.remove(self.shakes, findIndexByID(self.shakes, id))
end

function CameraShake:update()
    self.shake_intensity = 0
    for _, shake in ipairs(self.shakes) do
        if love.timer.getTime() > shake.creation_time + shake.duration then
            self:remove(shake.id)
        else self.shake_intensity = self.shake_intensity + shake.intensity end
    end

    self.camera:lookAt(self.x + math.random(-self.shake_intensity, self.shake_intensity), 
                       self.y + math.random(-self.shake_intensity, self.shake_intensity))
    
    if self.shake_intensity == 0 then self.camera:lookAt(self.x, self.y) end
end
