--聖邪のステンドグラス
---@param c Card
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.hdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.hdfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY+RACE_FIEND)
end
function s.filter(c,race)
	return c:IsRace(race) and c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(0)
	local f1=Duel.IsExistingMatchingCard(s.filter,tp,0x14,0x14,1,nil,RACE_FAIRY) and Duel.IsPlayerCanDraw(tp,3)
	local f2=Duel.IsExistingMatchingCard(s.filter,tp,0x14,0x14,1,nil,RACE_FIEND) and Duel.IsPlayerCanDraw(1-tp,1)
	if chk==0 then return f1 or f2 end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		e:SetLabel(100)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local f1=Duel.IsExistingMatchingCard(s.filter,tp,0x14,0x14,1,nil,RACE_FAIRY) and Duel.IsPlayerCanDraw(tp,3)
	local f2=Duel.IsExistingMatchingCard(s.filter,tp,0x14,0x14,1,nil,RACE_FIEND) and Duel.IsPlayerCanDraw(1-tp,1)
	local res=false
		if e:GetLabel()==100 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,4))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.aclimit)
		Duel.RegisterEffect(e1,tp)
	end
	if f1 and (not f2 or Duel.SelectYesNo(tp,aux.Stringid(id,1))) and Duel.Draw(tp,3,REASON_EFFECT)==3 then
		res=true
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if g:GetCount()<2 then return end
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,2,2,nil)
		aux.PlaceCardsOnDeckBottom(tp,sg)
	end
	if f2 and (not res or Duel.SelectYesNo(tp,aux.Stringid(id,2))) and Duel.Draw(1-tp,1,REASON_EFFECT)==1 then
		Duel.ShuffleHand(1-tp)
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if #g==0 then return end
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
		local g1=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if #g1==0 then return end
		Duel.BreakEffect()
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_FAIRY+RACE_FIEND)
end
