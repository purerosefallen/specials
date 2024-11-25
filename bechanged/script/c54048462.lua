--魔轟神ヴァルキュルス
---@param c Card
function c54048462.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x35),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54048462,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c54048462.cost)
	e1:SetTarget(c54048462.tg)
	e1:SetOperation(c54048462.op)
	c:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c54048462.atkcon)
	e2:SetCost(c54048462.atkcost)
	e2:SetOperation(c54048462.atkop)
	c:RegisterEffect(e2)
end
function c54048462.costfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsDiscardable()
end
function c54048462.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c54048462.costfilter,tp,LOCATION_HAND,0,1,nil) end
	local ct=1
	if Duel.IsPlayerCanDraw(tp,2) then ct=2 end
	local disct=Duel.DiscardHand(tp,c54048462.costfilter,1,ct,REASON_DISCARD+REASON_COST)
	e:SetLabel(disct)
end
function c54048462.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c54048462.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c54048462.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetControler()~=tp
end
function c54048462.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_DISCARD+REASON_COST)
end
function c54048462.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end