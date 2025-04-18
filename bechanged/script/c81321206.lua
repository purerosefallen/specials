--北极天熊-小灰熊
function c81321206.initial_effect(c)
	--special summon
	local e1=aux.AddUrsarcticSpSummonEffect(c)
	e1:SetDescription(aux.Stringid(81321206,0))
	e1:SetCountLimit(1,81321206)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(81321206,8))
	e9:SetCountLimit(1,81321206)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_HAND)
	e9:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e9:SetCondition(c81321206.spcon)
	e9:SetTarget(c81321206.sptg)
	e9:SetOperation(c81321206.spop)
	c:RegisterEffect(e9)
	--search or spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81321206,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81321207)
	e2:SetTarget(c81321206.thtg)
	e2:SetOperation(c81321206.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
--
function c81321206.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	return ct==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) end
function c81321206.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81321206.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81321206.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81321206.splimit(e,c)
	return c:IsLevel(0)
end

--
function c81321206.thfilter(c,e,tp)
	if not (c:IsSetCard(0x163) and c:IsType(TYPE_MONSTER) and not c:IsCode(81321206)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c81321206.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81321206.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c81321206.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c81321206.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
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
end

