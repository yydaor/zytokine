Entity = class('Entity')

function Entity:initialize(chrono, x, y)
    self.id = getUID()
    self.chrono = chrono
    self.p = Vector(x or 0, y or 0)
    self.dead = false
end
