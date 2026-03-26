--オルフェゴール・カノーネ
function c94046012.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(94046012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,94046012)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(c94046012.spcon1)
	e1:SetTarget(c94046012.sptg)
	e1:SetOperation(c94046012.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c94046012.spcon2)
	c:RegisterEffect(e2)
	--hand link
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e3:SetRange(LOCATION_HAND)
	e3:SetValue(c94046012.matval)
	c:RegisterEffect(e3)
	--hand synchro
	local e4=e3:Clone()
	e4:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e4:SetValue(c94046012.matval2)
	c:RegisterEffect(e4)
	--synchro effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(94046012,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,94046012)
	e5:SetCondition(c94046012.sccon)
	e5:SetTarget(c94046012.sctarg)
	e5:SetOperation(c94046012.scop)
	c:RegisterEffect(e5)
end
function c94046012.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() or Duel.IsBattlePhase()
end
function c94046012.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c) 
		or Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c94046012.scfilter(c,mc)
	return c:IsSynchroSummonable(mc) or c:IsLinkSummonable(nil,mc)
end
function c94046012.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c94046012.scfilter,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc:IsType(TYPE_SYNCHRO) then	
			Duel.SynchroSummon(tp,tc,c)
		else
			Duel.LinkSummon(tp,tc,nil,c)
		end
	end
end
function c94046012.matval(e,lc,mg,c,tp)
	if not lc:IsRace(RACE_SPELLCASTER+RACE_WARRIOR+RACE_PSYCHO) or
		not lc:IsAttribute(0x7) then return false,nil end
	return true,true
end
function c94046012.matval2(e,c)
	return c:IsRace(RACE_SPELLCASTER+RACE_WARRIOR+RACE_PSYCHO) and c:IsAttribute(0x7)
end
function c94046012.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not aux.IsCanBeQuickEffect(e:GetHandler(),tp,90351981)
end
function c94046012.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsCanBeQuickEffect(e:GetHandler(),tp,90351981)
end
function c94046012.spfilter(c,e,tp)
	return c:IsSetCard(0x11b,0xfe) and not c:IsCode(94046012) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c94046012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c94046012.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c94046012.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c94046012.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c94046012.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c94046012.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
