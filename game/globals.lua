math.randomseed(os.time())
math.random(); math.random(); math.random()

function loadRequire()
    require 'libraries/middleclass/middleclass'
    require 'libraries/chrono/chrono'
    require 'libraries/Vector'
    require 'utils'
    beholder = require 'libraries/beholder/beholder'
    struct = require 'libraries/struct/struct'
    Camera = require 'libraries/hump/camera'
    main_tween = require 'libraries/tween/tween'

    require 'mixins/Input'
    require 'mixins/PhysicsLine'
    require 'mixins/PhysicsRectangle'
    require 'mixins/Movable'
    require 'mixins/Jumper'
    require 'mixins/Logic'
    require 'mixins/Attacker'
    require 'mixins/Behavior'
    require 'mixins/Hittable'
    require 'mixins/MovableAreaProjectile'
    require 'mixins/LogicProjectile'
    require 'mixins/LogicArea'
    require 'mixins/LogicActivation'

    require 'game_objects/Entity'
    require 'game_objects/Solid'
    require 'game_objects/Player'
    require 'game_objects/Projectile'
    require 'game_objects/Enemy'
    require 'game_objects/ItemBox'
    require 'game_objects/MovingText'
    require 'game_objects/Area'

    require 'definitions/input'
    require 'definitions/levels'
    require 'definitions/attacks'
    require 'definitions/projectiles'
    require 'definitions/collisions'
    require 'definitions/areas'
end

function loadScale()
    -- Screen resolution scale
    -- 1:    800x512
    -- 1.25: 1000x640
    -- 1.5:  1200x768
    -- 1.75: 1400x896
    -- 2:    1600x1024
    scale = 1
    scales = {1, 1.25, 1.5, 1.75, 2}
end

function loadGlobals()
    -- Game
    SX = scale/2
    SY = scale/2
    GAME_WIDTH = 800*scale
    GAME_HEIGHT = 512*scale

    -- Images
    square = love.graphics.newImage('resources/square.png')

    -- PSOs
    main_pso = 'resources/Zytokine.pso'

    -- ID
    uid = 0
    getUID = function() uid = uid + 1; return uid end

    -- Physics
    PHYSICS_METER = 32
    PHYSICS_GRAVITY = 10

    -- Visual, UI 
    UI_TEXT_FONT = love.graphics.newFont('resources/VeraMono.ttf', 16)
    GAME_FONT = love.graphics.newFont('resources/VeraMono.ttf', 16)

    -- Entity
    TILEW = 32
    TILEH = 32

    -- Player
    PLAYERW = 24
    PLAYERH = 24
    PLAYER_GRAVITY_SCALE = 3.4
    PLAYERA = 5000
    PLAYER_MAX_VELOCITY = 225
    PLAYER_JUMP_IMPULSE = -512

    -- Enemy
    ENEMY_WALL_LEFT = 32
    ENEMY_WALL_RIGHT = 768
    SMALL_ENEMYW = 24
    SMALL_ENEMYH = 24
    BIG_ENEMYW = 48
    BIG_ENEMYH = 48
    SMALL_ENEMYA = 5000 
    BIG_ENEMYA = 5000
    SMALL_ENEMY_MAX_VELOCITY = 200
    BIG_ENEMY_MAX_VELOCITY = 175
    SMALL_ENEMY_GRAVITY_SCALE = 3.4 
    BIG_ENEMY_GRAVITY_SCALE = 6.8

    -- Projectile
    PROJECTILEW = 8
    PROJECTILEH = 8
    SPREAD_ANGLE = math.pi/24

    -- ItemBox
    ITEMBOXW = 16
    ITEMBOXH = 16
    ITEMBOXA = 5000
    ITEMBOX_MAX_VELOCITY = 200
    ITEMBOX_GRAVITY_SCALE = 3.4
    ITEMBOX_POSSIBLE_Y = {96, 192, 288, 400}

    -- Mine
    MINEW = 16
    MINEH = 8

    loadLevels()
    loadInput()
    loadProjectiles()
    loadCollisions()
    loadAreas()
    loadAttacks()
end
