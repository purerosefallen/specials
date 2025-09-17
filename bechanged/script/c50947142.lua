--くず鉄のシグナル
function c50947142.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,50947142+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c50947142.condition)
	e1:SetTarget(c50947142.target)
	e1:SetOperation(c50947142.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50947142,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c50947142.handcon)
	c:RegisterEffect(e2)
end
function c50947142.filter(c)
	return c:IsType(TYPE_SYNCHRO) and aux.IsMaterialListType(c,TYPE_SYNCHRO) and c:IsFaceup()
end
function c50947142.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and rp==1-tp
end
function c50947142.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c50947142.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c50947142.handcon(e)
	return Duel.IsExistingMatchingCard(c50947142.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end