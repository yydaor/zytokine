function loadProjectiles()
    PROJECTILE_V = 500

    local projectile_movement = struct('v_i', 'v_f', 'a', 'a_delay', 'time_limit')
    projectiles_movement = {}
    projectiles_movement['normal'] = {}
    projectiles_movement['normal']['default'] = projectile_movement(PROJECTILE_V, PROJECTILE_V)
    projectiles_movement['accelerating'] = {}
    projectiles_movement['accelerating']['default'] = projectile_movement(0, 2*PROJECTILE_V, 1000)
    projectiles_movement['decelerating'] = {}
    projectiles_movement['decelerating']['default'] = projectile_movement(2*PROJECTILE_V, 0, -1000)
    projectiles_movement['boomerang'] = {}
    projectiles_movement['boomerang']['default'] = projectile_movement(PROJECTILE_V, -PROJECTILE_V, -1000)

    dot = struct('tick', 'times', 'damage')
    slow = struct('value', 'duration')
end
