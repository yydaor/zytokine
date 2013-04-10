MovingText = class('MovingText', Entity)
MovingText.UID = 0

function MovingText:initialize(chrono, parent_id, x, y, text)
    Entity.initialize(self, chrono, x, y)
    if not text then text = 0 end
    self.w = GAME_FONT:getWidth(tostring(text))
    self.h = GAME_FONT:getHeight()
    self.parent_id = parent_id
    self.text = text

    beholder.observe('ITEMGET MOVE TEXT' .. self.parent_id, function(x, y)
        self.p = Vector(x, y)
        main_tween(1, self.p, {y = y - 64}, 'outCirc')
        self.chrono:after(0.8, function() beholder.trigger('REMOVE', self) end)
    end)

    beholder.observe('DAMAGE MOVE TEXT' .. self.parent_id, function(x, y)
        self.p = Vector(x, y)
        main_tween(1, self.p, {y = y - 32}, 'outElastic')
        self.chrono:after(0.5, function() beholder.trigger('REMOVE', self) end)
    end)
end

function MovingText:draw()
    love.graphics.setFont(GAME_FONT)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(tostring(self.text), self.p.x - self.w/2, self.p.y - 2*self.h)
end


