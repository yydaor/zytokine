PhysicsLine = {
    physicsLineInit = function(world, body_type, x1, y1, x2, y2)
        self.body = love.physics.newBody(world, self.p.x, self.p.y, body_type)
        self.shape = love.physics.newEdgeShape(x1, y1, x2, y2)
        self.fixture = love.physics.newFixture(self.body, self.shape)
    end
}
