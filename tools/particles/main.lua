--[[
--
    the code mystified 
    a developer reads on
    the brain is ravaged 
--
]]--

-- This was created using loveframes by Kenny Shields: 
-- http://nikolairesokav.com/projects/loveframes/

local struct = setmetatable({}, {
    __call =
        function(struct_table, ...)
            local fields = {...}

            for _, field in ipairs(fields) do
                if type(field) ~= "string" then error("Struct field names must be strings.") end
            end

            local struct_table = setmetatable({}, {
                __call =
                    function(struct_table, ...)
                        local params = {...}
                        local instance_table = setmetatable({}, {
                            __index =
                                function(struct_table, key)
                                    for _, field in ipairs(fields) do
                                        if field == key then return rawget(struct_table, key) end
                                    end
                                    error("Unknown field '" .. key .. "'")
                                end,

                            __newindex =
                                function(struct_table, key, value)
                                    for _, field in ipairs(fields) do
                                        if field == key then
                                            rawset(struct_table, key, value)
                                            return
                                        end
                                    end
                                    error("Unknown field '" .. key .. "'")
                                end,

                            __tostring =
                                function(struct_table)
                                    local result = "("
                                    for _, field in ipairs(fields) do
                                        result =
                                            result .. field .. "=" ..
                                            tostring(struct_table[field]) .. ", "
                                    end
                                    result = string.sub(result, 1, -3) .. ")"
                                    return result
                                end
                        })

                        for i = 1, table.maxn(params) do
                            if fields[i] then instance_table[fields[i]] = params[i]
                            else error("Unknown argument #" .. tostring(i)) end
                        end
                        return instance_table
                    end
            })
            return struct_table
        end
})

function tableToString(table)
    local str = "{"
    for k, v in pairs(table) do
        if type(k) ~= "number" then str = str .. k .. " = " end
        if type(v) == "number" or type(v) == "boolean" then str = str .. tostring(v) .. ", "
        elseif type(v) == "string" then str = str .. "'" .. v .. "'" .. ", "
        elseif type(v) == "table" then str = str .. tableToString(v) .. ", " end
    end
    if #table > 0 then str = string.sub(str, 1, -3) end
    str = str .. "}"
    return str
end

function stringToTable(str)
    if str then return loadstring("return " .. str)() end
end

function love.load()
    width = 1280
    height = 830
    love.graphics.setMode(width, height)
    require("loveframes")
    love.filesystem.setIdentity("Particle Editor")
    if not love.filesystem.exists("run") then love.filesystem.write("run", "sup") end
    
    font10 = love.graphics.newFont(10)
    font12 = love.graphics.newFont(12)
    font14 = love.graphics.newFont(14)
    font16 = love.graphics.newFont(16)

    Attribute = struct('text', 'n', 'value', 'nb_min', 'nb_max', 'nb_incdec')

    sprites = {}
    local files = love.filesystem.enumerate("")
    for k, file in ipairs(files) do
        if isPngOrPso(file) == "png" then table.insert(sprites, file) end
    end
    sprite = sprites[1]

    lists = {}
    local files = love.filesystem.enumerate("")
    for k, file in ipairs(files) do
        if isPngOrPso(file) == "pso" then table.insert(lists, file) end
    end
    current_template_list = lists[1]

    different_name = false
    different_name2 = false
    invalid_list_name = false

    colors = {}
    for i = 1, 8 do 
        colors[i] = {}
        colors[i].r = 0
        colors[i].g = 0
        colors[i].b = 0
        colors[i].a = 0
        colors[i].set = false
    end
    colors_tab_n = 1

    sizes = {}
    for i = 1, 8 do
        sizes[i] = {}
        sizes[i].value = 0
        sizes[i].set = false
    end
    sizes_tab_n = 1

    main_name = ""
    buffer_size = Attribute("Buffer Size", 1, 0, 0, 1000000, 100)
    direction = Attribute("Direction", 1, 0, 0, 360, 1)
    emission_rate = Attribute("Emission Rate", 1, 0, 0, 10000, 10)
    gravity = Attribute("Gravity", 2, {min = 0, max = 0}, -10000, 10000, 10)
    lifetime = Attribute("Lifetime", 1, 0, -1, 10000, 0.1)
    offset = Attribute("Offset", 2, {min = 0, max = 0}, -10000, 10000, 10)
    particle_life = Attribute("Particle Life", 2, {min = 0, max = 0}, 0, 10000, 0.1) 
    radial_acc = Attribute("Radial Acc", 2, {min = 0, max = 0}, -10000, 10000, 10)
    rotation = Attribute("Rotation", 2, {min = 0, max = 0}, -360, 360, 1) 
    size_variation = Attribute("Size Variation", 1, 0, 0, 1, 0.01)
    speed = Attribute("Speed", 2, {min = 0, max = 0}, -10000, 10000, 10)
    spin = Attribute("Spin", 2, {min = 0, max = 0}, -10000, 10000, 1)
    spin_variation = Attribute("Spin Variation", 1, 0, 0, 1, 0.01)
    spread = Attribute("Spread", 1, 0, 0, 360, 1)
    tangent_acc = Attribute("Tangent Acc", 2, {min = 0, max = 0}, -10000, 10000, 10)

    attributes = {buffer_size, colors, direction, emission_rate, gravity, lifetime, 
                  offset, particle_life, radial_acc, rotation, size_variation, sizes,
                  speed, spin, spin_variation, spread, tangent_acc}

    attributes_frame = createFrame("Particle Parameters", 5, 5, 240, height-10, false, false)
    list = createList(attributes_frame, 5, 30, 230, height-45, "vertical", 5, 5)
    list:AddItem(createMenuItemTextInput(list, true, "Name", 220, 30))
    add(1)
    list:AddItem(oneTabFourNumberboxes(2, "Colors", 0, 255, 1))
    for i = 3, 11 do add(i) end
    list:AddItem(oneTabOneNumberbox(12, "Sizes", 0, 1000, 0.5))
    for i = 13, 17 do add(i) end
    list:AddItem(oneMultichoice("Sprite", sprites, "image"))
    start_add_panel = createPanel(list, 0, 0, 214, 30)
    start_button = createButton(start_add_panel, "Restart", 0, 0, 59, 30, true, true)
    start_button.OnClick = function() ps:stop(); ps:start(); psSet() end
    add_button = createButton(start_add_panel, "Add to Templates List", 59, 0, 161, 30, true, true)
    add_button.OnClick = function() addToTemplatesList() end
    list:AddItem(start_add_panel)

    templates_frame = createFrame("Templates List", width-224-5, 5, 224, height/2+35+35, false, false)
    templates_frame.OnClose = function(object) templates_list_button:SetClickable(true) end
    templates_flist = createList(templates_frame, 5, 30, 214, height/2+35, "vertical", 5, 5)
    templates_flist:AddItem(createMenuItemTextInput(list, false, "Name", 204, 30))
    templates_flist:GetChildren()[1]:GetChildren()[2]:GetChildren()[1]:SetText("TL Name")
    templates_panel = createList(templates_flist, 0, 0, 204, height/2-115, "vertical", 0, 0)
    templates_flist:AddItem(oneMultichoice("List", lists, "list"))
    templates_flist:GetChildren()[3]:GetChildren()[2]:GetChildren()[1]:SetChoice(lists[1] or "None")
    set_remove_panel = createPanel(templates_flist, 0, 0, 204, 30)
    set_button = createButton(set_remove_panel, "Set", 0, 0, 102, 30, true, true)
    set_button.OnClick = function() 
        if selected_i ~= 0 then
            templateToMain(template_list[selected_i].name, template_list[selected_i].template) 
            templateToMain(template_list[selected_i].name, template_list[selected_i].template) 
            psSet()
            psSet()
        end
    end
    remove_button = createButton(set_remove_panel, "Remove", 102, 0, 102, 30, true, true)
    remove_button.OnClick = function() 
        if templates_flist:GetChildren()[2] then
            if templates_flist:GetChildren()[2]:GetChildren()[selected_i] then
                removeFromTemplatesList(selected_i)
            end
        end
        selected_i = 0
    end
    save_load_panel = createPanel(templates_flist, 0, 0, 204, 30)
    save_button = createButton(save_load_panel, "Save List", 0, 0, 102, 30, true, true)
    save_button.OnClick = function() saveTemplateList() end
    load_button = createButton(save_load_panel, "Load List", 102, 0, 102, 30, true, true)
    load_button.OnClick = function() 
        if current_template_list then
            local collisions = loadToTemplatesList(loadTemplateList(current_template_list))
            if collisions then
                different_name2 = true
                load_str = "'" .. current_template_list .. "'" .. " has name collisions with Templates List: "
                for i = 1, #collisions do
                    load_str = load_str .. "'" .. collisions[i] .. "'" .. ", "
                end
                load_str = string.sub(load_str, 1, -3)
                load_str = load_str .. "!"
            end
        end
    end

    Template = struct('buffer_size', 'colors', 'direction', 'emission_rate', 'gravity', 
                      'lifetime', 'offset', 'particle_life', 'radial_acc', 'rotation', 'size_variation', 
                      'sizes', 'speed', 'spin', 'spin_variation', 'spread', 'tangent_acc')

    default_template = Template(250, {{255, 255, 255, 255}, {0, 0, 0, 0}}, 360, 200, {0, 0}, -1, {0, 0}, {1, 3}, 
                               {0, 0}, {0, 0}, 0, {1}, {0, 200}, {0, 0}, 0, 360, {0, 0})

    template_list = {}
    template_list_name = "TL Name"
    selected_i = 0

    sprite = love.graphics.newImage(sprite)
    list:GetChildren()[19]:GetChildren()[2]:GetChildren()[1]:SetChoice(sprites[1])
    ps = love.graphics.newParticleSystem(sprite, buffer_size.value)    
    ps_x = width/2
    ps_y = height/2
    templateToMain("PS Name", default_template)
    psSet()
    ps:start()
end

function isPngOrPso(file_name)
    if string.sub(file_name, -3) == "png" then return "png"
    elseif string.sub(file_name, -3) == "pso" then return "pso"
    else return "none" end
end

function psSet()
    ps:setBufferSize(buffer_size.value)
    ps:setColors(unpack(flattenColors()))
    ps:setDirection(degToRad(direction.value))
    ps:setEmissionRate(emission_rate.value)
    ps:setGravity(gravity.value.min, gravity.value.max)
    ps:setLifetime(lifetime.value)
    ps:setOffset(offset.value.min, offset.value.max)
    ps:setParticleLife(particle_life.value.min, particle_life.value.max)
    ps:setRadialAcceleration(radial_acc.value.min, radial_acc.value.max)
    ps:setRotation(degToRad(rotation.value.min), degToRad(rotation.value.max))
    ps:setSizeVariation(size_variation.value)
    ps:setSizes(unpack(flattenSizes()))
    ps:setSpeed(speed.value.min, speed.value.max)
    ps:setSpin(degToRad(spin.value.min), degToRad(spin.value.max))
    ps:setSpinVariation(spin_variation.value)
    ps:setSpread(degToRad(spread.value))
    ps:setTangentialAcceleration(tangent_acc.value.min, tangent_acc.value.max)
    ps:setSprite(sprite)
end

function flattenColors()
    local c = {}
    for i = 1, 8 do
        if colors[i].set then
            table.insert(c, colors[i].r)
            table.insert(c, colors[i].g)
            table.insert(c, colors[i].b)
            table.insert(c, colors[i].a)
        end
    end
    return c 
end

function flattenSizes()
    local s = {}
    for i = 1, 8 do
        if sizes[i].set then
            table.insert(s, sizes[i].value)
        end
    end
    return s 
end

function degToRad(d)
    return d*math.pi/180
end

function loadToTemplatesList(templates)
    local collisions = {}
    for i = 1, #template_list do
        for j = 1, #templates do
            if templates[j].name == template_list[i].name then table.insert(collisions, templates[j].name) end
        end
    end
    if #collisions > 0 then return collisions end

    for i = 1, #templates do
        table.insert(template_list, {name = templates[i].name, template = templates[i].template})
        local n = #template_list
        local button = createButton(templates_panel, templates[i].name, 0, (#template_list-1)*30, 204, 30, true, true)
        button.OnClick = function(object) 
            selected_i = n
            object:SetEnabled(false) 
            unselectAll(selected_i)
        end
    end
end

function unselectAll(in_i)
    for i, t in ipairs(template_list) do
        if i ~= in_i then 
            if templates_panel:GetChildren()[i] then
                templates_panel:GetChildren()[i]:SetEnabled(true)
            end
        end
    end
end

function addToTemplatesList()
    different_name = false
    local name = main_name
    local template = mainToTemplate()
    for _, t in ipairs(template_list) do
        if t.name == name then different_name = true; return end
    end
    table.insert(template_list, {name = name, template = template})
    local n = #template_list
    local button = createButton(templates_panel, name, 0, (#template_list-1)*30, 204, 30, true, true)
    button.OnClick = function(object) 
        selected_i = n
        object:SetEnabled(false) 
        unselectAll(selected_i)
    end
end

function removeFromTemplatesList(j)
    table.remove(template_list, j)
    templates_flist:GetChildren()[2]:GetChildren()[j]:Remove()
    for i = 1, #template_list do
        templates_flist:GetChildren()[2]:GetChildren()[i]:SetPos(0, (i-1)*30)
        templates_flist:GetChildren()[2]:GetChildren()[i].OnClick = function(object)
            selected_i = i
            object:SetEnabled(false)
            unselectAll(selected_i)
        end
    end
end

function saveTemplateList()
    local str = template_list_name 
    -- str = string.gsub(str, "[%p%c%.%?\"\<\>\|%*\\\/]", "")
    str = str .. ".pso"
    if not pcall(love.filesystem.write, str, tableToString(template_list)) then invalid_list_name = true end

    local added_files = {}
    local files = love.filesystem.enumerate("")
    for k, file in ipairs(files) do
        if isPngOrPso(file) == "pso" then 
            if not table.contains(lists, file) then table.insert(added_files, file) end
        end
    end

    for i = 1, #added_files do
        table.insert(lists, added_files[i])
        templates_flist:GetChildren()[3]:GetChildren()[2]:GetChildren()[1]:AddChoice(added_files[i])
    end
end

function table.contains(t, v)
    for key, value in pairs(t) do
        if value == v then return true end
    end
    return false
end

function loadTemplateList(name)
    template_list_name = string.sub(name, 1, -5)
    templates_flist:GetChildren()[1]:GetChildren()[2]:GetChildren()[1]:SetText(string.sub(name, 1, -5))
    return stringToTable(love.filesystem.read(name))
end

function mainToTemplate()
    local template = Template()
    template.buffer_size = list:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.colors = {}
    for i = 1, 8 do
        if colors[i].set then
            template.colors[i] = {}
            template.colors[i][1] = list:GetChildren()[3]:GetChildren()[2]:GetChildren()[1]:GetChildren()[i]:GetChildren()[1]:GetValue()
            template.colors[i][2] = list:GetChildren()[3]:GetChildren()[2]:GetChildren()[1]:GetChildren()[i]:GetChildren()[2]:GetValue()
            template.colors[i][3] = list:GetChildren()[3]:GetChildren()[2]:GetChildren()[1]:GetChildren()[i]:GetChildren()[3]:GetValue()
            template.colors[i][4] = list:GetChildren()[3]:GetChildren()[2]:GetChildren()[1]:GetChildren()[i]:GetChildren()[4]:GetValue()
        end
    end
    template.direction = list:GetChildren()[4]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.emission_rate = list:GetChildren()[5]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.gravity = {}
    template.gravity[1] = list:GetChildren()[6]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:GetValue()
    template.gravity[2] = list:GetChildren()[6]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.lifetime = list:GetChildren()[7]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.offset = {}
    template.offset[1] = list:GetChildren()[8]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:GetValue()
    template.offset[2] = list:GetChildren()[8]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.particle_life = {}
    template.particle_life[1] = list:GetChildren()[9]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:GetValue()
    template.particle_life[2] = list:GetChildren()[9]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.radial_acc = {}
    template.radial_acc[1] = list:GetChildren()[10]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:GetValue()
    template.radial_acc[2] = list:GetChildren()[10]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.rotation = {}
    template.rotation[1] = list:GetChildren()[11]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:GetValue()
    template.rotation[2] = list:GetChildren()[11]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.size_variation = list:GetChildren()[12]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.sizes = {}
    for i = 1, 8 do
        if sizes[i].value ~= 0 then
            template.sizes[i] = list:GetChildren()[13]:GetChildren()[2]:GetChildren()[1]:GetChildren()[i]:GetValue()
        end
    end
    template.speed = {}
    template.speed[1] = list:GetChildren()[14]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:GetValue()
    template.speed[2] = list:GetChildren()[14]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.spin = {}
    template.spin[1] = list:GetChildren()[15]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:GetValue()
    template.spin[2] = list:GetChildren()[15]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.spin_variation = list:GetChildren()[16]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.spread = list:GetChildren()[17]:GetChildren()[2]:GetChildren()[1]:GetValue()
    template.tangent_acc = {}
    template.tangent_acc[1] = list:GetChildren()[18]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:GetValue()
    template.tangent_acc[2] = list:GetChildren()[18]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:GetValue()
    return template
end

function templateToMain(name, template)
    loading = true
    main_name = name
    list:GetChildren()[1]:GetChildren()[2]:GetChildren()[1]:SetText(main_name)
    list:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:SetValue(template.buffer_size)
    buffer_size.value = template.buffer_size
    for i = 1, #template.colors do
        list:GetChildren()[3]:GetChildren()[2]:GetChildren()[1]:GetChildren()[i]:GetChildren()[1]:SetValue(template.colors[i][1])
        list:GetChildren()[3]:GetChildren()[2]:GetChildren()[1]:GetChildren()[i]:GetChildren()[2]:SetValue(template.colors[i][2])
        list:GetChildren()[3]:GetChildren()[2]:GetChildren()[1]:GetChildren()[i]:GetChildren()[3]:SetValue(template.colors[i][3])
        list:GetChildren()[3]:GetChildren()[2]:GetChildren()[1]:GetChildren()[i]:GetChildren()[4]:SetValue(template.colors[i][4])
        colors[i].r = template.colors[i][1]
        colors[i].g = template.colors[i][2]
        colors[i].b = template.colors[i][3]
        colors[i].a = template.colors[i][4]
        colors[i].set = true
    end
    for i = #template.colors+1, 8 do colors[i].set = false end
    list:GetChildren()[4]:GetChildren()[2]:GetChildren()[1]:SetValue(template.direction)
    direction.value = template.direction
    list:GetChildren()[5]:GetChildren()[2]:GetChildren()[1]:SetValue(template.emission_rate)
    emission_rate.value = template.emission_rate
    list:GetChildren()[6]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:SetValue(template.gravity[1])
    list:GetChildren()[6]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:SetValue(template.gravity[2])
    gravity.value.min = template.gravity[1]
    gravity.value.max = template.gravity[2]
    list:GetChildren()[7]:GetChildren()[2]:GetChildren()[1]:SetValue(template.lifetime)
    lifetime.value = template.lifetime
    list:GetChildren()[8]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:SetValue(template.offset[1])
    list:GetChildren()[8]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:SetValue(template.offset[2])
    offset.value.min = template.offset[1]
    offset.value.max = template.offset[2]
    list:GetChildren()[9]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:SetValue(template.particle_life[1])
    list:GetChildren()[9]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:SetValue(template.particle_life[2])
    particle_life.value.min = template.particle_life[1]
    particle_life.value.max = template.particle_life[2]
    list:GetChildren()[10]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:SetValue(template.radial_acc[1])
    list:GetChildren()[10]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:SetValue(template.radial_acc[2])
    radial_acc.value.min = template.radial_acc[1]
    radial_acc.value.max = template.radial_acc[2]
    list:GetChildren()[11]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:SetValue(template.rotation[1])
    list:GetChildren()[11]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:SetValue(template.rotation[2])
    rotation.value.min = template.rotation[1]
    rotation.value.max = template.rotation[2]
    list:GetChildren()[12]:GetChildren()[2]:GetChildren()[1]:SetValue(template.size_variation)
    size_variation.value = template.size_variation
    for i = 1, #template.sizes do
        list:GetChildren()[13]:GetChildren()[2]:GetChildren()[1]:GetChildren()[i]:SetValue(template.sizes[i])
        sizes[i].value = template.sizes[i]
        sizes[i].set = true
    end
    for i = #template.sizes+1, 8 do sizes[i].set = false end
    list:GetChildren()[14]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:SetValue(template.speed[1])
    list:GetChildren()[14]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:SetValue(template.speed[2])
    speed.value.min = template.speed[1]
    speed.value.max = template.speed[2]
    list:GetChildren()[15]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:SetValue(template.spin[1])
    list:GetChildren()[15]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:SetValue(template.spin[2])
    spin.value.min = template.spin[1]
    spin.value.max = template.spin[2]
    list:GetChildren()[16]:GetChildren()[2]:GetChildren()[1]:SetValue(template.spin_variation)
    spin_variation.value = template.spin_variation
    list:GetChildren()[17]:GetChildren()[2]:GetChildren()[1]:SetValue(template.spread)
    spread.value = template.spread
    list:GetChildren()[18]:GetChildren()[2]:GetChildren()[1]:GetChildren()[1]:SetValue(template.tangent_acc[1])
    list:GetChildren()[18]:GetChildren()[2]:GetChildren()[2]:GetChildren()[1]:SetValue(template.tangent_acc[2])
    tangent_acc.value.min = template.tangent_acc[1]
    tangent_acc.value.min = template.tangent_acc[2]
    loading = false
end

function add(i)
    if attributes[i].n == 1 then 
        list:AddItem(oneNumberbox(i, attributes[i].text, attributes[i].nb_min, attributes[i].nb_max, attributes[i].nb_incdec))
    else list:AddItem(twoNumberboxes(i, attributes[i].text, attributes[i].nb_min, attributes[i].nb_max, attributes[i].nb_incdec, 
                                     attributes[i].nb_min, attributes[i].nb_max, attributes[i].nb_incdec))
    end
end

function oneNumberbox(i, text, min, max, incdec)
    return createMenuItemOneNumberbox(list, i, text, 220, 30, min, max, incdec)
end

function twoNumberboxes(i, text, min1, max1, incdec1, min2, max2, incdec2)
    return createMenuItemTwoNumberboxes(list, i, text, 220, 30, min1, max1, incdec1, min2, max2, incdec2) 
end

function oneMultichoice(text, choices, type)
    if type == "list" then return createMenuItemMultichoice(list, text, 204, 30, choices, type) end
    if type == "image" then return createMenuItemMultichoice(list, text, 220, 30, choices, type) end
end

function oneList(text, min, max, incdec)
    return createMenuItemList(list, text, 220, 56, 8, min, max, incdec)
end

function oneTabOneNumberbox(i, text, min, max, incdec)
    return createMenuItemTabNumberbox(list, i, text, 220, 56, 8, min, max, incdec)
end

function oneTabFourNumberboxes(i, text, min, max, incdec)
    return createMenuItemTabNumberboxes(list, i, text, 220, 84, 8, min, max, incdec)
end

function createFrame(name, x, y, w, h, show_close_button, draggable)
    local frame = loveframes.Create("frame")
    frame:SetPos(x, y)
    frame:SetSize(w, h)
    frame:SetName(name)
    frame:ShowCloseButton(show_close_button)
    frame:SetDraggable(draggable)
    return frame 
end

function createPanel(parent, x, y, w, h)
    local panel = loveframes.Create("panel", parent)
    panel:SetPos(x, y)
    panel:SetSize(w, h)
    return panel
end

function createTextInput(parent, torp, x, y, w, h)
    local textinput = loveframes.Create("textinput", parent)
    textinput.OnTextChanged = function(object, text) 
        if torp then main_name = object:GetText() 
        else template_list_name = object:GetText() end
    end
    textinput:SetPos(x, y)
    textinput:SetSize(w, h)
    textinput:SetMultiline(false)
    textinput:SetEditable(true)
    textinput:SetLimit(16)
    return textinput
end

function createList(parent, x, y, w, h, display_type, padding, spacing)
    local list = loveframes.Create("list", parent)
    list:SetPos(x, y)
    list:SetSize(w, h)
    list:SetDisplayType(display_type)
    list:SetPadding(padding)
    list:SetSpacing(spacing)
    return list
end

function createButton(parent, in_text, x, y, w, h, clickable, enabled)
    local button = loveframes.Create("button", parent)
    button:SetPos(x, y)
    button:SetSize(w, h)
    button:SetText(in_text)
    button:SetClickable(clickable)
    button:SetEnabled(enabled)
    return button
end

function createNumberbox(parent, i, w, h, min, max, incdec, d)
    local numberbox = loveframes.Create("numberbox", parent)
    if not d then numberbox.OnValueChanged = function(object, value) 
        if i == 12 then attributes[i][sizes_tab_n].value = value; attributes[i][sizes_tab_n].set = true
        else attributes[i].value = value end
        if not loading then psSet() end
    end
    elseif d then numberbox.OnValueChanged = function(object, value) 
        attributes[i].value[d] = value 
        if not loading then psSet() end
    end end
    numberbox:SetSize(w, h)
    numberbox:SetMinMax(min, max)
    numberbox:SetIncreaseAmount(incdec)
    numberbox:SetDecreaseAmount(incdec)
    return numberbox
end

function createNumberboxPos(parent, x, y, w, h, min, max, incdec, d)
    local numberbox = loveframes.Create("numberbox", parent)
    numberbox.OnValueChanged = function(object, value) 
        attributes[2][colors_tab_n][d] = value 
        attributes[2][colors_tab_n].set = true
        if not loading then psSet() end
    end
    numberbox:SetPos(x, y)
    numberbox:SetSize(w, h)
    numberbox:SetMinMax(min, max)
    numberbox:SetIncreaseAmount(incdec)
    numberbox:SetDecreaseAmount(incdec)
    return numberbox
end

function createMultichoice(parent, w, h, choices, type)
    local multichoice = loveframes.Create("multichoice", parent)
    multichoice:SetSize(w, h)
    for _, choice in ipairs(choices) do multichoice:AddChoice(choice) end
    multichoice.OnChoiceSelected = function(object, choice) 
        if type == "image" then sprite = love.graphics.newImage(choice) 
        elseif type == "list" then current_template_list = choice end
        if not loading then psSet() end
    end
    return multichoice
end

function createColorNumberboxes(parent, i, w, h, min, max, incdec)
    local main_panel = createPanel(parent, 0, 0, w, h)    
    local numberbox1 = createNumberboxPos(main_panel, 0, 0, 1.25*w/4, 28, min, max, incdec, 'r')
    local numberbox2 = createNumberboxPos(main_panel, 1.25*w/4, 0, 1.25*w/4, 28, min, max, incdec, 'g')
    local numberbox3 = createNumberboxPos(main_panel, 2.5*w/4, 0, 1.25*w/4, 28, min, max, incdec, 'b')
    local numberbox4 = createNumberboxPos(main_panel, 2.5*w/4, 28, 1.25*w/4, 28, min, max, incdec, 'a')
    return main_panel
end

function createTabNumberbox(parent, i, w, h, n, min, max, incdec)
    local tabs = loveframes.Create("tabs", parent)
    tabs:SetSize(w, h)
    tabs:SetTabHeight(16)
    local setN = function() sizes_tab_n = tabs:GetTabNumber() end
    for j = 1, n do tabs:AddTab(tostring(j), createNumberbox(tabs, i, w, 32, min, max, incdec), nil, nil, setN) end
    return tabs
end

function createTabNumberboxes(parent, i, w, h, n, min, max, incdec)
    local tabs = loveframes.Create("tabs", parent)
    tabs:SetSize(w, h)
    tabs:SetTabHeight(16)
    local setN = function() colors_tab_n = tabs:GetTabNumber() end
    for j = 1, n do tabs:AddTab(tostring(j), createColorNumberboxes(tabs, i, w, h, min, max, incdec), nil, nil, setN) end
    return tabs
end

function createMenuItemTextInput(parent, torp, in_text, w, h)
    local main_panel = createPanel(nil, 0, 0, w, h)
    local left_panel = createPanel(main_panel, 0, 0, w/4, h)
    local right_panel = createPanel(main_panel, w/4, 0, 3*w/4, h)
    local text_button = createButton(left_panel, in_text, 0, 0, w/4, h, false, false)
    local textinput = createTextInput(right_panel, torp, 0, 0, 3*w/4, h)
    return main_panel
end

function createMenuItemOneNumberbox(parent, i, in_text, w, h, min, max, incdec)
    local main_panel = createPanel(nil, 0, 0, w, h)
    local left_panel = createPanel(main_panel, 0, 0, w/2, h)
    local right_panel = createPanel(main_panel, w/2, 0, w/2, h)
    local text_button = createButton(left_panel, in_text, 0, 0, w/2, h, false, false)
    local numberbox = createNumberbox(right_panel, i, w/2, h, min, max, incdec)
    return main_panel
end

function createMenuItemTwoNumberboxes(parent, i, in_text, w, h, min1, max1, incdec1, min2, max2, incdec2)
    local main_panel = createPanel(nil, 0, 0, w, h)
    local left_panel = createPanel(main_panel, 0, 0, w/3, h)
    local right_panel = createPanel(main_panel, w/3, 0, 2*w/3, h)
    local right_left_panel = createPanel(right_panel, 0, 0, w/3, h)
    local right_right_panel = createPanel(right_panel, w/3, 0, w/3, h)
    local text_button = createButton(left_panel, in_text, 0, 0, w/3, h, false, false)
    local numberbox1 = createNumberbox(right_left_panel, i, w/3, h, min1, max1, incdec1, 'min')
    local numberbox2 = createNumberbox(right_right_panel, i, w/3, h, min2, max2, incdec2, 'max')
    return main_panel
end

function createMenuItemMultichoice(parent, in_text, w, h, choices, type)
    local main_panel = createPanel(nil, 0, 0, w, h)
    local left_panel = createPanel(main_panel, 0, 0, w/3, h)
    local right_panel = createPanel(main_panel, w/3, 0, 2*w/3, h)
    local text_button = createButton(left_panel, in_text, 0, 0, w/3, h, false, false)
    local multichoice = createMultichoice(right_panel, 2*w/3, h, choices, type)
    return main_panel
end

function createMenuItemList(parent, in_text, w, h, n, min, max, incdec)
    local main_panel = createPanel(nil, 0, 0, w, h)
    local left_panel = createPanel(main_panel, 0, 0, w/4, h)
    local right_panel = createPanel(main_panel, w/4, 0, 3*w/4, h)
    local text_button = createButton(left_panel, in_text, 0, 0, w/4, h, false, false)
    local list = createList(right_panel, 0, 0, 3*w/4, h, "horizontal", 5, 5)
    for i = 1, n do list:AddItem(createNumberbox(parent, 0, w/3, h, min, max, incdec)) end
    return main_panel
end

function createMenuItemTabNumberbox(parent, i, in_text, w, h, n, min, max, incdec)
    local main_panel = createPanel(nil, 0, 0, w, h)
    local left_panel = createPanel(main_panel, 0, 0, w/4, h)
    local right_panel = createPanel(main_panel, w/4, 0, 3*w/4, h)
    local text_button = createButton(left_panel, in_text, 0, 0, w/4, h, false, false)
    local tab = createTabNumberbox(right_panel, i, 3*w/4, h-1, n, min, max, incdec)
    return main_panel
end

function createMenuItemTabNumberboxes(parent, i, in_text, w, h, n, min, max, incdec)
    local main_panel = createPanel(nil, 0, 0, w, h)
    local left_panel = createPanel(main_panel, 0, 0, w/5, h)
    local right_panel = createPanel(main_panel, w/5, 0, 4*w/5, h)
    local text_button = createButton(left_panel, in_text, 0, 0, w/5, h, false, false)
    local tab = createTabNumberboxes(right_panel, i, 4*w/5, h-1, n, min, max, incdec)
    return main_panel
end

dnntimer = 0
dnntimer2 = 0
ilntimer = 0

function love.update(dt)
    if different_name then 
        dnntimer = dnntimer + dt 
        if dnntimer > 3 then
            dnntimer = 0
            different_name = false
        end
    end

    if different_name2 then
        dnntimer2 = dnntimer2 + dt
        if dnntimer2 > 5 then
            dnntimer2 = 0
            different_name2 = false
        end
    end

    if invalid_list_name then
        ilntimer = ilntimer + dt
        if ilntimer > 3 then
            ilntimer = 0
            invalid_list_name = false
        end
    end

    if template_list then
        for i = 1, #template_list do
            if template_panel_object then
                if templates_panel:GetChildren()[i]:GetText() == template_panel_object:GetText() then
                    selected_i = i
                end
            end
        end
    end

    loveframes.update(dt)
    ps:update(dt)
end

function love.draw()
    loveframes.draw()
    love.graphics.draw(ps, ps_x, ps_y)
    love.graphics.setFont(font12)
    if different_name then 
        love.graphics.print("Different name needed: " .. "'" .. main_name .. "'" .. " already in Templates List!", 236, 796) 
    end

    if different_name2 then
        love.graphics.print(load_str, width-font12:getWidth(load_str)-5, 514)
    end

    if invalid_list_name then
        local str = "Invalid list name: " .. "'" .. template_list_name .. "'"
        love.graphics.print(str, width-font12:getWidth(str)-236, 460)
    end
    love.graphics.setFont(font10)

    love.graphics.setColor(attributes[2][colors_tab_n].r, attributes[2][colors_tab_n].g, attributes[2][colors_tab_n].b, attributes[2][colors_tab_n].a)
    love.graphics.rectangle('fill', 68, 162, 103, 23)
    love.graphics.setColor(255, 255, 255, 255)
end

function love.mousepressed(x, y, button)
    loveframes.mousepressed(x, y, button)
    if button == 'l' then 
        if (x > 252 and x < 1050) or (x >= 1050 and y > 490) then
            ps_x = x; ps_y = y 
        end
    end
end

function love.mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button) 
end

function love.keypressed(key, unicode)
    if key == 'q' then love.event.push('quit') end
    if love.keyboard.isDown('lalt') or love.keyboard.isDown('ralt') then
        if key == 'r' then list:GetChildren()[20]:GetChildren()[1]:OnClick() end
        if key == 'a' then list:GetChildren()[20]:GetChildren()[2]:OnClick() end
        if key == 't' then templates_flist:GetChildren()[4]:GetChildren()[1]:OnClick() end
        if key == 'd' then templates_flist:GetChildren()[4]:GetChildren()[2]:OnClick() end
        if key == 's' then templates_flist:GetChildren()[5]:GetChildren()[1]:OnClick() end
        if key == 'o' then templates_flist:GetChildren()[5]:GetChildren()[2]:OnClick() end
    end
    loveframes.keypressed(key, unicode)
end

function love.keyreleased(key)
    loveframes.keyreleased(key)
end
