--?????????
---@param c Card
function c33455338.initial_effect(c)
	local elast = nil
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33455338,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c33455338.atkcon)
	e1:SetCost(c33455338.atkcost)
	e1:SetOperation(c33455338.atkop)
	e1:SetLabelObject(elast)
	elast=e1
	c:RegisterEffect(e1)
end
function c33455338.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c33455338.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()
end
function c33455338.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33455338.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33455338.filter,tp,LOCATION_GRAVE,0,1,99,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c33455338.atkop(e,tp,eg,ep,ev,re,r,rp)
	local elast = nil
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(e:GetLabel()*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
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
			e_reset:SetCondition(c33455338.rstcon)
			e_reset:SetOperation(c33455338.rstop)
			Duel.RegisterEffect(e_reset,tp)
		end
	end
end

function c33455338.rstcon(e,tp,eg,ep,ev,re,r,rp)
    local ecur = e:GetLabelObject()
    local tc = ecur:GetHandler()
    return tc:GetLocation() == LOCATION_MZONE and tc:GetPosition()&POS_FACEUP ~= 0
end
function c33455338.rstop(e,tp,eg,ep,ev,re,r,rp)
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