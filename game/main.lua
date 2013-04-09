function initialize()
    require 'globals'

    loadRequire()
    loadScale()
    loadGlobals()

    require 'Game'

    debugging = true

    state = {game = Game()}
    current_state = state.game
    main_chrono = Chrono()

    beholder.observe('TRANSITION', function(to) current_state = state[to] end)
end

function love.load()
    initialize()
end

function love.update(dt)
    main_tween.update(dt)
    main_chrono:update(dt)
    current_state:update(dt)
end

function love.draw()
    current_state:draw()
    love.graphics.setFont(UI_TEXT_FONT)
    love.graphics.print(tostring(math.round(collectgarbage("count"), 0) .. 'Kb'), 10, 10)
    love.graphics.print(love.timer.getFPS(), 10, 40)
end

function love.keypressed(key)
    if key == 'q' then love.event.push('quit') end
    if key == 'f1' then debugging = not debugging end
    current_state:keypressed(key)
end

function love.keyreleased(key)
    current_state:keyreleased(key) 
end

function love.run()
    math.randomseed(os.time())
    math.random(); math.random(); math.random();

    if love.load then love.load(arg) end

    local t = 0
    local dt = 0
    local fixed_dt = 1/60 
    local accumulator = 0

    -- Main loop time
    while true do
        -- Process events
        if love.event then
            love.event.pump()
            for e, a, b, c, d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a, b, c, d)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        accumulator = accumulator + dt

        while accumulator >= fixed_dt do
            if love.update then love.update(fixed_dt) end
            accumulator = accumulator - fixed_dt
            t = t + fixed_dt
        end

        if love.graphics then
            love.graphics.clear()
            if love.draw then love.draw() end
        end

        if love.graphics then love.graphics.present() end
    end
end
