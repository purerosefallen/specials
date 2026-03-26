--氷結界の虎王ドゥローレン
function c70583986.initial_effect(c)
	local elast = nil
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	c:EnableReviveLimit()
	--to hand, atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70583986,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c70583986.target)
	e1:SetOperation(c70583986.operation)
	e1:SetLabelObject(elast)
	elast=e1
	c:RegisterEffect(e1)
end
function c70583986.filter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c70583986.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c70583986.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c70583986.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c70583986.filter,tp,LOCATION_ONFIELD,0,1,12,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c70583986.operation(e,tp,eg,ep,ev,re,r,rp)
	local elast = nil
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.BreakEffect()
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		if ct>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			e1:SetValue(ct*500)
			e1:SetLabelObject(elast)
			elast=e1
			c:RegisterEffect(e1)
			if not c:IsImmuneToEffect(e) then
				local e_reset=Effect.CreateEffect(e:GetHandler())
				e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e_reset:SetCode(EVENT_PHASE+PHASE_END)
				e_reset:SetReset(RESET_PHASE+PHASE_END)
				e_reset:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e_reset:SetCountLimit(1)
				e_reset:SetLabelObject(elast)
				e_reset:SetOperation(c70583986.rstop)
				Duel.RegisterEffect(e_reset,tp)
			end
		end
	end
end

function c70583986.rstop(e,tp,eg,ep,ev,re,r,rp)
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