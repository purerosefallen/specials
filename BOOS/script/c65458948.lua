--トゥーン・マーメイド
function c65458948.initial_effect(c)
	aux.AddCodeList(c,15259703)
	c:EnableReviveLimit()
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c65458948.spcon)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetTarget(c65458948.desreptg)
	e3:SetValue(c65458948.desrepval)
	e3:SetOperation(c65458948.desrepop)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c65458948.dircon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetCondition(c65458948.atcon)
	e5:SetValue(c65458948.atlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e6:SetCondition(c65458948.atcon)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c65458948.target)
	e7:SetOperation(c65458948.operation)
	c:RegisterEffect(e7)
end
function c65458948.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x62)
end
function c65458948.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(c65458948.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c65458948.sfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousCodeOnField()==15259703 and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c65458948.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65458948.sfilter,1,nil)
end
function c65458948.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c65458948.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c65458948.dircon(e)
	return not Duel.IsExistingMatchingCard(c65458948.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c65458948.atcon(e)
	return Duel.IsExistingMatchingCard(c65458948.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c65458948.atlimit(e,c)
	return not c:IsType(TYPE_TOON) or c:IsFacedown()
end
function c65458948.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsCode(15259703)
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c65458948.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c65458948.repfilter,1,nil,tp)
		and c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c65458948.desrepval(e,c)
	return c65458948.repfilter(c,e:GetHandlerPlayer())
end
function c65458948.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65458948)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
function c65458948.pfilter(c,tp)
	return c:IsCode(15259703)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c65458948.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c65458948.pfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c65458948.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c65458948.pfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end