Spawner = class('Spawner', Entity)

function Spawner:initialize(chrono, x, y)
    Entity.initialize(self, chrono, x, y)

    self.chrono:every(5, function()
        beholder.trigger('CREATE ENEMY', self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}))
    end)
end
