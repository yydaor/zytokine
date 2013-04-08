function loadAttacks()
    local attack = struct('name', 'activation', 'areas', 'projectiles', 'selfs')
    attacks = {}
    attacks['normal'] = attack('1 projectile', 'press', nil, {instant = 10}, nil)

    attack_list = {}
    table.insert(attack_list, attacks.normal)
end
