--村规决斗：幻神之战
--（本村规默认每人卡组里都有一张三幻神）
--开局时，双方将卡组里的【奥西里斯之天空龙】【欧贝利斯克之巨神兵】【太阳神之翼神龙】加入手牌。
--决斗中，只要这些卡不在原本持有者手卡存在，这些卡立刻加入原本持有者手卡。
--如果此时任何一方的【奥西里斯之天空龙】【欧贝利斯克之巨神兵】【太阳神之翼神龙】多于1张，那个玩家的基本分变为0。
--手牌里的三幻神得到以下效果。这些效果不能被无效。

--奥西里斯之天空龙
--这张卡在手牌时，得到以下效果。这些效果不会被无效。
--- 自己的手卡不会少于7张。每当不够时，立刻从卡组抽卡。每次因这个效果抽卡，这个数字减少1。
--- 自己的回合开始时，上述数字变回7。

--欧贝利斯克之巨神兵
--这张卡在手牌时，得到以下效果。这些效果不会被无效。
--- 对方受到战斗伤害时，对方失去8000点基本分。

--太阳神之翼神龙
--这张卡在手牌时，得到以下效果。这些效果不会被无效。
--- 主要阶段才能发动。把手牌的这张卡给对方观看，支付1000点，选场上1张卡。对方必须把那张卡送去墓地。
--（没有发动次数限制）
--- 自己·对方的回合结束阶段，自己的基本分变为8000。

HUANSHEN = HUANSHEN or {}

-- 三幻神的卡片代码（取其中一个版本的ID，使用IsCode检测同名即可）
HUANSHEN.CODE_SKY   = 10000020  -- 奥西里斯之天空龙
HUANSHEN.CODE_OBE   = 10000000  -- 欧贝利斯克之巨神兵
HUANSHEN.CODE_RA    = 10000010  -- 太阳神之翼神龙

-- 天空龙手卡目标数（每个玩家独立）
HUANSHEN.skyTarget = {}

-- 三幻神卡片引用（按持有者tp索引）
HUANSHEN.skyCard = {}
HUANSHEN.obeCard = {}
HUANSHEN.raCard  = {}

-- 是否为三幻神
function HUANSHEN.IsHuanShenCode(code)
    return code == HUANSHEN.CODE_SKY
        or code == HUANSHEN.CODE_OBE
        or code == HUANSHEN.CODE_RA
end

-- 是否为三幻神卡片
function HUANSHEN.IsHuanShen(c)
    return HUANSHEN.IsHuanShenCode(c:GetCode())
        or HUANSHEN.IsHuanShenCode(c:GetOriginalCode())
end

-- 计算某玩家手牌里三幻神的数量
function HUANSHEN.CountHuanShenInHand(tp)
    local g = Duel.GetMatchingGroup(HUANSHEN.IsHuanShen, tp, LOCATION_HAND, 0, nil)
    return g:GetCount()
end

------------------------------------------------------------------------
-- PreloadUds：注册ADJUST效果（全局，不随卡片状态变化）
------------------------------------------------------------------------
function Auxiliary.PreloadUds()
    local e1 = Effect.GlobalEffect()
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EVENT_ADJUST)
    e1:SetOperation(HUANSHEN.AdjustOp)
    Duel.RegisterEffect(e1, 0)
end

------------------------------------------------------------------------
-- ADJUST：维护三幻神在手牌，初始化卡片效果
------------------------------------------------------------------------
function HUANSHEN.AdjustOp(e, tp, eg, ep, ev, re, r, rp)
    -- 初始化随机数
    if not HUANSHEN.RandomSeedInit then
        HUANSHEN.RandomSeedInit = true
        math.random = Duel.GetRandomNumber or math.random
    end

    -- 初始化天空龙目标数
    if HUANSHEN.skyTarget[0] == nil then HUANSHEN.skyTarget[0] = 7 end
    if HUANSHEN.skyTarget[1] == nil then HUANSHEN.skyTarget[1] = 7 end

    -- 初始化：把双方卡组里的三幻神加入手牌，并注册各张卡的效果
    if not HUANSHEN.Init then
        HUANSHEN.Init = true
        for i = 0, 1 do
            HUANSHEN.InitPlayerGods(i)
        end
    end

    -- 维护：三幻神不在持有者手牌时，移回手牌
    for i = 0, 1 do
        HUANSHEN.MaintainGodsInHand(i)
    end

    -- 检查：若某玩家手牌里三幻神多于1张，基本分变为0
    for i = 0, 1 do
        if HUANSHEN.CountHuanShenInHand(i) > 1 then
            if Duel.GetLP(i) > 0 then
                Duel.SetLP(i, 0)
            end
        end
    end

    -- 天空龙手牌数维护（在ADJUST时检查）
    for i = 0, 1 do
        HUANSHEN.CheckSkyDraw(i)
    end
end

-- 初始化某玩家的三幻神（从卡组取出到手牌，并注册效果）
function HUANSHEN.InitPlayerGods(tp)
    -- 找天空龙
    local skyG = Duel.GetMatchingGroup(function(c)
        return c:IsCode(HUANSHEN.CODE_SKY)
    end, tp, LOCATION_DECK, 0, nil)
    local skyC = skyG:GetFirst()
    if skyC then
        Duel.SendtoHand(skyC, nil, REASON_RULE)
        HUANSHEN.skyCard[tp] = skyC
        HUANSHEN.RegisterSkyEffect(skyC, tp)
    end

    -- 找巨神兵
    local obeG = Duel.GetMatchingGroup(function(c)
        return c:IsCode(HUANSHEN.CODE_OBE)
    end, tp, LOCATION_DECK, 0, nil)
    local obeC = obeG:GetFirst()
    if obeC then
        Duel.SendtoHand(obeC, nil, REASON_RULE)
        HUANSHEN.obeCard[tp] = obeC
        HUANSHEN.RegisterObeEffect(obeC, tp)
    end

    -- 找翼神龙
    local raG = Duel.GetMatchingGroup(function(c)
        return c:IsCode(HUANSHEN.CODE_RA)
    end, tp, LOCATION_DECK, 0, nil)
    local raC = raG:GetFirst()
    if raC then
        Duel.SendtoHand(raC, nil, REASON_RULE)
        HUANSHEN.raCard[tp] = raC
        HUANSHEN.RegisterRaEffect(raC, tp)
    end
end

-- 维护三幻神在持有者手牌
function HUANSHEN.MaintainGodsInHand(tp)
    local cards = {
        HUANSHEN.skyCard[tp],
        HUANSHEN.obeCard[tp],
        HUANSHEN.raCard[tp],
    }
    for _, c in ipairs(cards) do
        if c and not c:IsLocation(LOCATION_HAND) then
            -- 不管在哪里，强制移回持有者手牌
            Duel.SendtoHand(c, nil, REASON_RULE)
        end
    end
end

------------------------------------------------------------------------
-- 天空龙：检查并补充手牌到目标数
------------------------------------------------------------------------
function HUANSHEN.CheckSkyDraw(tp)
    local skyC = HUANSHEN.skyCard[tp]
    -- 只有天空龙在手牌时才生效
    if not skyC or not skyC:IsLocation(LOCATION_HAND) then return end
    local target = HUANSHEN.skyTarget[tp]
    if target == nil then target = 7 end
    local handCount = Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0)
    if handCount < target and target > 0 then
        -- 一次性补足到当前目标数，然后目标数固定减1
        -- 例如目标=7，手牌=0，则抽7张，之后目标变6
        -- 下次手牌再归0时，抽6张，目标变5，以此类推（最多7+6+5+...+1张）
        local drawCount = target - handCount
        Duel.Draw(tp, drawCount, REASON_RULE)
        HUANSHEN.skyTarget[tp] = target - 1
    end
end

------------------------------------------------------------------------
-- 天空龙：在卡片上注册效果
-- 效果1（CONTINUOUS+FIELD）：回合开始时重置目标数为7
------------------------------------------------------------------------
function HUANSHEN.RegisterSkyEffect(c, tp)
    -- 效果：自己回合开始时，手牌目标数变回7
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_INACTIVATE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_PHASE + PHASE_DRAW)
    e1:SetCondition(function(e2, tp2, eg2, ep2, ev2, re2, r2, rp2)
        return Duel.GetTurnPlayer() == tp
    end)
    e1:SetOperation(function(e2, tp2, eg2, ep2, ev2, re2, r2, rp2)
        HUANSHEN.skyTarget[tp] = 7
    end)
    c:RegisterEffect(e1)
end

------------------------------------------------------------------------
-- 巨神兵：注册效果
-- TRIGGER_F + CONTINUOUS：对方受到战斗伤害时，对方失去8000点基本分
------------------------------------------------------------------------
function HUANSHEN.RegisterObeEffect(c, tp)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_INACTIVATE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetCondition(function(e2, tp2, eg2, ep2, ev2, re2, r2, rp2)
        -- ep2是受到伤害的玩家，要求是对方（1-tp）受到伤害，ev2是伤害量
        return ep2 == (1 - tp) and ev2 > 0
    end)
    e1:SetOperation(function(e2, tp2, eg2, ep2, ev2, re2, r2, rp2)
        local curLP = Duel.GetLP(1 - tp)
        if curLP > 0 then
            Duel.SetLP(1 - tp, math.max(0, curLP - 8000))
        end
    end)
    c:RegisterEffect(e1)
end

------------------------------------------------------------------------
-- 翼神龙：注册效果
-- 效果1（IGNITION）：主要阶段，展示此卡，支付1000，对方必须把选定场上卡送去墓地
-- 效果2（TRIGGER_F+CONTINUOUS）：自己/对方结束阶段，持有者基本分变为8000
------------------------------------------------------------------------
function HUANSHEN.RegisterRaEffect(c, tp)
    -- 效果1：主要阶段主动效果（无次数限制），无视抗性
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(1344018, 1)) -- 是否选场上1张卡送去墓地？
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_INACTIVATE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(function(e2, tp2, eg2, ep2, ev2, re2, r2, rp2, chk)
        if chk == 0 then return Duel.CheckLPCost(tp, 1000) end
        -- 给对方展示这张卡
        Duel.Hint(HINT_CARD, 1 - tp, c:GetCode())
        Duel.PayLPCost(tp, 1000)
    end)
    e1:SetTarget(function(e2, tp2, eg2, ep2, ev2, re2, r2, rp2, chk)
        if chk == 0 then
            return Duel.IsExistingMatchingCard(aux.TRUE, tp, LOCATION_MZONE + LOCATION_SZONE, LOCATION_MZONE + LOCATION_SZONE, 1, nil)
        end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
        local g = Duel.SelectMatchingCard(tp, aux.TRUE, tp, LOCATION_MZONE + LOCATION_SZONE, LOCATION_MZONE + LOCATION_SZONE, 1, 1, nil)
        Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, g, 1, 0, 0)
    end)
    e1:SetOperation(function(e2, tp2, eg2, ep2, ev2, re2, r2, rp2)
        local tc = Duel.GetFirstTarget()
        if tc and tc:IsRelateToEffect(e2) then
            -- 对方必须送去墓地，无视抗性
            Duel.SendtoGrave(tc, REASON_EFFECT + REASON_RULE)
        end
    end)
    c:RegisterEffect(e1)

    -- 效果2：自己·对方结束阶段，基本分变为8000（TRIGGER_F+CONTINUOUS，不入连锁）
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_INACTIVATE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCode(EVENT_PHASE + PHASE_END)
    e2:SetOperation(function(e3, tp2, eg2, ep2, ev2, re2, r2, rp2)
        -- 每个结束阶段（自己和对方的都触发），持有者基本分变为8000
        local curLP = Duel.GetLP(tp)
        if curLP ~= 8000 then
            Duel.SetLP(tp, 8000)
        end
    end)
    c:RegisterEffect(e2)
end
