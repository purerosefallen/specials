--北极天熊-小黑熊
function c55936191.initial_effect(c)
	--special summon
	local e1=aux.AddUrsarcticSpSummonEffect(c)
	e1:SetDescription(aux.Stringid(55936191,0))
	e1:SetCountLimit(1,55936191)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(55936191,8))
	e9:SetCountLimit(1,55936191)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_HAND)
	e9:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e9:SetCondition(c55936191.spcon)
	e9:SetTarget(c55936191.sptg)
	e9:SetOperation(c55936191.spop)
	c:RegisterEffect(e9)
	--tohand or spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55936191,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,55936192)
	e2:SetTarget(c55936191.thtg)
	e2:SetOperation(c55936191.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
--
function c55936191.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	return ct==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) end
function c55936191.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c55936191.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c55936191.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c55936191.splimit(e,c)
	return c:IsLevel(0)
end

--
function c55936191.thfilter(c,e,tp,ft)
	return c:IsFaceupEx() and c:IsSetCard(0x163) and not c:IsCode(55936191) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP))
end
function c55936191.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c55936191.thfilter(chkc,e,tp,ft) end
	if chk==0 then return Duel.IsExistingTarget(c55936191.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c55936191.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,ft):GetFirst()
	if tc:IsLocation(LOCATION_GRAVE) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	end
end
function c55936191.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if aux.NecroValleyNegateCheck(tc) then return end
		if not aux.NecroValleyFilter()(tc) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end