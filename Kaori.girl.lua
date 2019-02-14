rate = 4
incmk = 40

function checkinit()
    step = math.min(init:step(), init:step7(), init:step13())
    cnt = 0
    return true
end

function ondraw()
    if who ~= self then
        return
    end

    local hand = game:gethand(self)
    local step_loc = math.min(hand:step(), hand:step7(), hand:step13())
    if step_loc > step or cnt > 3 then
        for _, t in ipairs(hand:effa()) do
            mount:lighta(t, incmk * rate)
        end
        cnt = 0
    elseif step_loc == step then
        cnt = cnt + 1
    else
        step = step_loc
        cnt = 0
    end
end
