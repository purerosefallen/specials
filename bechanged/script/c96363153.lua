--調律
function c96363153.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c96363153.target)
	e1:SetOperation(c96363153.activate)
	c:RegisterEffect(e1)
end
function c96363153.filter(c)
	return c:IsSetCard(0x1017) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c96363153.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c96363153.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c96363153.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c96363153.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleDeck(tp)
		if tc:IsLocation(LOCATION_HAND) then
			local b1=Duel.IsPlayerCanDiscardDeck(tp,1)
			local lv=tc:GetLevel()
			local b2=Duel.IsPlayerCanDiscardDeck(tp,lv)
			local d=aux.SelectFromOptions(tp,{b1,aux.Stringid(96363153,0)},{b2,aux.Stringid(96363153,1)},{aux.TRUE,aux.Stringid(96363153,2)})
			if d==1 then
				Duel.BreakEffect()
				Duel.DiscardDeck(tp,1,REASON_EFFECT)
			elseif d==2 then
				Duel.DiscardDeck(tp,lv,REASON_EFFECT)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetTarget(c96363153.splimit)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c96363153.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end