--レベル変換実験室
---@param c Card
function c84397023.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c84397023.tg)
	e1:SetOperation(c84397023.op)
	c:RegisterEffect(e1)
end
function c84397023.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_MONSTER) end
end
function c84397023.op(e,tp,eg,ep,ev,re,r,rp)
	local elast = nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		local ct=Duel.TossDice(tp,1)
		if ct==1 then Duel.SendtoGrave(g,REASON_EFFECT)
		elseif ct>=2 and ct<=6 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(ct)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
			e1:SetLabelObject(elast)
			elast=e1
			local tc=g:GetFirst()
			tc:RegisterEffect(e1)
			-- g:GetFirst():RegisterEffect(e1)
			Duel.ShuffleHand(tp)
			if not tc:IsImmuneToEffect(e) then
				local e_reset=Effect.CreateEffect(e:GetHandler())
				e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e_reset:SetCode(EVENT_PHASE+PHASE_END)
				e_reset:SetReset(RESET_PHASE+PHASE_END)
				e_reset:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e_reset:SetCountLimit(1)
				e_reset:SetLabelObject(elast)
				e_reset:SetCondition(c84397023.rstcon)
				e_reset:SetOperation(c84397023.rstop)
				Duel.RegisterEffect(e_reset,tp)
			end
		end
	end
end
function c84397023.rstcon(e,tp,eg,ep,ev,re,r,rp)
    local ecur = e:GetLabelObject()
    local tc = ecur:GetHandler()
    return tc:GetLocation() == LOCATION_MZONE and tc:GetPosition()&POS_FACEUP ~= 0
end
function c84397023.rstop(e,tp,eg,ep,ev,re,r,rp)
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