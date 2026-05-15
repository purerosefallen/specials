--玄翼竜 ブラック・フェザー
function c60992105.initial_effect(c)
	aux.AddCodeList(c,9012916)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60992105,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1)
	e1:SetCondition(c60992105.condition)
	e1:SetTarget(c60992105.target)
	e1:SetOperation(c60992105.operation)
	c:RegisterEffect(e1)
end
function c60992105.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c60992105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c60992105.filter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function c60992105.filter(c)
	return aux.IsCodeListed(c,9012916) and c:IsAbleToHand()
end
function c60992105.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>5 then ct=5 end
	local t={}
	for i=1,ct do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60992105,1))
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.DiscardDeck(tp,ac,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:GetCount()>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c60992105.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(60992105,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60992105.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end