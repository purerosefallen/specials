--剑圣之影灵衣-神数剑士
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e3=aux.AddRitualProcEqual2(c,s.sfilter,nil,nil,s.smfilter,true)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(0)
	e3:SetCountLimit(1,id)
	e3:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e3)
end
function s.sfilter(c)
	return c:IsSetCard(0xb4)
end
function s.smfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end

function s.filter(c,e,tp)
    return c:IsReleasableByEffect(e) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,c,e,tp,c:GetLevel(),c)
    and (c==e:GetHandler() or not c:IsLocation(LOCATION_PZONE))
end
function s.spfilter(c,e,tp,lv,ec)
    return c:IsSetCard(0xb4) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) and 
    (Duel.GetLocationCountFromEx(tp,tp,ec,c)>0 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 )
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE,0,1,nil,e,tp) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	    local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil,e,tp)
        local tc=sg:GetFirst()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,tc,e,tp,tc:GetLevel()):GetFirst()
		if sc then
            sc:SetMaterial(sg)
            Duel.ReleaseRitualMaterial(sg)
            Duel.BreakEffect()
            Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
            sc:CompleteProcedure()
        end
end