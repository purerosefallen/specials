--黒き魔術師－ブラック・マジシャン
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,79791878)
	aux.EnableChangeCode(c,46986414,LOCATION_MZONE+LOCATION_GRAVE)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end
function s.filter1(c,tp)
	return c:IsCode(79791878) and c:IsFaceup() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter3),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
end
function s.filter2(c,tp)
	return aux.IsCodeListed(c,46986414) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_DECK,0,1,nil)
end
function s.filter3(c)
	return aux.IsCodeListed(c,79791878) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end
function s.filter4(c)
	return aux.IsCodeListed(c,46986414) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local b1=Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_ONFIELD,0,1,nil,tp)
		local b2=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_ONFIELD,0,1,nil,tp)
		if b1 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.BreakEffect()
			local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter3),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if g1:GetCount()>0 then
				Duel.SendtoHand(g1,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g1)
			end
		end
		if b2 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.BreakEffect()
			local g2=Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_DECK,0,1,1,nil)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	end
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.setfilter(c)
	return aux.IsCodeListed(c,46986414) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
		end
	end
end
