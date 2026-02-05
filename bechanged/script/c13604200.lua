--賢者の宝石
function c13604200.initial_effect(c)
	aux.AddCodeList(c,46986414,38033121)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13604200.target)
	e1:SetOperation(c13604200.activate)
	c:RegisterEffect(e1)
end
function c13604200.spfilter1(c,e,tp)
	return c:IsCode(46986414) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13604200.spfilter2(c)
	return c:IsFaceup() and c:IsCode(38033121)
end
function c13604200.tggrave(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x10a2)
end
function c13604200.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c13604200.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c13604200.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(c13604200.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c13604200.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
	if Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)>=~0
	and Duel.IsExistingMatchingCard(c13604200.spfilter2,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsExistingMatchingCard(c13604200.tggrave,tp,LOCATION_DECK,0,1,nil)
	and Duel.SelectYesNo(tp,aux.Stringid(13604200,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13604200.tggrave,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoGrave(g,REASON_EFFECT)
	end
	end
	end
end
