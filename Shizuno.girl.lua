mnttt = 136 -- 牌山總枚數
total = 84 -- 配牌后总枚数
rate_other = 1 -- 对他家影响调整倍率
rate_self = 1 -- 对自家影响调整倍率
iter_default = 64

-- 线性同余随机数发生器
a = 1103515245
c = 12345
m = 2 ^ 32 - 1
seed = 1

function random()
    seed = (a * seed + c) % m
    return seed
end

-- 猴子阶段扰乱配牌，随局数增加幅度变大
function onmonkey()
    local exist0 = exists[self:left():index()]
    local exist1 = exists[self:right():index()]
    local exist2 = exists[self:cross():index()]
    local exist3 = exists[self:index()]
    local round = game:getround()
    for _, t in ipairs(T34.all) do
        exist0:incmk(t, random() % mnttt * round * rate_other)
        exist1:incmk(t, random() % mnttt * round * rate_other)
        exist2:incmk(t, random() % mnttt * round * rate_other)
        exist3:incmk(t, random() % mnttt * round * rate_self)
    end
end

-- 随局数增加挂力增强
function checkinit()
    local round = game:getround()
    return iter > iter_default * round
end

-- 摸牌阶段影响摸牌
function ondraw()
    local round = game:getround()

    -- 扰乱他家摸牌
    if who ~= self then
        if rinshan then
            for _, t in ipairs(T34.all) do
                local rsmk = random() % (total - mount:remainrinshan()) * round * rate_other -- 岭上摸牌挂力，随局数和开杠次数增加增强
                mount:lighta(t, rsmk, true)
                mount:lightb(t, rsmk, true)
            end
        else
            for _, t in ipairs(T34.all) do
                local incmk = random() % (total - mount:remainpii() - mount:remainrinshan()) * round * rate_other -- 一般摸牌挂力，随局数增加和牌山深入增强
                mount:lighta(t, incmk)
                mount:lightb(t, incmk)
            end
        end
        return
    end

    -- 强化自家摸牌
    local hand = game:gethand(self)
    local effas = hand:effa()
    if rinshan then
        for _, t in ipairs(effas) do
            local rsmk = random() % (total - mount:remainrinshan()) * round * rate_self
            mount:lighta(t, rsmk, true)
            mount:lightb(t, rsmk, true)
        end
    else
        for _, t in ipairs(effas) do
            local incmk = random() % (total - mount:remainpii() - mount:remainrinshan()) * round * rate_self
            mount:lighta(t, incmk)
            mount:lightb(t, incmk)
        end
    end
end
