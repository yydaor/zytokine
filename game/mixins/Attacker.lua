Attacker = {
    attackerInit = function(self)
        self.current_attack = attacks.normal
        beholder.observe('ATTACK PRESSED' .. self.id, function() self:attack('press') end)
    end,

    attack = function(self, activation_type)
        if self.current_attack.activation == activation_type then
            if self.current_attack.projectiles then
                if self.direction == 'right' then angle = 0 else angle = math.pi end
                local x = self.p.x + math.cos(angle)*self.w

                if self.current_attack.projectiles.multiple then
                    local n = self.current_attack.projectiles.multiple
                    for i = 1, math.floor(n/2) do
                        beholder.trigger('CREATE PROJECTILE', x, self.p.y, angle-i*SPREAD_ANGLE, 
                                        'normal', 'default', self.current_attack.projectiles)
                        beholder.trigger('CREATE PROJECTILE', x, self.p.y, angle+i*SPREAD_ANGLE, 
                                        'normal', 'default', self.current_attack.projectiles)
                    end

                    if n % 2 == 1 then
                        beholder.trigger('CREATE PROJECTILE', x, self.p.y, angle, 
                                         'normal', 'default', self.current_attack.projectiles)
                    end
                end

                if self.current_attack.projectiles.back then
                    local x = self.p.x + math.cos(math.pi-angle)*self.w
                    beholder.trigger('CREATE PROJECTILE', x, self.p.y, math.pi-angle, 
                                     'normal', 'default', self.current_attack.projectiles)
                end

                if not self.current_attack.projectiles.multiple then
                    beholder.trigger('CREATE PROJECTILE', x, self.p.y, angle, 
                                     'normal', 'default', self.current_attack.projectiles)
                end
            end
        end
    end
}
