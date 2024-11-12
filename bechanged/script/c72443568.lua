--サイレント・マジシャン LV8
function c72443568.initial_effect(c)
	aux.AddCodeList(c,79791878)
	c:EnableCounterPermit(0x1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c72443568.tg)
	e2:SetValue(c72443568.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DRAW)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c72443568.addc)
	c:RegisterEffect(e3)
	--attackup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c72443568.attackup)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(72443568,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_HAND)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1,72443568)
	e6:SetCondition(c72443568.condition)
	e6:SetTarget(c72443568.sptg)
	e6:SetOperation(c72443568.spop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(c72443568.tg)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
c72443568.lvup={73665146}
c72443568.lvdn={73665146}
function c72443568.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c72443568.addc(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then
		local c=e:GetHandler()
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c72443568.attackup(e,c)
	return math.max(0,c:GetLevel()-c:GetOriginalLevel())*500
end
function c72443568.cfilter(c)
	return (c:IsCode(79791878) or c:IsSetCard(0xe8)) and c:IsFaceup()
end
function c72443568.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72443568.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c72443568.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c72443568.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c72443568.tg(e,c)
	return c:IsSetCard(0xe7,0xe8)
end