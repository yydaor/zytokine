Player = class('Player', Entity)
Player:include(PhysicsRectangle)
Player:include(Input)
Player:include(Movable)
Player:include(Jumper)
Player:include(Hittable)
Player:include(Logic)
Player:include(Attacker)

function Player:initialize(chrono, world, x, y)
    Entity.initialize(self, chrono, x, y)
    self:physicsRectangleInit(world, 'dynamic', PLAYERW, PLAYERH)
    self:inputInit(playerInputKeys)
    self:movableInit(PLAYERA, PLAYER_MAX_VELOCITY, PLAYER_GRAVITY_SCALE)
    self:jumperInit(PLAYER_JUMP_IMPULSE, 1)
    self:hittableInit(0.05, 32)
    self:logicInit(1)
    self:attackerInit()
end

function Player:collisionSolid(solid, nx, ny)
    beholder.trigger('COLLISION ENTER' .. self.id, nx, ny)
end

function Player:collisionEnemy(enemy)
    if not self.invulnerable then
        beholder.trigger('HIT' .. self.id)
        beholder.trigger('HP DECREASE' .. self.id, 1)
    end
end

function Player:collisionItemBox(itembox)
    local n = math.random(1, #attack_list)
    local next_attack = attack_list[n]
    self.current_attack = next_attack
    beholder.trigger('CREATE ITEMBOX', next_attack.name) 
    beholder.trigger('ITEMGET MOVE TEXT' .. itembox.id, itembox.p.x, itembox.p.y)
    beholder.trigger('ITEMGET PARTICLE SPAWN', 'ItemGet', itembox.p.x, itembox.p.y)
end

function Player:update(dt)
    self:inputUpdate(dt)
    self:jumperUpdate(dt)
    self:movableUpdate(dt)
    self:logicUpdate(dt)
end

function Player:draw()
    self:physicsRectangleDraw() 
end

function Player:keypressed(key)
    self:inputKeypressed(key)
end

function Player:keyreleased(key)
    self:inputKeyreleased(key)
end
