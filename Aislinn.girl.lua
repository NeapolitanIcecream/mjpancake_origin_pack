rate = 1
incmk = 1000

-- 线性同余随机数发生器
a = 1103515245
c = 12345
m = 2 ^ 32

function random(seed)
    return (a * seed + c) % m
end

-- 生成理想画面
function checkinit()
    if who ~= self then
        return true
    end

    local hand = init
    local effas = hand:effa()
    local steps = math.min(hand:step(), hand:step7(), hand:step13())
    local seed = game:getround() + game:getextraround() -- 种子
    local len = #effas -- 序列长度
    local j = math.floor(random(seed)) % len + 1 -- 骰子

    loc = self:turnfrom(game:getdealer()) -- 庄家距离定位
    turn = 0 -- 回合统计
    paint = {} -- 约定进张
    count = {} -- 牌数统计

    -- 统计手牌数目
    for _, t in ipairs(T34.all) do
        count[t:id34()] = hand:ct(t)
    end

    for i = 1, 13 do
        local k = 1 -- 骰子计数
        local loop = false -- 有效循环

        repeat
            -- 从头循环
            if k > len then
                k = 1
                loop = true
            end

            -- 记录进张
            local t = effas[k]
            if k >= j or loop then
                if count[t:id34()] < 4 then
                    paint[i] = t
                    count[t:id34()] = count[t:id34()] + 1
                    print(i .. "巡进张为" .. t:str34())
                    break
                end
            end

            k = k + 1
        until k > len and loop

        j = math.floor(random(j)) % len + 1
    end

    return true
end

function ondraw()
    if who:turnfrom(game:getdealer()) == loc then
        turn = turn + 1
        mount:lighta(paint[turn], incmk)
    end
end

