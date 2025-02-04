--白き霊龍
function c45467446.initial_effect(c)
	aux.AddCodeList(c,89631139)
	--Normal monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,45467446+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c45467446.spcon2)
	e1:SetTarget(c45467446.sptg2)
	e1:SetOperation(c45467446.spop2)
	c:RegisterEffect(e1)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c45467446.rmtg)
	e3:SetOperation(c45467446.rmop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_SPSUMMON+CATEGORY_GRAVE_ACTION)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c45467446.thcost)
	e5:SetTarget(c45467446.thtg)
	e5:SetOperation(c45467446.thop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_ADD_TYPE)
	e6:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e6:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_REMOVE_TYPE)
	e7:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e7)
end
function c45467446.spfilter2(c)
	return c:IsFaceupEx() and (c:IsCode(89631139) or c:IsLevel(1) and c:IsRace(RACE_SPELLCASTER)) and c:IsAbleToGraveAsCost()
end
function c45467446.fselect2(g,tp)
	return aux.mzctcheck(g,tp)
end
function c45467446.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c45467446.spfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	return g:CheckSubGroup(c45467446.fselect2,1,1,tp)
end
function c45467446.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c45467446.spfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c45467446.fselect2,true,1,1,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c45467446.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c45467446.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp)
end
function c45467446.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c45467446.cfilter,1,nil,tp)
end
function c45467446.tgfilter(c,tp)
	return c:IsFaceupEx() and c:IsCode(89631139) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0
end
function c45467446.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c45467446.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c45467446.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c45467446.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
	local c=e:GetHandler()
	local tc=tg:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c45467446.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c45467446.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c45467446.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c45467446.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c45467446.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c45467446.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c45467446.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c45467446.filter(c,e,tp)
	if not (c:IsType(TYPE_MONSTER) and c:IsSetCard(0xdd)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c45467446.sspfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsCode(89631139) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c45467446.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,0,1,nil,89631139)
		and Duel.IsExistingMatchingCard(c45467446.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		or not Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,0,1,nil,89631139)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c45467446.sspfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c45467446.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,0,1,nil,89631139) then
		if not Duel.IsExistingMatchingCard(c45467446.filter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c45467446.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local tc=g:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c45467446.sspfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end