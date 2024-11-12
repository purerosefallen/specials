--トゥーン・テラー
function c53094821.initial_effect(c)
	aux.AddCodeList(c,15259703)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c53094821.condition)
	e1:SetTarget(c53094821.target)
	e1:SetOperation(c53094821.activate)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53094821,0))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(c53094821.handcon)
	c:RegisterEffect(e4)
end
function c53094821.filter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c53094821.handcon(e)
	return Duel.IsExistingMatchingCard(c53094821.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c53094821.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c53094821.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c53094821.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c53094821.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c53094821.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
