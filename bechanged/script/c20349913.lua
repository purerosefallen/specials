--銀河の施し
---@param c Card
function c20349913.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,20349913+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c20349913.condition)
	e1:SetTarget(c20349913.target)
	e1:SetOperation(c20349913.activate)
	c:RegisterEffect(e1)
end
function c20349913.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x7b) and c:IsType(TYPE_XYZ) or c:IsCode(93717133))
end
function c20349913.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20349913.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c20349913.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c20349913.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end