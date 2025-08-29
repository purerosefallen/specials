-- 天空の宝札
---@param c Card
function c54977057.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW + CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c54977057.cost)
    e1:SetTarget(c54977057.target)
    e1:SetOperation(c54977057.activate)
    c:RegisterEffect(e1)
    if not c54977057.global_check then
        c54977057.global_check = true
        c54977057[0] = false
        c54977057[1] = false
        local ge1 = Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SPSUMMON_NEGATED)
        ge1:SetOperation(c54977057.checkop1)
        Duel.RegisterEffect(ge1, 0)
        local ge2 = Effect.CreateEffect(c)
        ge2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge2:SetCode(EVENT_CHAINING)
        ge2:SetOperation(c54977057.checkop2)
        Duel.RegisterEffect(ge2, 0)
        local ge3 = Effect.CreateEffect(c)
        ge3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge3:SetCode(EVENT_CHAIN_NEGATED)
        ge3:SetOperation(c54977057.checkop3)
        Duel.RegisterEffect(ge3, 0)
        local ge4 = Effect.CreateEffect(c)
        ge4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge4:SetCode(EVENT_TURN_END)
        ge4:SetOperation(c54977057.clear)
        Duel.RegisterEffect(ge4, 0)
    end
end
function c54977057.checkop1(e, tp, eg, ep, ev, re, r, rp)
    local tc = eg:GetFirst()
    local turnp = Duel.GetTurnPlayer()
    c54977057[turnp] = tc:IsControler(turnp)
end
function c54977057.checkop2(e, tp, eg, ep, ev, re, r, rp)
    local turnp = Duel.GetTurnPlayer()
    local ex = Duel.GetOperationInfo(ev, CATEGORY_SPECIAL_SUMMON)
    if ex and rp == turnp then
        c54977057[turnp] = true
    end
end
function c54977057.checkop3(e, tp, eg, ep, ev, re, r, rp)
    local turnp = Duel.GetTurnPlayer()
    local ex = Duel.GetOperationInfo(ev, CATEGORY_SPECIAL_SUMMON)
    if ex and rp == turnp then
        c54977057[turnp] = false
    end
end
function c54977057.clear(e, tp, eg, ep, ev, re, r, rp)
    c54977057[0] = false
    c54977057[1] = false
end
function c54977057.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	local turnp=Duel.GetTurnPlayer()
    if chk == 0 then
        return Duel.GetActivityCount(tp, ACTIVITY_SPSUMMON) == 0 and Duel.GetActivityCount(tp, ACTIVITY_BATTLE_PHASE) ==
                   0 and not c54977057[turnp]
    end
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE + PHASE_END)
    e1:SetTargetRange(1, 0)
    Duel.RegisterEffect(e1, tp)
    local e2 = e1:Clone()
    e2:SetCode(EFFECT_CANNOT_BP)
    Duel.RegisterEffect(e2, tp)
end
function c54977057.filter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY) and c:IsAbleToRemove()
end
function c54977057.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsPlayerCanDraw(tp, 2) and
                   Duel.IsExistingMatchingCard(c54977057.filter, tp, LOCATION_HAND, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, tp, LOCATION_HAND)
end
function c54977057.activate(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, c54977057.filter, tp, LOCATION_HAND, 0, 1, 1, nil)
    Duel.Remove(g, POS_FACEUP, REASON_EFFECT)
    Duel.Draw(tp, 2, REASON_EFFECT)
end
