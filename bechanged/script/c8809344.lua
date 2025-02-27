--外神ナイアルラ
function c8809344.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c8809344.ovfilter,aux.Stringid(8809344,2),2,c8809344.xyzop)
	c:EnableReviveLimit()
	--rankup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c8809344.rkcon)
	e1:SetCost(c8809344.rkcost)
	e1:SetOperation(c8809344.rkop)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c8809344.cost)
	e2:SetTarget(c8809344.target)
	e2:SetOperation(c8809344.operation)
	c:RegisterEffect(e2)
end
function c8809344.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO)
end
function c8809344.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,8809344)==0 end
	Duel.RegisterFlagEffect(tp,8809344,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c8809344.rkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c8809344.rkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(8809344,0)},{b2,aux.Stringid(8809344,1)})
	if op==1 then
		local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,60,REASON_COST+REASON_DISCARD)
		e:SetLabel(ct)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,60,nil)
		local ct=Duel.Remove(g,POS_FACEUP,REASON_COST)
		e:SetLabel(ct)
	end
end
function c8809344.rkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_RANK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e2:SetValue(e:GetLabel())
		c:RegisterEffect(e2)
	end
end
function c8809344.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c8809344.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c8809344.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local xg=c:GetOverlayGroup()
	local loc=LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED
	if xg:IsExists(Card.IsSetCard,1,nil,0xb7,0xb8) then loc=loc+LOCATION_DECK+LOCATION_EXTRA end
	if chk==0 then return Duel.IsExistingMatchingCard(c8809344.matfilter,tp,loc,0,1,nil) end
end
function c8809344.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local xg=c:GetOverlayGroup()
	local loc=LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED
	if xg:IsExists(Card.IsSetCard,1,nil,0xb7,0xb8) then loc=loc+LOCATION_DECK+LOCATION_EXTRA end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,c8809344.matfilter,tp,loc,0,1,1,nil):GetFirst()
	if tc then
		Duel.Overlay(c,Group.FromCards(tc))
		if c:IsFacedown() then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(tc:GetOriginalAttribute())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(tc:GetOriginalRace())
		c:RegisterEffect(e2)
	end
end