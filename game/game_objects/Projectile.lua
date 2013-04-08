Projectile = class('Projectile', Entity)
Projectile:include(PhysicsRectangle)
Projectile:include(MovableAreaProjectile)
Projectile:include(LogicProjectile)

function Projectile:initialize(chrono, world, x, y, angle, projectile_movement_type, projectile_movement_subtype, 
                               projectile_modifier)
    Entity.initialize(self, chrono, x, y)    
    self:physicsRectangleInit(world, 'dynamic', PROJECTILEW, PROJECTILEH)
    self:movableAreaProjectileInit(angle, projectile_movement_type, projectile_movement_subtype)
    self:logicProjectileInit(projectile_modifier)
end

function Projectile:collisionSolid(solid, nx, ny)
    if self.reflecting then 
        self.reflecting = self.reflecting - 1
        if nx < 0 or nx > 0 and ny == 0 then self.r = math.pi - self.r 
        elseif ny < 0 or ny > 0 and nx == 0 then self.r = -self.r end
        if self.reflecting <= 0 then self.reflecting = nil end
    end

    if not self.reflecting then self.dead = true end
end

function Projectile:collisionEnemy(enemy)
    if not table.contains(self.enemies_hit, enemy) then
        self:addEnemy(enemy)

        if self.instant then
            beholder.trigger('HP DECREASE' .. enemy.id, self.instant)    
        end

        if self.dot then
            self.chrono:every(self.dot.tick, self.dot.times, function() 
                beholder.trigger('HP DECREASE' .. enemy.id, self.dot.damage)
            end)
        end

        if self.pierce then
            self.pierce = self.pierce - 1
            if self.pierce <= 0 then self.pierce = nil end
        end

        if self.slow then
            enemy:setSlow(self.slow.value, self.slow.duration)
        end

        if self.stun then
            enemy:setStun(self.stun)
        end

        if self.fork then
            local n = self.fork
            local angle = self.r
            local x, y = enemy.p.x + math.cos(angle)*enemy.w, enemy.p.y + math.sin(angle)*enemy.h
            beholder.trigger('CREATE PROJECTILE', x, y, angle-SPREAD_ANGLE,
                             'normal', 'default', table.keyRemove(self.projectile_modifier, 'fork'))
            beholder.trigger('CREATE PROJECTILE', x, y, angle+SPREAD_ANGLE,
                             'normal', 'default', table.keyRemove(self.projectile_modifier, 'fork'))
        end

        if not self.pierce then self.dead = true end
    end
end

function Projectile:update(dt)
    self:movableAreaProjectileUpdate(dt)
end

function Projectile:draw()
    self:physicsRectangleDraw()
end
