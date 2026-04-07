--伝説の白石
---@param c Card
function c79814787.initial_effect(c)
	aux.AddCodeList(c,89631139)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79814787,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c79814787.target)
	e1:SetOperation(c79814787.operation)
	c:RegisterEffect(e1)
end
function c79814787.filter(c)
	return c:IsCode(89631139) and c:IsAbleToHand()
end
function c79814787.filter2(c)
	return c:GetOriginalCode()==89631139 and c:IsFaceup()
end
function c79814787.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79814787.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.GetFirstMatchingCard(c79814787.filter,tp,LOCATION_DECK,0,nil)
	if tc~=nil then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		if not Duel.IsPlayerAffectedByEffect(tp, EFFECT_CANNOT_TO_HAND) then
			local pc=Duel.GetMatchingGroup(c79814787.filter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_OVERLAY+LOCATION_HAND,0,nil)
			if pc:GetCount()<3 then 
				Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_DECK,0))
				Duel.ShuffleDeck(tp)
			end
		end
	end
end
