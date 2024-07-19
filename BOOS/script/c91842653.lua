--トゥーン・デーモン
function c91842653.initial_effect(c)
	aux.AddCodeList(c,15259703)
	c:EnableReviveLimit()
	aux.EnableChangeCode(c,70781052,LOCATION_MZONE+LOCATION_GRAVE)
	c:SetUniqueOnField(1,1,c91842653.uqfilter,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91842653,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c91842653.spcon)
	e1:SetTarget(c91842653.sptg)
	e1:SetOperation(c91842653.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91842653,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP,1)
	e2:SetCondition(c91842653.spcon2)
	e2:SetTarget(c91842653.sptg2)
	e2:SetOperation(c91842653.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c91842653.descon)
	e3:SetTarget(c91842653.destg)
	e3:SetOperation(c91842653.desop)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c91842653.dircon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetCondition(c91842653.atcon)
	e5:SetValue(c91842653.atlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e6:SetCondition(c91842653.atcon)
	c:RegisterEffect(e6)
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetCondition(c91842653.spcon3)
	e8:SetTarget(c91842653.sptg3)
	e8:SetOperation(c91842653.spop3)
	c:RegisterEffect(e8)
end
function c91842653.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c91842653.uqfilter(c)
	if Duel.IsExistingMatchingCard(c91842653.cfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil) then
		return false
	else
		return c:IsType(TYPE_TOON)
	end
end
function c91842653.sprfilter(c,tp,sp)
	return Duel.GetMZoneCount(tp,c,sp)>0
end
function c91842653.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c91842653.sprfilter,tp,LOCATION_MZONE,0,1,nil,tp,tp)
end
function c91842653.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c91842653.sprfilter,tp,LOCATION_MZONE,0,nil,tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c91842653.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function c91842653.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c91842653.sprfilter,tp,0,LOCATION_MZONE,1,nil,1-tp,tp)
end
function c91842653.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c91842653.sprfilter,tp,0,LOCATION_MZONE,nil,1-tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c91842653.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c91842653.dircon(e)
	return not Duel.IsExistingMatchingCard(c91842653.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c91842653.atcon(e)
	return Duel.IsExistingMatchingCard(c91842653.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c91842653.atlimit(e,c)
	return not c:IsType(TYPE_TOON) or c:IsFacedown()
end
function c91842653.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c91842653.atcost(e,c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c91842653.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
function c91842653.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c91842653.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c91842653.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c91842653.desfilter(c,def)
	return c:IsFaceup() and c:IsDefenseBelow(def+1)
end
function c91842653.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91842653.desfilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack()) end
	local sg=Duel.GetMatchingGroup(c91842653.desfilter,tp,0,LOCATION_MZONE,nil,e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c91842653.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c91842653.desfilter,tp,0,LOCATION_MZONE,nil,e:GetHandler():GetAttack())
	Duel.Destroy(sg,REASON_EFFECT)
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1,true)
	end
end
function c91842653.spcon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp)
end
function c91842653.spfilter3(c,e,tp)
	return c:IsType(TYPE_TOON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c91842653.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c91842653.spfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c91842653.spop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c91842653.spfilter3),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end