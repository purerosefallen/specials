--トゥーン・ヂェミナイ・エルフ
function c42386471.initial_effect(c)
	aux.AddCodeList(c,15259703)
	c:SetUniqueOnField(1,1,c42386471.uqfilter,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c42386471.spcon)
	c:RegisterEffect(e1)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c42386471.dircon)
	c:RegisterEffect(e5)
	--handes
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(42386471,0))
	e6:SetCategory(CATEGORY_HANDES)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DAMAGE)
	e6:SetCondition(c42386471.condition)
	e6:SetTarget(c42386471.target)
	e6:SetOperation(c42386471.operation)
	c:RegisterEffect(e6)
end
function c42386471.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c42386471.uqfilter(c)
	if Duel.IsExistingMatchingCard(c42386471.cfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		return false
	else
		return c:IsType(TYPE_TOON)
	end
end
function c42386471.filter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c42386471.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c42386471.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c42386471.dirfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c42386471.dirfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c42386471.dircon(e)
	return Duel.IsExistingMatchingCard(c42386471.dirfilter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c42386471.dirfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c42386471.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c42386471.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(ep,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c42386471.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
end
