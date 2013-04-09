function loadAttacks()
    dot = struct('interval', 'times', 'damage')
    slow = struct('percentage', 'duration')

    local attack = struct('name', 'activation', 'areas', 'projectiles', 'selfs')
    attacks = {}
    attacks['normal'] = attack('1 projectile', 'press', nil, {multiple = 3, fork = 'up', reflecting = 10}, nil)

    attack_list = {}
    table.insert(attack_list, attacks.normal)
end
