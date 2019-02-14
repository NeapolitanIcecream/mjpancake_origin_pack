rate_self = 1 -- 对自身影响倍率
rate_other = 1 -- 对他家影响倍率
undersea = T37.new("1p") -- 海底牌

-- 每局开始时初始化全局变量
function checkinit()
    ready = false -- 等待海底捞月
    hand_cur = init -- 等待海底捞月时的手牌

    -- 处理天听海底
    if hand_cur:ready() then
        local succ = false -- 本次沉底是否成功
        for _, t in ipairs(hand_cur:effa()) do
            if mount:remaina(t) >= 1 then
                mount:loadb(t, 1)
                ready = true
                succ = true
                undersea = t
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

    -- 准备海底捞月
    if who == self and hand ~= hand_cur and hand:ready() then
        local succ = false
        for _, t in ipairs(hand:effa()) do
            if mount:remaina(t) >= 1 then
                mount:loadb(t, 1)
                ready = true
                succ = true
                undersea = t
                hand_cur = hand
                print(t:str34() .. " 已经沉入海底")
                break
            end
        end
        if not (succ) then
            ready = false
            print("海底残枚不足")
        end
    end

    if who == self then
        -- todo: 早巡大牌直击
        if not (hand:ready()) then
            for _, t in ipairs(hand:effa()) do
                mount:lighta(t, 40 * rate_self)
            end
        end

        -- 计算海底方位
        local mod = remain % 4
        if (mod == 1) then
            print("自家海底")
        elseif (mod == 2) then
            print("下家海底")
        elseif (mod == 3) then
            print("对家海底")
        elseif (mod == 0) then
            print("上家海底")
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
