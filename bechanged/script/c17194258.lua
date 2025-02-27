--融合徴兵
---@param c Card
function c17194258.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17194258+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17194258.target)
	e1:SetOperation(c17194258.activate)
	c:RegisterEffect(e1)
end
function c17194258.filter1(c,tp)
	return c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(c17194258.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c17194258.filter2(c,fc)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsAbleToHand()
end
function c17194258.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17194258.filter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c17194258.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c17194258.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c17194258.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,cg:GetFirst())
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
	end
end