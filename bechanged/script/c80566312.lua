--祝祷的圣歌
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,56350972)
	--summon and release
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp)
	return c:IsCode(56350972) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP) and c:IsType(TYPE_RITUAL)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsPlayerCanRelease(tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.release(c,e)
    return c:IsFaceupEx() and c:IsReleasableByEffect(e) and c:IsLevelAbove(1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
        g:GetFirst():CompleteProcedure()
		Duel.BreakEffect()
        local sg=Duel.GetMatchingGroup(s.release,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local cg=sg:SelectWithSumGreater(tp,Card.GetLevel,6,1,6)
		if cg:GetCount()>0 then
			Duel.HintSelection(cg)
			Duel.Release(cg,REASON_EFFECT)
		end
	end
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_RITUAL)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

