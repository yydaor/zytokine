LogicArea = {
    logicAreaInit = function(self, area_modifier)
        self.area_modifier = area_modifier
        self.instant = area_modifier.instant
        self.dot = area_modifier.dot
        self.slow = area_modifier.slow
        self.stun = area_modifier.stun
        self.exploding = area_modifier.exploding
    end
}
