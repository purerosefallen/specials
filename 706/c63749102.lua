--??????????????????
---@param c Card
function c63749102.initial_effect(c)
	local elast = nil
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(63749102,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMING_BATTLE_PHASE)
	e1:SetCondition(c63749102.atkcon)
	e1:SetOperation(c63749102.atkop)
	e1:SetLabelObject(elast)
	elast=e1
	c:RegisterEffect(e1)
end
function c63749102.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c63749102.atkop(e,tp,eg,ep,ev,re,r,rp)
	local elast = nil
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(-400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetLabelObject(elast)
		elast=e1
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_PIERCE)
		e2:SetLabelObject(elast)
		elast=e2
		c:RegisterEffect(e2)
		if not c:IsImmuneToEffect(e) then
			local e_reset=Effect.CreateEffect(e:GetHandler())
			e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e_reset:SetCode(EVENT_PHASE+PHASE_END)
			e_reset:SetReset(RESET_PHASE+PHASE_END)
			e_reset:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e_reset:SetCountLimit(1)
			e_reset:SetLabelObject(elast)
			e_reset:SetCondition(c63749102.rstcon)
			e_reset:SetOperation(c63749102.rstop)
			Duel.RegisterEffect(e_reset,tp)
		end
	end
end

function c63749102.rstcon(e,tp,eg,ep,ev,re,r,rp)
    local ecur = e:GetLabelObject()
    local tc = ecur:GetHandler()
    return tc:GetLocation() == LOCATION_MZONE and tc:GetPosition()&POS_FACEUP ~= 0
end
function c63749102.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local ecur = e:GetLabelObject()
	local tc = ecur:GetHandler()
	local elast = nil
	while ecur do
		elast = ecur
		ecur = ecur:GetLabelObject()
		elast:Reset()
	end
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,1-tp,1162)
end