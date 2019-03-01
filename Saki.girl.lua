rate_self = 1
rate_others = 1
incmk_rins = 1000
incmk_3f = 40
incmk_pg = {[0] = 0, [1] = 0, [2] = 80, [3] = 160, [4] = 0}
incmk_dkg = {[0] = 0, [1] = 40, [2] = 80, [3] = 160, [4] = 0}
incmk_kakan = 10000

-- 增加西風配牌
function onmonkey()
    local exist = exists[self:index()]
    exist:incmk(T34.new("3f"), incmk_3f * rate_self)
end

function checkinit()
    if who ~= self or iter > 500 then
        return init:ct(T34.new("3f")) == 0
    end

    if init:ct(T34.new("3f")) >= 1 and init:step7() <= 3 then
        koncai = {}
        cnt_koncai = 0
        return true
    end

    return false
end

function ondraw()
    local hand_self = game:gethand(self)
    local closed_self = hand_self:closed()
    local bark_self = hand_self:barks()
    local effa_self = hand_self:effa()
    local hand_other = game:gethand(who)
    local effa_other = hand_other:effa()
    local ready_self = hand_self:ready()

    -- 沈底西風，加槓槓材
    if who ~= self then
        mount:lighta(T34.new("3f"), (-1) * incmk_3f * rate_others)
        for i = 1, cnt_koncai do
            mount:lighta(koncai[i], (-1) * incmk_kakan * rate_others)
        end
    end

    -- 容易碰/明槓
    if who ~= self and not (ready) then
        for _, t in ipairs(T34.all) do
            local flag = true

            for _, tt in ipairs(effa_other) do
                if t:id34() == tt:id34() then
                    flag = false
                    break
                end
            end

            if flag then
                -- print(t:str34() .. " pg " .. incmk_pg[closed_self:ct(t)] * rate_others)
                mount:lighta(t, incmk_pg[closed_self:ct(t)] * rate_others)
            else
                mount:lighta(t, (-1) * incmk_pg[closed_self:ct(t)] * rate_others)
            end
        end
    end

    if who == self then
        -- 容易獲得對/刻/暗槓/西風
        for _, t in ipairs(T34.all) do
            -- print(t:str34() .. " dkg" .. incmk_dkg[closed_self:ct(t)] * rate_self)
            mount:lighta(t, incmk_dkg[closed_self:ct(t)] * rate_self)
        end

        mount:lighta(T34.new("3f"), incmk_3f * rate_self)

        -- 容易加槓
        for _, m in ipairs(bark_self) do
            if m:type() == "pon" then
                -- print(m[1]:str34() .. " kakan " .. incmk_kakan * rate_self)
                mount:lighta(m[1], incmk_kakan * rate_self)
                mount:lighta(m[1], incmk_kakan * rate_self, true)
            end
        end

        -- 從嶺上獲得有效牌
        if rinshan then
            for _, t in ipairs(effa_self) do
                -- print(t:str34() .. " rins " .. incmk_rins * rate_self)
                mount:lighta(t, incmk_rins * rate_self, true)
            end
        end
    end
end

function ongameevent()
    if event.type == "barked" and event.args["who"] == self and event.args["bark"]:type() == "pon" then
        local bark = event.args["bark"]
        cnt_koncai = cnt_koncai + 1
        koncai[cnt_koncai] = bark[1]
    end
end

-- todo：正負零，開槓不加寶牌
