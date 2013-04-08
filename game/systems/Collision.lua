Collision = class('Collision')

function Collision:initialize()
    
end

function Collision.onEnter(fixture_a, fixture_b, contact)
    local a, b = fixture_a:getUserData(), fixture_b:getUserData()
    local nx, ny = contact:getNormal()

    if fixture_a:isSensor() and fixture_b:isSensor() then
        if collIf('Player', 'Enemy', a, b) then
            a, b = collEnsure('Player', a, 'Enemy', b)
            a:collisionEnemy(b)

        elseif collIf('Player', 'ItemBox', a, b) then
            a, b = collEnsure('Player', a, 'ItemBox', b)
            a:collisionItemBox(b)

        elseif collIf('Projectile', 'Enemy', a, b) then
            a, b = collEnsure('Projectile', a, 'Enemy', b)
            a:collisionEnemy(b)

        elseif collIf('Area', 'Player', a, b) then
            a, b = collEnsure('Area', a, 'Player', b)
            a:collisionPlayer(b)

        elseif collIf('Area', 'Enemy', a, b) then
            a, b = collEnsure('Area', a, 'Enemy', b)
            a:collisionEnemy(b)
        end

    elseif not (fixture_a:isSensor() or fixture_b:isSensor()) then
        if collIf('Player', 'Solid', a, b) then
            a, b = collEnsure('Player', a, 'Solid', b)
            a:collisionSolid(b, nx, ny)

        elseif collIf('Projectile', 'Solid', a, b) then
            a, b = collEnsure('Projectile', a, 'Solid', b)
            a:collisionSolid(b, nx, ny)
        end
    end
end

function Collision.onExit(fixture_a, fixture_b, contact)
    local a, b = fixture_a:getUserData(), fixture_b:getUserData()
    local nx, ny = contact:getNormal()

    if fixture_a:isSensor() and fixture_b:isSensor() then

    elseif not (fixture_a:isSensor() or fixture_b:isSensor()) then
        beholder.trigger('COLLISION EXIT' .. a.id, nx, ny)
    end
end

function Collision:update(dt)
    
end
