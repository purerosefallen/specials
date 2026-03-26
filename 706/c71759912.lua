--ラッコア�?
---@param c Card
function c71759912.initial_effect(c)
	local elast = nil
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71759912,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c71759912.condition)
	e1:SetTarget(c71759912.target)
	e1:SetOperation(c71759912.operation)
	e1:SetLabelObject(elast)
	elast=e1
	c:RegisterEffect(e1)
end
function c71759912.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST)
end
function c71759912.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c71759912.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c71759912.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c71759912.operation(e,tp,eg,ep,ev,re,r,rp)
	local elast = nil
	if not Duel.IsExistingMatchingCard(c71759912.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
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
			e_reset:SetOperation(c71759912.rstop)
			Duel.RegisterEffect(e_reset,tp)
		end
	end
end

function c71759912.rstop(e,tp,eg,ep,ev,re,r,rp)
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