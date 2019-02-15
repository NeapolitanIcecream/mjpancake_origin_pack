rate_self = 1 -- 对自身影响倍率
rate_other = 1 -- 对他家影响倍率
undersea = T37.new("1p") -- 海底牌

-- compare table
function compare(a, b)
    local ta = type(a)
    local tb = type(b)
    if ta ~= "table" and tb ~= "table" then
        return a == b
    end
    if ta ~= tb then
        return false
    end
    if (#ta) ~= (#tb) then
        return false
    end
    for ka, va in pairs(a) do
        if not (compare(b[ka], va)) then
            return false
        end
    end
    return true
end

-- copy table
function copy(obj)
    if type(obj) ~= "table" then
        return obj
    end
    local res = {}
    for k, v in pairs(obj) do
        res[copy(k)] = copy(v)
    end
    return res
end

-- 每局开始时初始化全局变量
function checkinit()
    if who ~= self then
        return true
    end

    -- 处理天听海底
    if init:ready() then
        local succ = false -- 本次沉底是否成功
        local listen = init:effa() -- 听牌

        for _, t in ipairs(listen) do
            if mount:remaina(t) >= 1 then
                mount:loadb(t, 1)
                succ = true
                undersea = t
                wait = copy(listen) -- 记录听牌
                print(t:str34() .. " 已经沉入海底")
                break
            end
        end
        if not (succ) then
            print("海底残枚不足")
        end
    end

    return true
end

function ondraw()
    remain = mount:remainpii()
    local hand = game:gethand(who)

    -- 地狱一向听
    if who ~= self and (not (rinshan)) and (hand:step() == 1 or hand:step7() == 1 or hand:step13() == 1) then
        for _, t in ipairs(hand:effa()) do
            local n = mount:remaina(t)
            mount:lighta(t, (n * (-10)) * rate_other)
        end
    end

    -- 提高鸣牌和直击机会，压制他家鸣牌
    if who ~= self then
        local hand_slf = game:gethand(self)
        local hand_left = game:gethand(who:left())
        local hand_cross = game:gethand(who:cross())
        local hand_right = game:gethand(who:right())

        if not (hand_slf:ready()) then
            for _, t in ipairs(hand_slf:effa()) do
                local n = mount:remaina(t)
                mount:lighta(t, n * 20 * rate_other)
            end
        end

        if not (hand_left:ready()) then
            for _, t in ipairs(hand_left:effa()) do
                local n = mount:remaina(t)
                mount:lighta(t, n * (-10) * rate_other)
            end
        end

        if not (hand_cross:ready()) then
            for _, t in ipairs(hand_cross:effa()) do
                local n = mount:remaina(t)
                mount:lighta(t, n * (-10) * rate_other)
            end
        end

        if not (hand_right:ready()) then
            for _, t in ipairs(hand_right:effa()) do
                local n = mount:remaina(t)
                mount:lighta(t, n * (-10) * rate_other)
            end
        end
    end

    -- 准备海底捞月
    if who == self and not (compare(hand:effa(), wait)) and hand:ready() then
        local succ = false
        local listen = hand:effa()
        for _, t in ipairs(listen) do
            if mount:remaina(t) >= 1 then
                mount:loadb(t, 1)
                succ = true
                undersea = t
                wait = copy(listen)
                print(t:str34() .. " 已经沉入海底")
                break
            end
        end
        if not (succ) then
            print("海底残枚不足")
        end
    end

    if who == self then
        -- todo: 早巡大牌直击
        if not (hand:ready()) then
            for _, t in ipairs(hand:effa()) do
                local n = mount:remaina(t)
                mount:lighta(t, n * 10 * rate_self)
            end
        end

        -- 计算海底方位
        local mod = remain % 4
        local time = math.floor(remain / 4)
        if (mod == 1) then
            print(time .. "巡后，自家到达海底")
        elseif (mod == 2) then
            print(time .. "巡后，下家到达海底")
        elseif (mod == 3) then
            print(time .. "巡后，对家到达海底")
        elseif (mod == 0) then
            print(time .. "巡后，上家到达海底")
        end
    end

    -- 封锁海底牌
    if ready and remain ~= 1 then
        mount:lightb(undersea, (-1000) * rate_self)
    end

    -- 释放海底牌
    if ready and remain == 1 then
        mount:lightb(undersea, 1000 * rate_self)
    end
end
