--トゥーン・仮面魔道士
function c16392422.initial_effect(c)
	aux.AddCodeList(c,15259703)
	c:SetUniqueOnField(1,1,c16392422.uqfilter,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c16392422.spcon)
	c:RegisterEffect(e1)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c16392422.dircon)
	c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(16392422,0))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DAMAGE)
	e6:SetCondition(c16392422.condition)
	e6:SetTarget(c16392422.target)
	e6:SetOperation(c16392422.operation)
	c:RegisterEffect(e6)
end
function c16392422.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c16392422.uqfilter(c)
	if Duel.IsExistingMatchingCard(c16392422.cfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		return false
	else
		return c:IsType(TYPE_TOON)
	end
end
function c16392422.filter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c16392422.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c16392422.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c16392422.dirfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c16392422.dirfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c16392422.dircon(e)
	return Duel.IsExistingMatchingCard(c16392422.dirfilter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c16392422.dirfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c16392422.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c16392422.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c16392422.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
