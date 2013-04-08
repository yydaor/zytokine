require 'Level'

Game = class('Game')

function Game:initialize()
    self.paused = false
    self.current_level = Level('super_crate_box')
end

function Game:update(dt)
    if not self.paused then self.current_level:update(dt) end
end

function Game:draw()
    self.current_level:draw()
end

function Game:keypressed(key)
    if key == 'p' then self.paused = not self.paused end
    if not self.paused then self.current_level:keypressed(key) end
end

function Game:keyreleased(key)
    if not self.paused then self.current_level:keyreleased(key) end
end
