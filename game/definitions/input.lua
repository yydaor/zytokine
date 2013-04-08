function loadInput()
    local map_key = struct('type', 'action', 'keys')
    playerInputKeys = {
        map_key('down', 'MOVE RIGHT', {'right', 'd'}),
        map_key('down', 'MOVE LEFT', {'left', 'a'}),
        map_key('down', 'JUMP', {'up', 'w', ' '}),
        map_key('down', 'ATTACK', {'z', 'n', 'o', ',', 'j'}),
        map_key('down', 'USE', {'x', 'm', 'p', '.', 'k'}),
        map_key('press', 'JUMP PRESSED', {'up', 'w', ' '}),
        map_key('press', 'ATTACK PRESSED', {'z', 'n', 'o', ',', 'j'}),
        map_key('press', 'USE PRESSED', {'x', 'm', 'p', '.', 'k'}),
        map_key('release', 'ATTACK RELEASED', {'z', 'n', 'o', ',', 'j'}),
        map_key('release', 'JUMP RELEASED', {'up', 'w', ' '}),
        map_key('release', 'USE RELEASED', {'x', 'm', 'p', '.', 'k'})
    }
end
