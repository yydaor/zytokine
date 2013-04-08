Hittable = {
    hittableInit = function(self, interval, times)
        self.blinking = false
        self.invulnerable = false
        self.hit_interval = interval
        self.times = times

        beholder.observe('HIT' .. self.id, function() 
            self.chrono:every(self.hit_interval, self.times, function() 
                self.blinking = not self.blinking 
            end):after(0, function() self.invulnerable = false end) 
            self.invulnerable = true
        end)
    end
}
