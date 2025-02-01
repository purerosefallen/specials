--クリムゾン・ヘル・セキュア
---@param c Card
function c50215517.initial_effect(c)
	aux.AddCodeList(c,70902743)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50215517)
	e1:SetTarget(c50215517.target2)
	e1:SetOperation(c50215517.activate2)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,50215518)
	e2:SetCondition(c50215517.condition)
	e2:SetTarget(c50215517.target)
	e2:SetOperation(c50215517.activate)
	c:RegisterEffect(e2)
end
function c50215517.cfilter2(c)
	return aux.NegateMonsterFilter and c:IsPosition(POS_FACEUP_DEFENSE)
end
function c50215517.pfilter(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function c50215517.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50215517.cfilter2,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c50215517.cfilter2,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c50215517.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c50215517.cfilter2,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	if #g>0 then
		local g1=Duel.GetMatchingGroup(c50215517.pfilter,tp,0,LOCATION_MZONE,nil)
		if g1:GetCount()>0 then
			Duel.BreakEffect()
			Duel.ChangePosition(g1,POS_FACEUP_DEFENSE)
		end
	end
end
function c50215517.cfilter(c)
	return c:IsFaceup() and c:IsCode(70902743)
end
function c50215517.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c50215517.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c50215517.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c50215517.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50215517.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c50215517.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c50215517.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c50215517.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end
