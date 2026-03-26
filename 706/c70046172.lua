--Á™ÅÈÄ?
---@param c Card
function c70046172.initial_effect(c)
	local elast = nil
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c70046172.target)
	e1:SetOperation(c70046172.activate)
	e1:SetLabelObject(elast)
	elast=e1
	c:RegisterEffect(e1)
end
function c70046172.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c70046172.activate(e,tp,eg,ep,ev,re,r,rp)
	local elast = nil
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(700)
		e1:SetLabelObject(elast)
		elast=e1
		tc:RegisterEffect(e1)
		if not tc:IsImmuneToEffect(e) then
			local e_reset=Effect.CreateEffect(e:GetHandler())
			e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e_reset:SetCode(EVENT_PHASE+PHASE_END)
			e_reset:SetReset(RESET_PHASE+PHASE_END)
			e_reset:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e_reset:SetCountLimit(1)
			e_reset:SetLabelObject(elast)
			e_reset:SetOperation(c70046172.rstop)
			Duel.RegisterEffect(e_reset,tp)
		end
	end
end

function c70046172.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local ecur = e:GetLabelObject()
	local tc = ecur:GetHandler()
	if tc:GetLocation() ~= LOCATION_MZONE or tc:GetPosition()&POS_FACEUP == 0 then return end
	local elast = nil
	while ecur do
		elast = ecur
		ecur = ecur:GetLabelObject()
		elast:Reset()
	end
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,1-tp,1162)
end