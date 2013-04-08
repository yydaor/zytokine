function collEnsure(class_name1, a, class_name2, b)
    if a.class.name == class_name2 and b.class.name == class_name1 then return b, a
    else return a, b end
end

function collIf(class_name1, class_name2, a, b)
    if (a.class.name == class_name1 and b.class.name == class_name2) or
       (a.class.name == class_name2 and b.class.name == class_name1) then
       return true
    else return false end
end


function findIndexByID(list, id)
    for i, v in ipairs(list) do
        if v.id == id then return i end
    end
end

function table.keyRemove(t, k)
    local result = {}
    for key, value in pairs(t) do
        if key ~= k then result[key] = value end
    end
    return result 
end


function table.filter(t, f, ...)
    local result = {} 
    for _, v in ipairs(t) do
        if f(v, ...) then
            table.insert(result, v)
        end
    end
    return result
end

function table.map(t, f, ...)
    local result = {}
    for _, v in ipairs(t) do
        table.insert(result, f(v, ...))
    end
    return result
end

function table.head(t) return t[1] end
function table.tail(t) table.remove(t, 1); return t end

function table.fold(t, f, neutral)
    if #t == 1 then return f(table.head(t), neutral)  
    else return f(table.head(t), table.fold(table.tail(t), f, neutral)) end
end

function table.contains(t, v)
    for _, e in ipairs(t) do
        if v == e then return true end
    end
    return false
end

function table.join(t1, t2)
    local joined = {}
    for _, e in ipairs(t1) do table.insert(joined, e) end
    for _, e in ipairs(t2) do table.insert(joined, e) end
    return joined
end

function table.choose(choices)
    return choices[math.random(1, #choices)]
end

function math.prandom(min, max)
    return math.random(min*1000, max*1000)/1000
end

function math.round(n, p)
    local m = math.pow(10, p or 0)
    return math.floor(n*m+0.5)/m
end

function math.between(n, min, max)
    if n >= min and n <= max then return true else return false end
end


function dice(chance)
    local r = math.random(1, 1000)
    if r <= chance*1000 then return true else return false end
end
