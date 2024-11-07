--究極時械神セフィロン
function c8967776.initial_effect(c)
	c:SetSPSummonOnce(8967776)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(8967776,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_HAND)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c8967776.sprcon)
	e0:SetTarget(c8967776.sprtg)
	e0:SetOperation(c8967776.sprop)
	c:RegisterEffect(e0)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8967776,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c8967776.spcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c8967776.target)
	e3:SetOperation(c8967776.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SET_ATTACK_FINAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(0,EFFECT_FLAG2_WICKED)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c8967776.atktg)
	e6:SetValue(c8967776.atkval)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(c8967776.val)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_DISABLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,LOCATION_MZONE)
	e8:SetTarget(c8967776.distg)
	c:RegisterEffect(e8)
end
function c8967776.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
		and c:IsCode(9409625,36894320,72883039)
end
function c8967776.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c8967776.cfilter,tp,LOCATION_ONFIELD,0,1,c,tp)
end
function c8967776.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c8967776.cfilter,tp,LOCATION_ONFIELD,0,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c8967776.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
function c8967776.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,10,nil,TYPE_MONSTER)
end
function c8967776.pfilter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsCode(9409625,36894320,72883039)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c8967776.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c8967776.pfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c8967776.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c8967776.pfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function c8967776.atktg(e,c)
	return c~=e:GetHandler() and not c:IsCode(8967776) and c:IsSetCard(0x4a)
end
function c8967776.atkval(e,c)
	return 4000
end
function c8967776.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4a)
end
function c8967776.val(e,c)
	local g=Duel.GetMatchingGroup(c8967776.vfilter,c:GetControler(),LOCATION_MZONE,0,c)
	return g:GetSum(Card.GetAttack)
end
function c8967776.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end