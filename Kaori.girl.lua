rate = 10
incmk = 40
luck_limit = 100
incluck_step = 100
incluck_stepin = 25
incluck_stranger = 50

function checkinit()
    if who ~= self then
        return true
    end
    
    local hand = game:gethand(self)
    step = hand:step()
    return true
end

function ondraw()
    if who ~= self then
        return
    end

    local hand = game:gethand(self)

    -- 獎勵
    if luck >= luck_limit then
        luck = luck - luck_limit

        for _, t in ipairs(hand:effa()) do
            mount:lighta(t, incmk * rate)
        end
    end
end

function ongameevent()
    -- round-started
    if event.type == "round-started" then
        luck = 0
        richied = false
        nearend = false
        action_self = false
    end

    -- drawn
    if event.type == "drawn" and event.args["who"] == self then
        action_self = true
    end

    -- barked
    if event.type == "barked" and event.args["who"] == self then
        action_self = true
    end

    -- discarded
    if event.type == "discarded" and action_self then
        action_self = false
        local hand = game:gethand(self)
        local right = self:right()
        local cross = self:cross()
        local left = self:left()
        local river0 = game:getriver(self)
        local river1 = game:getriver(right)
        local river2 = game:getriver(cross)
        local river3 = game:getriver(left)
        local stranger = true
        local swapout = river0[#river0]
        local step_loc = hand:step()

        -- 晚巡判斷
        if nearend == false and #river0 >= 9 then
            nearend = true
        end

        -- 生張判斷
        if nearend then
            for _, v in ipairs(river1) do
                if v:id34() == swapout:id34() then
                    stranger = false
                    break
                end
            end
        end

        if nearend and stranger then
            for _, v in ipairs(river2) do
                if v:id34() == swapout:id34() then
                    stranger = false
                    break
                end
            end
        end

        if nearend and stranger then
            for _, v in ipairs(river3) do
                if v:id34() == swapout:id34() then
                    stranger = false
                    break
                end
            end
        end

        -- 晚巡生張獎勵
        if nearend and stranger then
            luck = luck + incluck_stranger
            print("晚巡生張獎勵")
        end

        -- 立直生張獎勵
        if richied and stranger then
            luck = luck + incluck_stranger
            print("立直生張獎勵")
        end

        -- 不進向聽
        if step_loc == step then
            luck = luck + incluck_stepin
            print("不進向聽")
        end

        -- 退向聽
        if step_loc > step then
            step = step_loc
            luck = luck + incluck_step
            print("退向聽")
        end

        -- 進向聽
        if step_loc < step then
            step = step_loc
        end
    end

    -- riichi-established
    if richied == false and event.type == "riichi-established" and event.args["who"] ~= self then
        richied = true
    end
end
