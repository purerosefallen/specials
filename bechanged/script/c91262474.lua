--スターダスト・ヴルム
function c91262474.initial_effect(c)
	--hand synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,91262474)
	e1:SetValue(c91262474.matval)
	c:RegisterEffect(e1)
	--register HOpT
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_PRE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetLabelObject(e1)
	e0:SetCondition(c91262474.hsyncon)
	e0:SetOperation(c91262474.hsynreg)
	c:RegisterEffect(e0)
	--spsummon(self)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91262474,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,91262475)
	e2:SetCondition(c91262474.spcon)
	e2:SetTarget(c91262474.sptg)
	e2:SetOperation(c91262474.spop)
	c:RegisterEffect(e2)
	--spsummon(others)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(91262474,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,91262476)
	e3:SetCost(c91262474.spcost)
	e3:SetTarget(c91262474.sptg2)
	e3:SetOperation(c91262474.spop2)
	c:RegisterEffect(e3)
end
function c91262474.matval(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON)
end
function c91262474.hsyncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c91262474.matval(nil,c:GetReasonCard()) and c:IsPreviousLocation(LOCATION_HAND)
end
function c91262474.hsynreg(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():UseCountLimit(tp)
end
function c91262474.spfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(8) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO)
end
function c91262474.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c91262474.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c91262474.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c91262474.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end
function c91262474.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp,c)>0 and c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
function c91262474.spfilter2(c,e,tp)
	return not c:IsCode(91262474) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c91262474.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91262474.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c91262474.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	ft=math.min(ft,2)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c91262474.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ft,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
