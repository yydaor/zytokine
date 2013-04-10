Logic = {
    logicInit = function(self, hp)
        self.hp = hp
        self.hit_red = false
        self.dotted = false
        self.dotted_cid = nil
        self.slowed = false
        self.slowed_cid = nil
        self.stunned = false
        self.stunned_cid = nil

        beholder.observe('HP DECREASE' .. self.id, function(damage)
            if damage then 
                self.hp = self.hp - damage 
                beholder.trigger('DAMAGE POP', self.p.x, self.p.y, damage)
            end
            if self.hp <= 0 then self.dead = true end
        end)

        beholder.observe('HIT RED' .. self.id, function()
            self.hit_red = true
            self.chrono:after(0.1, function() self.hit_red = false end)
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

    setDot = function(self, interval, times, damage)
        if not self.dotted then
            self.dotted = true
            self.dotted_cid = self.chrono:every(interval, times, function()
                beholder.trigger('HP DECREASE' .. self.id, damage)
            end):after(interval*times, function() self.dotted = false end).id
        else
            self.dotted = true
            self.chrono:cancel(self.dotted_cid)
            self.dotted_cid = self.chrono:every(interval, times, function()
                beholder.trigger('HP DECREASE' .. self.id, damage)
            end):after(interval*times, function() self.dotted = false end).id
        end
    end,

    logicUpdate = function(self, dt)
        local x, y = self.body:getPosition()
        -- Screen pass through
        if y >= 544 then 
            self.body:setY(-32)
        elseif y <= -32 then 
            self.body:setY(544)
        end
    end
}
