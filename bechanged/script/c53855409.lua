--ドッペル・ウォリアー
function c53855409.initial_effect(c)
	--hand synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(c53855409.matval)
	c:RegisterEffect(e1)
	--register HOpT
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_PRE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetLabelObject(e1)
	e0:SetCondition(c53855409.hsyncon)
	e0:SetOperation(c53855409.hsynreg)
	c:RegisterEffect(e0)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53855409,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c53855409.spcon)
	e2:SetTarget(c53855409.sptg)
	e2:SetOperation(c53855409.spop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53855409,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c53855409.tcon)
	e3:SetTarget(c53855409.ttg)
	e3:SetOperation(c53855409.top)
	c:RegisterEffect(e3)
end
function c53855409.matval(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WARRIOR+RACE_MACHINE)
end
function c53855409.hsyncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c53855409.matval(nil,c:GetReasonCard()) and c:IsPreviousLocation(LOCATION_HAND)
end
function c53855409.hsynreg(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():UseCountLimit(tp)
end
function c53855409.gfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp)
end
function c53855409.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c53855409.gfilter,1,nil,tp)
end
function c53855409.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c53855409.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c53855409.tcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c53855409.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,53855410,0,TYPES_TOKEN_MONSTER,400,400,1,RACE_WARRIOR,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c53855409.top(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,53855410,0,TYPES_TOKEN_MONSTER,400,400,1,RACE_WARRIOR,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,53855409+i)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
	Duel.SpecialSummonComplete()
end
