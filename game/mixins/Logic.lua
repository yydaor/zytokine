Logic = {
    logicInit = function(self, hp)
        self.hp = hp
        self.slowed = false
        self.slowed_cid = nil
        self.stunned = false
        self.stunned_cid = nil

        beholder.observe('HP DECREASE' .. self.id, function(damage)
            self.hp = self.hp - damage
            if self.hp <= 0 then self.dead = true end
        end)
    end,

    setSlow = function(self, value, duration)
        if not self.slowed then
            self.slowed = true
            self.max_v = self.max_v*value
            self.slowed_cid = self.chrono:after(duration, function() 
                self.slowed = false
                self.max_v = self.init_max_v 
            end).id

        else
            self.chrono:cancel(self.slowed_cid)
            self.slowed_cid = self.chrono:after(duration, function()
                self.slowed = false
                self.max_v = self.init_max_v
            end).id
        end
    end,

    setStun = function(self, duration)
        if not self.stunned then
            self.stunned = true
            self.can_move = false
            self.stunned_cid = self.chrono:after(duration, function() 
                self.stunned = false
                self.can_move = true
            end).id
        else 
            self.chrono:cancel(self.stunned_cid)
            self.stunned_cid = self.chrono:after(duration, function()
                self.stunned = false
                self.can_move = true
            end).id
        end
    end,

    logicUpdate = function(self, dt)
        local x, y = self.body:getPosition()
        -- Screen pass through
        if y >= 544 then 
            self.body:setY(-32)
        end
    end
}
