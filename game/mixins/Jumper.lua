Jumper = {
    jumperInit = function(self, jump_a, jumps_left)
        self.jump_a = jump_a
        self.max_jumps = jumps_left
        self.jumps_left = jumps_left 
        self.jump_down = false
        self.on_ground = false
        self.falling = false
        self.jump_normal = Vector(0, 0)

        beholder.observe('COLLISION ENTER' .. self.id, function(nx, ny) if ny > 0 then self.on_ground = true end end)
        beholder.observe('JUMP' .. self.id, function() self.jump_down = true end)
        beholder.observe('JUMP RELEASED' .. self.id, function() self.jump_down = false end)
        beholder.observe('JUMP PRESSED' .. self.id, function() 
            local x, y = self.body:getLinearVelocity()
            if self.jumps_left >= 1 then 
                self.jumps_left = self.jumps_left - 1
                self.on_ground = false
                self.body:setLinearVelocity(x, self.jump_a)
            end 
        end)
    end,

    jumperUpdate = function(self, dt)
        local x, y = self.body:getLinearVelocity() 

        if y > 0 then self.falling = true else self.falling = false end

        -- Stops going up whenever jump key isn't being pressed
        if not self.falling then
            if not self.jump_down then
                self.body:setLinearVelocity(x, 0)
            end
        end

        -- Resets jumps left when on ground
        if self.on_ground then
            self.jumps_left = self.max_jumps

            -- Jumps again if jump key is down
            if self.jump_down then
                beholder.trigger('JUMP PRESSED' .. self.id)
            end
        end
    end
}
