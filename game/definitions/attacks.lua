function loadAttacks()
    dot = struct('interval', 'times', 'damage')
    slow = struct('percentage', 'duration')

    local attack = struct('name', 'activation', 'areas', 'projectiles', 'selfs')
    attacks = {}
    attacks['normal'] = attack('1 projectile', 'press', nil, {instant = 0.2}, nil)

    attack_list = {}
    table.insert(attack_list, attacks.normal)
end
