--レッドアイズ・トゥーン・ドラゴン
function c31733941.initial_effect(c)
	aux.AddCodeList(c,15259703)
	c:SetUniqueOnField(1,1,c31733941.uqfilter,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31733941,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c31733941.spcon)
	e1:SetTarget(c31733941.sptg)
	e1:SetOperation(c31733941.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31733941,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP,1)
	e2:SetCondition(c31733941.spcon2)
	e2:SetTarget(c31733941.sptg2)
	e2:SetOperation(c31733941.spop)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(c31733941.dircon)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31733941,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c31733941.sptg)
	e4:SetOperation(c31733941.spop)
	c:RegisterEffect(e4)
end
function c31733941.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c31733941.uqfilter(c)
	if Duel.IsExistingMatchingCard(c31733941.cfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		return false
	else
		return c:IsType(TYPE_TOON)
	end
end
function c31733941.sprfilter(c,tp,sp)
	return Duel.GetMZoneCount(tp,c,sp)>0
end
function c31733941.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c31733941.sprfilter,tp,LOCATION_MZONE,0,1,nil,tp,tp)
end
function c31733941.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c31733941.sprfilter,tp,LOCATION_MZONE,0,nil,tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c31733941.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function c31733941.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c31733941.sprfilter,tp,0,LOCATION_MZONE,1,nil,1-tp,tp)
end
function c31733941.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c31733941.sprfilter,tp,0,LOCATION_MZONE,nil,1-tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c31733941.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c31733941.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c31733941.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c31733941.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c31733941.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c31733941.spfilter(c,e,tp)
	return c:IsType(TYPE_TOON) and not c:IsCode(31733941) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c31733941.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c31733941.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c31733941.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c31733941.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c31733941.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetBaseAttack())
end
function c31733941.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Damage(1-tp,e:GetHandler():GetBaseAttack(),REASON_EFFECT)
	end
	if e:GetHandler():IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1,true)
	end
end