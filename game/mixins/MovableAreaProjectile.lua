MovableAreaProjectile = {
    movableAreaProjectileInit = function(self, angle, projectile_area_movement_type, projectile_area_movement_subtype)
        self.movement_type = projectile_area_movement_type
        self.movement_subtype = projectile_area_movement_subtype
        self.r = angle

        local projectile_area_movement = projectiles_movement[projectile_area_movement_type][projectile_area_movement_subtype]
        self.v_i = projectile_area_movement.v_i or 0
        self.v_f = projectile_area_movement.v_f or 0
        self.a = projectile_area_movement.a or 0
        self.a_delay = projectile_area_movement.a_delay or 0
        self.time_limit = projectile_area_movement.time_limit or 0
        self.v = self.v_i
        self.over = false
        
        self.body:setGravityScale(0)
        self.body:setFixedRotation(true)
    end,

    movableAreaProjectileUpdate = function(self, dt)
        self.p.x, self.p.y = self.body:getPosition()
        local x, y = self.body:getLinearVelocity()
        if not self.over then self:move(dt) end
        self.body:setLinearVelocity(math.cos(self.r)*self.v, math.sin(self.r)*self.v) 
    end,

    move = function(self, dt)
        self.v = self.v + self.a*dt
        if self.v_f >= self.v_i then
            if self.v >= self.v_f then 
                self.v = self.v_f
                self.over = true 
            end
        else 
            if self.v <= self.v_f then 
                self.v = self.v_f
                self.over = true 
            end 
        end
    end
}
