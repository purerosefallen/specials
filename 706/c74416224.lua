--ブラック・レイ・ランサー
---@param c Card
function c74416224.initial_effect(c)
	local elast = nil
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),3,2)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetDescription(aux.Stringid(74416224,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c74416224.cost)
	e1:SetTarget(c74416224.target)
	e1:SetOperation(c74416224.operation)
	e1:SetLabelObject(elast)
	elast=e1
	c:RegisterEffect(e1)
end
function c74416224.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c74416224.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c74416224.operation(e,tp,eg,ep,ev,re,r,rp)
	local elast = nil
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetLabelObject(elast)
		elast=e1
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetLabelObject(elast)
		elast=e2
		tc:RegisterEffect(e2)
		if not tc:IsImmuneToEffect(e) then
			local e_reset=Effect.CreateEffect(e:GetHandler())
			e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e_reset:SetCode(EVENT_PHASE+PHASE_END)
			e_reset:SetReset(RESET_PHASE+PHASE_END)
			e_reset:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e_reset:SetCountLimit(1)
			e_reset:SetLabelObject(elast)
			e_reset:SetOperation(c74416224.rstop)
			Duel.RegisterEffect(e_reset,tp)
		end
	end
end

function c74416224.rstop(e,tp,eg,ep,ev,re,r,rp)
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