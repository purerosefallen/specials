--希望皇オノマトピア
---@param c Card
function c8512558.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69852487,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,8512558)
	e1:SetCost(c8512558.spcost)
	e1:SetTarget(c8512558.sptg)
	e1:SetOperation(c8512558.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8512558,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,8512559)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c8512558.sptg)
	e2:SetOperation(c8512558.spop)
	c:RegisterEffect(e2)
	--Gains Effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c8512558.efcon)
	e3:SetOperation(c8512558.efop)
	c:RegisterEffect(e3)
end
c8512558.combination2={}
c8512558.combination2[1]=aux.CreateChecks(Card.IsSetCard,{0x54,0x59})
c8512558.combination2[2]=aux.CreateChecks(Card.IsSetCard,{0x54,0x82})
c8512558.combination2[3]=aux.CreateChecks(Card.IsSetCard,{0x54,0x8f})
c8512558.combination2[4]=aux.CreateChecks(Card.IsSetCard,{0x59,0x82})
c8512558.combination2[5]=aux.CreateChecks(Card.IsSetCard,{0x59,0x8f})
c8512558.combination2[6]=aux.CreateChecks(Card.IsSetCard,{0x82,0x8f})
c8512558.combination3={}
c8512558.combination3[1]=aux.CreateChecks(Card.IsSetCard,{0x59,0x82,0x8f})
c8512558.combination3[2]=aux.CreateChecks(Card.IsSetCard,{0x54,0x82,0x8f})
c8512558.combination3[3]=aux.CreateChecks(Card.IsSetCard,{0x54,0x59,0x8f})
c8512558.combination3[4]=aux.CreateChecks(Card.IsSetCard,{0x54,0x59,0x82})
c8512558.combination4=aux.CreateChecks(Card.IsSetCard,{0x54,0x59,0x82,0x8f})
function c8512558.cfilter(c)
	return c:IsType(TYPE_XYZ)
		and (c:IsLocation(LOCATION_EXTRA) and not c:IsPublic() or c:IsFaceup())
end
function c8512558.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8512558.cfilter,tp,LOCATION_EXTRA+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c8512558.cfilter,tp,LOCATION_EXTRA+LOCATION_MZONE,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	if g:GetFirst():IsLocation(LOCATION_EXTRA) then
		e:SetLabel(100)
	else
		e:SetLabel(0)
	end
end
function c8512558.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c8512558.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:GetLabel()==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c8512558.limit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c8512558.limit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end
function c8512558.spfilter2(c,e,tp)
	return c:IsSetCard(0x54,0x59,0x82,0x8f) and not c:IsCode(8512558) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8512558.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c8512558.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c8512558.gcheck(g)
	if #g==1 then
		return true
	elseif #g==2 then
		return g:CheckSubGroupEach(c8512558.combination2[1])
			or g:CheckSubGroupEach(c8512558.combination2[2])
			or g:CheckSubGroupEach(c8512558.combination2[3])
			or g:CheckSubGroupEach(c8512558.combination2[4])
			or g:CheckSubGroupEach(c8512558.combination2[5])
			or g:CheckSubGroupEach(c8512558.combination2[6])
	elseif #g==3 then
		return g:CheckSubGroupEach(c8512558.combination3[1])
			or g:CheckSubGroupEach(c8512558.combination3[2])
			or g:CheckSubGroupEach(c8512558.combination3[3])
			or g:CheckSubGroupEach(c8512558.combination3[4])
	elseif #g==4 then
		return g:CheckSubGroupEach(c8512558.combination4)
	end
end
function c8512558.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c8512558.spfilter2,tp,LOCATION_HAND,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 and #g>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c8512558.gcheck,false,1,math.min(4,ft))
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c8512558.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c8512558.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function c8512558.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ and c:GetReasonCard():IsSetCard(0x107f)
end
function c8512558.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(8512558,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c8512558.thtg)
	e1:SetOperation(c8512558.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c8512558.tcfilter(c)
	return (c:IsLocation(LOCATION_DECK) or c:IsAbleToDeck())
end
function c8512558.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8512558.tcfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c8512558.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(8512558,3))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c8512558.tcfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		if tc:IsLocation(LOCATION_DECK) then
			Duel.MoveSequence(tc,SEQ_DECKTOP)
		else
			Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
		Duel.ConfirmDecktop(tp,1)
		if tc:IsCode(26493435,67378935) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end