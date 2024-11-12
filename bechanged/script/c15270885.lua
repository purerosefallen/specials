--トゥーン・ゴブリン突撃部隊
function c15270885.initial_effect(c)
	aux.AddCodeList(c,15259703)
	c:SetUniqueOnField(1,1,c15270885.uqfilter,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c15270885.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetCondition(c15270885.indcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15270885,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c15270885.sptg3)
	e3:SetOperation(c15270885.spop3)
	c:RegisterEffect(e3)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c15270885.dircon)
	c:RegisterEffect(e5)
	--to defense
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c15270885.poscon)
	e6:SetOperation(c15270885.posop)
	c:RegisterEffect(e6)
end
function c15270885.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c15270885.uqfilter(c)
	if Duel.IsExistingMatchingCard(c15270885.cfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		return false
	else
		return c:IsType(TYPE_TOON)
	end
end
function c15270885.filter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c15270885.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c15270885.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c15270885.indcon(e)
	return e:GetHandler():IsDefensePos()
end
function c15270885.dirfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c15270885.dirfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c15270885.dircon(e)
	return Duel.IsExistingMatchingCard(c15270885.dirfilter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c15270885.dirfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c15270885.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function c15270885.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c15270885.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c15270885.spop3(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c15270885.atktarget)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e2)
	if e:GetHandler():IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1,true)
	end
end
function c15270885.atktarget(e,c)
	if e:GetHandler():GetAttack()==0 then
		return false
	else
		return c:IsAttackBelow(e:GetHandler():GetAttack()-1)
	end
end