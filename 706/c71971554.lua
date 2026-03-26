--ロード・シンクロ�?
---@param c Card
function c71971554.initial_effect(c)
	local elast = nil
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71971554,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(c71971554.lvcon)
	e1:SetOperation(c71971554.lvop)
	e1:SetLabelObject(elast)
	elast=e1
	c:RegisterEffect(e1)
	--lv up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(c71971554.lvval)
	e2:SetLabelObject(elast)
	elast=e2
	c:RegisterEffect(e2)
end
function c71971554.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and e:GetHandler():IsRelateToBattle()
end
function c71971554.lvop(e,tp,eg,ep,ev,re,r,rp)
	local elast = nil
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(1)
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
		e_reset:SetOperation(c71971554.rstop)
		Duel.RegisterEffect(e_reset,tp)
	end
end
function c71971554.lvval(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsCode(2322421) then return lv
	else
		if lv<=2 then return 16 end
		return lv-2
	end
end

function c71971554.rstop(e,tp,eg,ep,ev,re,r,rp)
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