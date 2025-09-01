--黒羽の宝札
---@param c Card
function c4168871.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4168871+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c4168871.cost)
	e1:SetTarget(c4168871.target)
	e1:SetOperation(c4168871.activate)
	c:RegisterEffect(e1)
	if not c4168871.global_check then
        c4168871.global_check = true
        c4168871[0] = false
        c4168871[1] = false
        local ge1 = Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SPSUMMON_NEGATED)
        ge1:SetOperation(c4168871.checkop1)
        Duel.RegisterEffect(ge1, 0)
        local ge2 = Effect.CreateEffect(c)
        ge2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge2:SetCode(EVENT_CHAINING)
        ge2:SetOperation(c4168871.checkop2)
        Duel.RegisterEffect(ge2, 0)
        local ge3 = Effect.CreateEffect(c)
        ge3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge3:SetCode(EVENT_CHAIN_NEGATED)
        ge3:SetOperation(c4168871.checkop3)
        Duel.RegisterEffect(ge3, 0)
        local ge4 = Effect.CreateEffect(c)
        ge4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge4:SetCode(EVENT_TURN_END)
        ge4:SetOperation(c4168871.clear)
        Duel.RegisterEffect(ge4, 0)
    end
end
function c4168871.checkop1(e, tp, eg, ep, ev, re, r, rp)
    local tc = eg:GetFirst()
    local turnp = Duel.GetTurnPlayer()
    c4168871[turnp] = tc:IsControler(turnp)
end
function c4168871.checkop2(e, tp, eg, ep, ev, re, r, rp)
    local turnp = Duel.GetTurnPlayer()
    local ex = Duel.GetOperationInfo(ev, CATEGORY_SPECIAL_SUMMON)
    if ex and rp == turnp then
        c4168871[turnp] = true
    end
end
function c4168871.checkop3(e, tp, eg, ep, ev, re, r, rp)
    local turnp = Duel.GetTurnPlayer()
    local ex = Duel.GetOperationInfo(ev, CATEGORY_SPECIAL_SUMMON)
    if ex and rp == turnp then
        c4168871[turnp] = false
    end
end
function c4168871.clear(e, tp, eg, ep, ev, re, r, rp)
    c4168871[0] = false
    c4168871[1] = false
end
function c4168871.filter(c)
	return c:IsSetCard(0x33) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c4168871.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local turnp=Duel.GetTurnPlayer()
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(c4168871.filter,tp,LOCATION_HAND,0,1,nil) and not c4168871[turnp] end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c4168871.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c4168871.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c4168871.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
