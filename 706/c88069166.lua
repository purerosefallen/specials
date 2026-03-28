--???????????
---@param c Card
function c88069166.initial_effect(c)
	local elast = nil
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabelObject(elast)
	elast=e1
	c:RegisterEffect(e1)
	--confirm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88069166,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c88069166.target)
	e2:SetOperation(c88069166.operation)
	e2:SetLabelObject(elast)
	elast=e2
	c:RegisterEffect(e2)
	--cancel target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TURN_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c88069166.ctarget)
	e3:SetLabelObject(elast)
	elast=e3
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TARGET)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetLabelObject(elast)
	elast=e4
	c:RegisterEffect(e4)
	if not c:IsImmuneToEffect(e) then
		local e_reset=Effect.CreateEffect(e:GetHandler())
		e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e_reset:SetCode(EVENT_PHASE+PHASE_END)
		e_reset:SetReset(RESET_PHASE+PHASE_END)
		e_reset:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e_reset:SetCountLimit(1)
		e_reset:SetLabelObject(elast)
		e_reset:SetCondition(c88069166.rstcon)
		e_reset:SetOperation(c88069166.rstop)
		Duel.RegisterEffect(e_reset,tp)
	end
end
function c88069166.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x4b)
end
function c88069166.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c88069166.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88069166.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c88069166.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetChainLimit(c88069166.chlimit)
end
function c88069166.chlimit(e,ep,tp)
	return tp==ep
end
function c88069166.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
		g1:Merge(g2)
		Duel.ConfirmCards(tp,g1)
		Duel.ShuffleHand(1-tp)
	end
end
function c88069166.ctarget(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc then e:GetHandler():CancelCardTarget(tc) end
end

function c88069166.rstcon(e,tp,eg,ep,ev,re,r,rp)
    local ecur = e:GetLabelObject()
    local tc = ecur:GetHandler()
    return tc:GetLocation() == LOCATION_MZONE and tc:GetPosition()&POS_FACEUP ~= 0
end
function c88069166.rstop(e,tp,eg,ep,ev,re,r,rp)
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