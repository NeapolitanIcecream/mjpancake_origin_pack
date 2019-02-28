rate = 1
incmk = 100000

-- 线性同余随机数发生器
a = 1103515245
c = 12345
m = 2 ^ 32 - 1
seed = 1

function random()
    seed = (a * seed + c) % m
    return seed
end

function checkinit()
    if who ~= self or iter > 100 then
        return true
    end

    return init:step() <= 4
end

function ondraw()
    if round_started then
        local hand = {}
        hand[0] = game:gethand(self)
        hand[1] = game:gethand(self:right())
        hand[2] = game:gethand(self:cross())
        hand[3] = game:gethand(self:left())
        local effas = hand[0]:effa()
        local len = #effas -- 序列长度
        local j = random() % len + 1 -- 骰子

        drawn = (-1) * self:turnfrom(game:getdealer()) -- 抽牌统计
        turn = 0 -- 回合統計
        cntturn = 0 -- turnmax 统计
        cntpaint = {} -- cnt[paint[turn]]
        paint = {} -- 约定进张
        count = {} -- 牌数统计
        loadb = false -- have been loaded to mountb
        is_kan = false -- avoid kan change order
        round_started = false

        -- 初始化 count，cntpaint
        for _, t in ipairs(T34.all) do
            count[t:id34()] = 0
            cntpaint[t:id34()] = 0
        end

        for _, t in ipairs(T34.all) do
            for i = 0, 3 do
                count[t:id34()] = count[t:id34()] + hand[i]:ct(t)
            end
        end

        for i = 1, 13 do
            local k = 1 -- 骰子计数
            local loop = false -- 有效循环
            local flag = true

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
                        paint[i] = t:id34()
                        count[t:id34()] = count[t:id34()] + 1
                        cntturn = cntturn + 1
                        cntpaint[t:id34()] = cntpaint[t:id34()] + 1
                        flag = false
                        print(i .. "巡进张为" .. t:str34()) -- .. " debug " .. cntturn .. " " .. count[t:id34()])
                        break
                    end
                end

                k = k + 1
            until k > len and loop

            if flag then
                break
            end

            j = random() % len + 1
        end

        -- loaded to b
        for i = 1, cntturn do
            mount:loadb(T37.new(paint[i]), cntpaint[paint[i]])
        end
    end

    if is_kan then
        return
    end

    if drawn == 0 and turn < cntturn then
        drawn = drawn - 4
        turn = turn + 1
        local t = T34.new(paint[turn])
        local tt = 0
        local dis = who:turnfrom(self)

        mount:lightb(t, incmk * rate)

        if dis == 0 then
            print("进张位置为自家")
        elseif dis == 1 then
            print("进张位置为下家")
        elseif dis == 2 then
            print("进张位置为对家")
        elseif dis == 3 then
            print("进张位置为上家")
        end

        if turn < cntturn then
            tt = T34.new(paint[turn + 1])
            print("本巡进张预计为" .. t:str34() .. "，下一巡进张预计为" .. tt:str34())
        else
            print("本巡进张预计为" .. t:str34())
        end
    end
end

function ongameevent()
    -- round-started
    if event.type == "round-started" then
        round_started = true
    end

    -- drawn
    if event.type == "drawn" then
        if not (is_kan) then
            drawn = drawn + 1
        else
            is_kan = false
            -- print("debug-deal-kan")
        end
    end

    -- barked
    if event.type == "barked" then
        local bark = event.args["bark"]
        if bark:type() == "daiminkan" or bark:type() == "ankan" or bark:type() == "kakan" then
            is_kan = true
            -- print("debug-found-kan")
        end
    end
end
