--イリュージョン・マジック
---@param c Card
function c73616671.initial_effect(c)
	aux.AddCodeList(c,46986414)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,73616671+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c73616671.cost)
	e1:SetTarget(c73616671.target)
	e1:SetOperation(c73616671.activate)
	c:RegisterEffect(e1)
end
function c73616671.cosfilter(c)
	return (c:IsRace(RACE_SPELLCASTER) or (aux.IsCodeListed(c,46986414) and c:IsType(TYPE_SPELL+TYPE_TRAP))) and c:IsAbleToGraveAsCost()
end
function c73616671.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73616671.cosfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c73616671.cosfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c73616671.filter(c)
	return (c:IsCode(46986414) or aux.IsCodeListed(c,46986414)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c73616671.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73616671.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c73616671.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c73616671.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c73616671.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			local sg=g:Filter(c73616671.spfilter,nil,e,tp)
			if #sg>=2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
			if sg and g:IsExists(Card.IsCode,1,nil,46986414) and #sg<=Duel.GetLocationCount(tp,LOCATION_MZONE) and Duel.SelectYesNo(tp,aux.Stringid(73616671,0)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end