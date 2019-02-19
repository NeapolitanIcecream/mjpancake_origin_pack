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

-- 判斷筋牌（有序）
function isJin(t1, t2)
    return t1:isnum() and t2:isnum() and t1:suit() == t2:suit() and t1:val() + 3 == t2:val()
end

-- 判斷可以明槓
function canMinKan(closed, t)
    return closed:ct(t) == 3
end

-- 判斷可以碰
function canPon(closed, t)
    return closed:ct(t) >= 2
end

-- 判斷可以吃
function canChii(closed, t)
    return canChiiAsLeft(closed, t) or canChiiAsMiddle(closed, t) or canChiiAsRight(closed, t)
end

-- 左副露吃
function canChiiAsLeft(closed, t)
    if (t:isz() or t:val() >= 8) then
        return false
    end

    -- 這裡用 dora hack next
    local ccal_n = t:dora()
    local ccal_nn = ccal_n:dora()
    if (not (closed:ct(ccal_n) > 0 and closed:ct(ccal_nn) > 0)) then
        return false
    end

    -- 計算食替
    for _, ccal_t in ipairs(T34.all) do
        local ccal_ct = closed:ct(ccal_t)
        if
            ccal_ct >= 1 and ((not (ccal_t == ccal_n) and not (ccal_t == ccal_nn)) or ccal_ct >= 2) and
                not (ccal_t == t) and
                not (isJin(t, ccal_t))
         then
            return true
        end
    end

    return false
end

-- 中副露吃
function canChiiAsMiddle(closed, t)
    if (t:isz() or t:val() == 1 or t:val() == 9) then
        return false
    end

    -- 這裡用 indicator hack prev
    local ccal_n = t:dora()
    local ccal_p = t:indicator()
    if (not (closed:ct(ccal_n) > 0 and closed:ct(ccal_p) > 0)) then
        return false
    end

    -- 計算食替
    for _, ccal_t in ipairs(T34.all) do
        local ccal_ct = closed:ct(ccal_t)
        if ccal_ct >= 1 and ((not (ccal_t == ccal_n) and not (ccal_t == ccal_p)) or ccal_ct >= 2) and not (ccal_t == t) then
            return true
        end
    end

    return false
end

-- 右副露吃
function canChiiAsRight(closed, t)
    if (t:isz() or t:val() <= 2) then
        return false
    end

    local ccal_p = t:indicator()
    local ccal_pp = ccal_p:indicator()
    if (not (closed:ct(ccal_p) > 0 and closed:ct(ccal_pp) > 0)) then
        return false
    end

    -- 計算食替
    for _, ccal_t in ipairs(T34.all) do
        local ccal_ct = closed:ct(ccal_t)
        if
            ccal_ct >= 1 and ((not (ccal_t == ccal_p) and not (ccal_t == ccal_pp)) or ccal_ct >= 2) and
                not (ccal_t == t) and
                not (isJin(ccal_t, t))
         then
            return true
        end
    end

    return false
end

-- 每局开始时初始化全局变量
function checkinit()
    if who ~= self then
        return true
    end

    ready = false

    -- 处理天听海底
    if init:ready() then
        local succ = false -- 本次沉底是否成功
        local listen = init:effa() -- 听牌

        for _, t in ipairs(listen) do
            if mount:remaina(t) >= 1 then
                mount:loadb(t, 1)
                succ = true
                ready = true
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

    -- 计算海底方位
    local mod = remain % 4
    local time = math.floor(remain / 4)

    -- 地狱一向听
    if who ~= self and (not (rinshan)) and hand:step() == 1 then
        for _, t in ipairs(hand:effa()) do
            local n = mount:remaina(t)
            mount:lighta(t, (n * (-10)) * rate_other)
        end
    end

    -- 非海底路线提高直击机会
    if who ~= self and game:gethand(self):ready() and not (ready) then
        for _, t in ipairs(game:gethand(self):effa()) do
            local n = mount:remaina(t)
            mount:lighta(t, (n * 10) * rate_other)
        end
    end

    -- 提高鸣牌机会
    if who == self:left() and (not (rinshan)) and mod == 1 and not (ready) then
        closed = game:gethand(self):closed()
        it_hand = hand
        for _, t in ipairs(T34.all) do
            if canChii(closed, t) then
                mount:lighta(t, 125 * rate_other)
            end
            for _, tt in ipairs(it_hand:effa()) do
                if tt == t then
                    mount:lighta(t, -125 * rate_other)
                    break
                end
            end
        end
    end

    if who ~= self and (not (rinshan)) and mod == 1 and not (ready) then
        closed = game:gethand(self):closed()
        it_hand = hand
        for _, t in ipairs(T34.all) do
            if canPon(closed, t) then
                mount:lighta(t, 125 * rate_other)
            end
            for _, tt in ipairs(it_hand:effa()) do
                if tt == t then
                    mount:lighta(t, -125 * rate_other)
                    break
                end
            end
        end
    end

    -- 準備海底後，壓制他家鳴牌
    if who ~= self and (not (rinshan)) and ready then
        closedr = game:gethand(who:right()):closed()
        closedl = game:gethand(who:left()):closed()
        closedc = game:gethand(who:cross()):closed()
        for _, t in ipairs(T34.all) do
            if canChii(closedr, t) or canPon(closedr, t) or canPon(closedl, t) or canPon(closedc, t) then
                mount:lighta(t, -125 * rate_other)
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
                ready = true
                undersea = t
                wait = copy(listen)
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
        -- 加速听牌
        if not (hand:ready()) then
            for _, t in ipairs(hand:effa()) do
                local n = mount:remaina(t)
                mount:lighta(t, n * 10 * rate_self)
            end
        end

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
