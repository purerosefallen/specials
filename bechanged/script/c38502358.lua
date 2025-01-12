--星痕之机界骑士
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,3,s.lcheck)
	c:EnableReviveLimit()
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(s.dircon)
	c:RegisterEffect(e1)
	--cannot be target/effect indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--cannot be battle target
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e8:SetValue(s.antarget)
	c:RegisterEffect(e8)

	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(s.immcon)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
	e5:SetCost(s.spcost)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)

end
function s.lfilter(c)
	return c:IsLinkType(TYPE_MONSTER) and c:IsLinkSetCard(0x10c)
end
function s.lcheck(g)
	return g:IsExists(s.lfilter,1,nil)
end
function s.dircon(e)
	return e:GetHandler():GetColumnGroupCount()==0
end
function s.antarget(e,c)
	local seq=e:GetHandler():GetSequence()
	local chk=0
	if seq==5 then
		chk=3
	elseif seq==6 then
		chk=1
	else
		chk=4-seq
	end
	return c:GetSequence()~=chk
end
function s.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	local seq=e:GetHandler():GetSequence()
	local chk=0
	if seq==5 then
		chk=3
	elseif seq==6 then
		chk=1
	else
		chk=4-seq
	end
	return te:GetHandler():GetSequence()~=chk
end
function s.spcfilter(c,g,tp)
	return g:IsContains(c) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x10c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,cg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.spcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,cg,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
