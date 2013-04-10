MovingText = class('MovingText', Entity)

function MovingText:initialize(chrono, parent_id, x, y, text)
    Entity.initialize(self, chrono, x, y)
    self.w = GAME_FONT:getWidth(text)
    self.h = GAME_FONT:getHeight()
    self.parent_id = parent_id
    self.text = text

    beholder.observe('MOVE TEXT' .. self.parent_id, function(x, y)
        self.p = Vector(x, y)
        main_tween(1, self.p, {y = y - 64}, 'outCirc')
        self.chrono:after(0.8, function() beholder.trigger('REMOVE', self) end)
    end)
end

function MovingText:draw()
    love.graphics.setFont(GAME_FONT)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(self.text, self.p.x - self.w/2, self.p.y - 2*self.h)
end


