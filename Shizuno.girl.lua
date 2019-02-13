total = 83 -- 配牌后总枚数
total_exp_rinshan = 69 -- 除王牌外配牌后总枚数
rate_other = 8 -- 对他家影响调整倍率
rate_self = 4 -- 对自家影响调整倍率

-- 猴子阶段扰乱配牌，随局数增加幅度变大
function onmonkey()
    local exist0 = exists[self:left():index()]
    local exist1 = exists[self:right():index()]
    local exist2 = exists[self:cross():index()]
    local exist3 = exists[self:index()]
    local round = game:getround()
    for _, t in ipairs(T34.all) do
        exist0:incmk(t, 5 * round * rate_other)
        exist1:incmk(t, 5 * round * rate_other)
        exist2:incmk(t, 5 * round * rate_other)
        exist3:incmk(t, 5 * round * rate_self)
    end
end

-- 随局数增加挂力增强
function checkinit()
    local round = game:getround()
    return iter > 10 * round
end

-- 摸牌阶段影响摸牌
function ondraw()
    local round = game:getround()
    local incmk = round * 5 + (total_exp_rinshan - mount:remainpii()) -- 一般摸牌挂力，随局数增加和牌山深入增强
    local rsmk = round * 5 + (total - mount:remainrinshan()) -- 岭上摸牌挂力，随局数和开杠次数增加增强

    -- 扰乱他家摸牌
    if who ~= self then
        if rinshan then
            for _, t in ipairs(T34.all) do
                mount:lighta(t, rsmk * rate_other, true)
                mount:lightb(t, rsmk * rate_other, true)
            end
        else
            for _, t in ipairs(T34.all) do
                mount:lighta(t, incmk * rate_other)
                mount:lightb(t, incmk * rate_other)
            end
        end
        return
    end

    -- 强化自家摸牌
    local hand = game:gethand(self)
    local effas = hand:effa()
    if rinshan then
        for _, t in ipairs(effas) do
            mount:lighta(t, rsmk * rate_self, true)
        end
    else
        for _, t in ipairs(effas) do
            mount:lighta(t, incmk * rate_self)
        end
    end
end
