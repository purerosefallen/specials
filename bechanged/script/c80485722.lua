--ヴァンパイア・キラー
function c80485722.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80485722,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c80485722.destg)
	e1:SetOperation(c80485722.desop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80485722,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c80485722.discon)
	e3:SetTarget(c80485722.distg)
	e3:SetOperation(c80485722.disop)
	c:RegisterEffect(e3)
end
function c80485722.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsFaceup() and bc:IsAttribute(ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c80485722.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function c80485722.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
		and ep==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_ZOMBIE) and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c80485722.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c80485722.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(80485722,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end