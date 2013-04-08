Movable = {
    movableInit = function(self, a, max_v, gravity_scale)
        self.a = a 
        self.init_max_v = max_v
        self.max_v = max_v 
        self.gravity_scale = gravity_scale
        self.moving = {left = false, right = false}
        self.collision_pairs = 0
        self.last_n = Vector(0, 0)
        self.side_colliding = {left = false, right = false}
        self.direction = 'right'

        self.body:setGravityScale(gravity_scale)
        self.body:setFixedRotation(true)

        beholder.observe('MOVE LEFT' .. self.id, function() self.moving.left = true end)
        beholder.observe('MOVE RIGHT' .. self.id, function() self.moving.right = true end)

        beholder.observe('COLLISION ENTER' .. self.id, function(nx, ny) 
            self.collision_pairs = self.collision_pairs + 1
            if nx < 0 then self.side_colliding.left = true end
            if nx > 0 then self.side_colliding.right = true end
        end)

        beholder.observe('COLLISION EXIT' .. self.id, function(nx, ny) 
            self.collision_pairs = self.collision_pairs - 1
            if self.collision_pairs == 0 then
                self.side_colliding.left = false
                self.side_colliding.right = false 
            end
        end)
    end,

    movableUpdate = function(self, dt)
        self.p.x, self.p.y = self.body:getPosition()
        local x, y = self.body:getLinearVelocity()

        if self.moving.left then
            if not self.side_colliding.left then
                self.body:setLinearVelocity(-self.max_v, y)
                self.direction = 'left'
            end
        end

        if self.moving.right then
            if not self.side_colliding.right then
                self.body:setLinearVelocity(self.max_v, y)
                self.direction = 'right'
            end
        end

        if not self.moving.right and not self.moving.left then
            self.body:setLinearVelocity(0, y)
        end

        self.body:setGravityScale(self.gravity_scale)

        self.moving.left = false
        self.moving.right = false
    end
}
