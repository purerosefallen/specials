-- ブラック・ガーデン
-- Black Garden
local SUMMONED_BY_BLACK_GARDEN = 0x20
function c71645242.FaceupFilter(f, ...)
    local params = {...}
    return function(target)
        return target:IsFaceup() and f(target, table.unpack(params))
    end
end
function c71645242.initial_effect(c)
    -- Activate
    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    -- Halve the ATK of a Summoned monster, then, its controller Special Summons 1 "Rose Token" to their opponent's field in Attack Position
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(71645242, 0))
    e1:SetCategory(CATEGORY_ATKCHANGE + CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_FZONE)
    e1:SetCode(EVENT_CUSTOM + 71645242)
    e1:SetTarget(c71645242.atksptg)
    e1:SetOperation(c71645242.atkspop)
    c:RegisterEffect(e1)
    -- Destroy this card and as many Plant monsters as possible, then Special Summon 1 monster in your GY with ATK equal to the total ATK of all Plant monsters
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(71645242, 1))
    e2:SetCategory(CATEGORY_DESTROY + CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTarget(c71645242.dessptg)
    e2:SetOperation(c71645242.desspop)
    c:RegisterEffect(e2)
    if not c71645242.global_check then
        c71645242.global_check = true
        local ge1 = Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SUMMON_SUCCESS)
        ge1:SetCondition(c71645242.regcon)
        ge1:SetOperation(c71645242.regop)
        Duel.RegisterEffect(ge1, 0)
        local ge2 = ge1:Clone()
        ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
        Duel.RegisterEffect(ge2, 0)
    end
end
function c71645242.cfilter(c, tp)
    return c:IsControler(tp) and c:GetSummonType() ~= SUMMON_TYPE_SPECIAL + SUMMONED_BY_BLACK_GARDEN
end
function c71645242.regcon(e, tp, eg, ep, ev, re, r, rp)
    local sf = 0
    if eg:IsExists(c71645242.cfilter, 1, nil, 0) then
        sf = sf + 1
    end
    if eg:IsExists(c71645242.cfilter, 1, nil, 1) then
        sf = sf + 2
    end
    e:SetLabel(sf)
    return sf ~= 0
end
function c71645242.regop(e, tp, eg, ep, ev, re, r, rp)
    Duel.RaiseEvent(eg, EVENT_CUSTOM + 71645242, e, r, rp, ep, e:GetLabel())
end
function c71645242.atksptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return e:GetHandler():IsRelateToEffect(e)
    end
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 1, 0, 0)
    local p
    if bit.extract(ev, tp) ~= 0 and bit.extract(ev, 1 - tp) ~= 0 then
        p = PLAYER_ALL
    elseif bit.extract(ev, tp) ~= 0 then
        p = tp
    else
        p = 1 - tp
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, p, 0)
end
function c71645242.atkfilter(c, e)
    return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c71645242.atkspop(e, tp, eg, ep, ev, re, r, rp)
    local g = eg:Filter(c71645242.atkfilter, nil, e)
    if #g == 0 then
        return
    end
    local change = false
    local tc = g:GetFirst()
    while tc do
        if tc:IsFaceup() then
            local preatk = tc:GetAttack()
            local e1 = Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(math.ceil(tc:GetAttack() / 2))
            e1:SetReset(RESET_EVENT | RESETS_STANDARD)
            tc:RegisterEffect(e1)
            if not tc:IsImmuneToEffect(e1) and math.ceil(preatk / 2) == tc:GetAttack() then
                change = true
            end
        end
        tc = g:GetNext()
    end

    if not change then
        return
    end
    if bit.extract(ev, tp) ~= 0 and Duel.GetLocationCount(1 - tp, LOCATION_MZONE) > 0 and
        Duel.IsPlayerCanSpecialSummonMonster(tp, 71645243, 0, TYPES_TOKEN_MONSTER, 800, 800, 2, RACE_PLANT,
            ATTRIBUTE_DARK, POS_FACEUP_ATTACK, 1 - tp) then
        local token = Duel.CreateToken(tp, 71645243)
        Duel.SpecialSummonStep(token, SUMMONED_BY_BLACK_GARDEN, tp, 1 - tp, false, false, POS_FACEUP_ATTACK)
    end
    if bit.extract(ev, 1 - tp) ~= 0 and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
        Duel.IsPlayerCanSpecialSummonMonster(1 - tp, 71645243, 0, TYPES_TOKEN_MONSTER, 800, 800, 2, RACE_PLANT,
            ATTRIBUTE_DARK, POS_FACEUP_ATTACK, tp) then
        local token = Duel.CreateToken(1 - tp, 71645243)
        Duel.SpecialSummonStep(token, SUMMONED_BY_BLACK_GARDEN, 1 - tp, tp, false, false, POS_FACEUP_ATTACK)
    end
    Duel.SpecialSummonComplete()
end
function c71645242.spfilter(c, atk, e, tp)
    return c:IsAttack(atk) and c:IsCanBeSpecialSummoned(e, SUMMONED_BY_BLACK_GARDEN, tp, false, false)
end
function c71645242.dessptg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71645242.spfilter(chkc, e:GetLabel(), e, tp)
    end
    local g = Duel.GetMatchingGroup(c71645242.FaceupFilter(Card.IsRace, RACE_PLANT), tp, LOCATION_MZONE, LOCATION_MZONE, nil)
    local atk = g:GetSum(Card.GetAttack)
    if chk == 0 then
        return #g > 0 and Duel.GetMZoneCount(tp, g) > 0 and
                   Duel.IsExistingTarget(c71645242.spfilter, tp, LOCATION_GRAVE, 0, 1, nil, atk, e, tp)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local tg = Duel.SelectTarget(tp, c71645242.spfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil, atk, e, tp)
    e:SetLabel(atk)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, tg, 1, 0, 0)
    g:AddCard(e:GetHandler())
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, #g, 0, 0)
end
function c71645242.desspop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then
        return
    end
    local dg = Duel.GetMatchingGroup(c71645242.FaceupFilter(Card.IsRace, RACE_PLANT), tp, LOCATION_MZONE, LOCATION_MZONE, nil)
    dg:AddCard(c)
    Duel.Destroy(dg, REASON_EFFECT)
    local og = Duel.GetOperatedGroup()
    if #dg ~= #og then
        return
    end
    local ct = 0
    local oc = og:GetFirst()
    while oc do
        if dg:IsContains(oc) then
            ct = ct + 1
        end
        oc = og:GetNext()
    end
    if ct ~= #og then
        return
    end
    Duel.BreakEffect()
    og:RemoveCard(c)
    local atk = og:GetSum(Card.GetPreviousAttackOnField)
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
		local tatk = tc:GetAttack()
		if atk ~= tatk then return end
        Duel.SpecialSummon(tc, SUMMONED_BY_BLACK_GARDEN, tp, tp, false, false, POS_FACEUP)
    end
end
