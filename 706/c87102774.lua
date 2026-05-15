--黄金の天道虫
---@param c Card
function c87102774.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87102774,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(c87102774.reccon)
	e1:SetCost(c87102774.reccost)
	e1:SetTarget(c87102774.rectg)
	e1:SetOperation(c87102774.recop)
	c:RegisterEffect(e1)
end
function c87102774.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c87102774.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local elast = nil
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetDescription(66)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetLabelObject(elast)
	elast=e1
	e:GetHandler():RegisterEffect(e1)
	local e_reset=Effect.CreateEffect(e:GetHandler())
	e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e_reset:SetCode(EVENT_PHASE+PHASE_END)
	e_reset:SetReset(RESET_PHASE+PHASE_END)
	e_reset:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e_reset:SetCountLimit(1)
	e_reset:SetLabelObject(elast)
	e_reset:SetCondition(c87102774.rstcon)
	e_reset:SetOperation(c87102774.rstop)
	Duel.RegisterEffect(e_reset,tp)
end
function c87102774.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c87102774.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c87102774.rstcon(e,tp,eg,ep,ev,re,r,rp)
    local ecur = e:GetLabelObject()
    local tc = ecur:GetHandler()
    return tc:GetLocation() == LOCATION_HAND and tc:GetPosition()&POS_FACEUP ~= 0
end
function c87102774.rstop(e,tp,eg,ep,ev,re,r,rp)
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