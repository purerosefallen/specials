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
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(94046012,1))
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,94046013)
	e3:SetTarget(c94046012.tgtg)
	e3:SetOperation(c94046012.tgop)
	c:RegisterEffect(e3)
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
function c94046012.tgfilter(c)
	return c:IsSetCard(0x11b,0xfe) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c94046012.sfilter(c,e,tp,mc,g)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WATER)
		and c:IsRace(RACE_SPELLCASTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and (not g or c:GetLevel()-mc:GetLevel()>0 and g:CheckWithSumEqual(Card.GetLevel,c:GetLevel()-mc:GetLevel(),1,1))
end
function c94046012.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local clv=c:GetLevel()
	local g=Duel.GetMatchingGroup(c94046012.tgfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return clv>0
		and Duel.IsExistingMatchingCard(c94046012.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,g) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c94046012.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local clv=c:GetLevel()
	if c:IsRelateToEffect(e) and clv>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c94046012.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
		if sg:GetCount()>0 then
			local lv=sg:GetFirst():GetLevel()-clv
			local g=Duel.GetMatchingGroup(c94046012.tgfilter,tp,LOCATION_HAND,0,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=g:SelectWithSumEqual(tp,Card.GetLevel,lv,1,1)
			if #tg>0 then
				tg:AddCard(c)
				if Duel.SendtoGrave(tg,REASON_EFFECT)>1 and tg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end