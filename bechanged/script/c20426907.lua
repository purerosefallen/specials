--機殻の再星
---@param c Card
function c20426907.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c20426907.distg1)
	e2:SetOperation(c20426907.disop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c20426907.distg2)
	e4:SetOperation(c20426907.disop2)
	c:RegisterEffect(e4)
	--pos
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c20426907.condition)
	e5:SetOperation(c20426907.operation)
	c:RegisterEffect(e5)
	--act in set turn
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(20426907,2))
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetCondition(c20426907.actcon)
	c:RegisterEffect(e6)
end
function c20426907.filter1(c)
	return c:IsFaceup() and not c:IsLevelAbove(1)
end
function c20426907.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c20426907.filter1,1,nil)
end
function c20426907.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c20426907.filter1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function c20426907.actfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0xaa)
end
function c20426907.actcon(e)
	return Duel.IsExistingMatchingCard(c20426907.actfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,1,nil)
end
function c20426907.distg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tc=eg:GetFirst()
		if e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then
			return tc:IsLevelBelow(4)
		else
			return tc:IsLevelBelow(4) and not tc:IsType(TYPE_NORMAL)
		end
	end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c20426907.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c20426907.filter(c,activated)
	return c:IsFaceup() and c:IsLevelAbove(5) and (activated or not c:IsType(TYPE_NORMAL))
end
function c20426907.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local activated=e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
	if chk==0 then return eg:IsExists(c20426907.filter,1,nil,activated) end
	local g=eg:Filter(c20426907.filter,nil,activated)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c20426907.disfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c20426907.disop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c20426907.disfilter,nil,e)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
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
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e3:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end