--トゥーン・バスター・ブレイダー
function c61190918.initial_effect(c)
	aux.AddCodeList(c,15259703)
	c:SetUniqueOnField(1,1,c61190918.uqfilter,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(61190918,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c61190918.spcon)
	e1:SetTarget(c61190918.sptg)
	e1:SetOperation(c61190918.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(61190918,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP,1)
	e2:SetCondition(c61190918.spcon2)
	e2:SetTarget(c61190918.sptg2)
	e2:SetOperation(c61190918.spop)
	c:RegisterEffect(e2)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c61190918.val)
	c:RegisterEffect(e4)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c61190918.dircon)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetTarget(c61190918.eqtg)
	e6:SetOperation(c61190918.eqop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
end
function c61190918.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c61190918.uqfilter(c)
	if Duel.IsExistingMatchingCard(c61190918.cfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		return false
	else
		return c:IsType(TYPE_TOON)
	end
end
function c61190918.sprfilter(c,tp,sp)
	return Duel.GetMZoneCount(tp,c,sp)>0
end
function c61190918.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c61190918.sprfilter,tp,LOCATION_MZONE,0,1,nil,tp,tp)
end
function c61190918.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c61190918.sprfilter,tp,LOCATION_MZONE,0,nil,tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c61190918.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function c61190918.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c61190918.sprfilter,tp,0,LOCATION_MZONE,1,nil,1-tp,tp)
end
function c61190918.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c61190918.sprfilter,tp,0,LOCATION_MZONE,nil,1-tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c61190918.dirfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c61190918.dirfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c61190918.dircon(e)
	return Duel.IsExistingMatchingCard(c61190918.dirfilter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c61190918.dirfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c61190918.val(e,c)
	return Duel.GetMatchingGroupCount(c61190918.filter,c:GetControler(),0,LOCATION_GRAVE+LOCATION_MZONE,nil)*500
end
function c61190918.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c61190918.dirfilter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c61190918.filter(c)
	return c:IsRace(RACE_DRAGON) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c61190918.eqfilter(c)
	return c:IsType(TYPE_TOON) and c:IsType(TYPE_MONSTER)
		and c:IsRace(RACE_DRAGON) and not c:IsForbidden()
end
function c61190918.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c61190918.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c61190918.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c61190918.eqfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c61190918.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_ZOMBIE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e2g=e2:Clone()
		e2g:SetTargetRange(0,LOCATION_GRAVE)
		e2g:SetCondition(c61190918.gravecon)
		tc:RegisterEffect(e2g)
	end
end
function c61190918.eqlimit(e,c)
	return e:GetOwner()==c
end
function c61190918.gravecon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY)
		and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY)
end