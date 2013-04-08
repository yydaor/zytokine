Input = {
    inputInit = function(self, in_action_keys)
        self.key_action = {}
        self.key_action.down = {}
        self.key_action.press = {}
        self.key_action.release = {}
        self:updateActionKeys(in_action_keys)
    end,

    updateActionKeys = function(self, in_action_keys)
        for _, map_key in ipairs(in_action_keys) do
            for _, key in ipairs(map_key.keys) do
                self.key_action[map_key.type][key] = map_key.action
            end
        end
    end,

    inputUpdate = function(self, dt)
        for key, action in pairs(self.key_action.down) do
            if love.keyboard.isDown(key) then
                beholder.trigger(action .. self.id, 'down')
            end
        end
    end,

    inputKeypressed = function(self, in_key)
        for key, action in pairs(self.key_action.press) do
            if key == in_key then beholder.trigger(action .. self.id, 'press') end
        end
    end,

    inputKeyreleased = function(self, in_key)
        for key, action in pairs(self.key_action.release) do
            if key == in_key then beholder.trigger(action .. self.id, 'release') end
        end
    end
}
