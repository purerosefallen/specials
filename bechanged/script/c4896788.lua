--強欲な壺の精霊
---@param c Card
function c4896788.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4896788,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,4896788)
	e1:SetCondition(c4896788.drcon1)
	e1:SetTarget(c4896788.drtg1)
	e1:SetOperation(c4896788.drop1)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4896788,2))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c4896788.drcon)
	e2:SetOperation(c4896788.drop)
	c:RegisterEffect(e2)
	--negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4896788,3))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetTarget(c4896788.tg)
	e3:SetOperation(c4896788.op)
	c:RegisterEffect(e3)
	--spsummon
	local e33=Effect.CreateEffect(c)
	e33:SetDescription(aux.Stringid(4896788,3))
	e33:SetCategory(CATEGORY_CONTROL)
	e33:SetType(EFFECT_TYPE_QUICK_F)
	e33:SetRange(LOCATION_MZONE)
	e33:SetCode(EVENT_BECOME_TARGET)
	e33:SetCondition(c4896788.con)
	e33:SetTarget(c4896788.tg)
	e33:SetOperation(c4896788.op)
	c:RegisterEffect(e33)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c4896788.efilter)
	c:RegisterEffect(e4)
end
function c4896788.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function c4896788.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c4896788.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,c) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c4896788.drop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,aux.ExceptThisCard(e)) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c4896788.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(55144522)
end
function c4896788.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDraw(rp,1) and Duel.SelectYesNo(rp,aux.Stringid(4896788,0)) then
		Duel.Draw(rp,1,REASON_EFFECT)
	end
end
function c4896788.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c4896788.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c4896788.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.GetControl(c,1-tp)
	end
end