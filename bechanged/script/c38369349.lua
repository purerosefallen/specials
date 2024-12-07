--トゥーン・ドラゴン・エッガー
function c38369349.initial_effect(c)
	aux.AddCodeList(c,15259703)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,c38369349.uqfilter,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(38369349,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c38369349.spcon)
	e1:SetTarget(c38369349.sptg)
	e1:SetOperation(c38369349.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(38369349,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP,1)
	e2:SetCondition(c38369349.spcon2)
	e2:SetTarget(c38369349.sptg2)
	e2:SetOperation(c38369349.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(38369349,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,38369349)
	e3:SetCondition(c38369349.spcon3)
	e3:SetCost(c38369349.spcost3)
	e3:SetTarget(c38369349.sptg3)
	e3:SetOperation(c38369349.spop3)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c38369349.dircon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetCondition(c38369349.atcon)
	e5:SetValue(c38369349.atlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e6:SetCondition(c38369349.atcon)
	c:RegisterEffect(e6)
end
function c38369349.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c38369349.uqfilter(c)
	if Duel.IsExistingMatchingCard(c38369349.cfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		return false
	else
		return c:IsType(TYPE_TOON)
	end
end
function c38369349.sprfilter(c,tp,sp)
	return Duel.GetMZoneCount(tp,c,sp)>0
end
function c38369349.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c38369349.sprfilter,tp,LOCATION_MZONE,0,1,nil,tp,tp)
end
function c38369349.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c38369349.sprfilter,tp,LOCATION_MZONE,0,nil,tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c38369349.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function c38369349.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c38369349.sprfilter,tp,0,LOCATION_MZONE,1,nil,1-tp,tp)
end
function c38369349.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c38369349.sprfilter,tp,0,LOCATION_MZONE,nil,1-tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c38369349.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c38369349.dircon(e)
	return not Duel.IsExistingMatchingCard(c38369349.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c38369349.atcon(e)
	return Duel.IsExistingMatchingCard(c38369349.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c38369349.atlimit(e,c)
	return not c:IsType(TYPE_TOON) or c:IsFacedown()
end
function c38369349.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c38369349.atcost(e,c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c38369349.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
function c38369349.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c38369349.cfilter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c38369349.spcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c38369349.spfilter3(c,e,tp,mc)
	return c:IsRace(RACE_DRAGON) and not c:IsType(TYPE_EFFECT)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and (Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsLocation(LOCATION_EXTRA)
		or Duel.GetMZoneCount(tp,mc,tp)>0 and c:IsLocation(LOCATION_DECK))
end
function c38369349.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c38369349.spfilter3,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c38369349.spop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c38369349.spfilter3,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp,nil)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end