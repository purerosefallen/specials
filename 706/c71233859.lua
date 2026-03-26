--フォトン・ブースター
---@param c Card
function c71233859.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c71233859.target)
	e1:SetOperation(c71233859.activate)
	c:RegisterEffect(e1)
end
function c71233859.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c71233859.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c71233859.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71233859.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c71233859.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c71233859.afilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c71233859.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local fid=e:GetHandler():GetFieldID()
	local elast = nil
	local count = 0
	local g=Duel.GetMatchingGroup(c71233859.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc:GetCode())
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(2000)
			e1:SetLabelObject(elast or g)
			elast = e1
			e1:SetLabel(count)
			count = count + 1
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(71233859,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		tc=g:GetNext()
	end
	if elast ~= nil then
		g:KeepAlive()
		local e_reset=Effect.CreateEffect(e:GetHandler())
		e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e_reset:SetCode(EVENT_PHASE+PHASE_END)
		e_reset:SetReset(RESET_PHASE+PHASE_END)
		e_reset:SetCountLimit(1)
		e_reset:SetLabel(fid)
		e_reset:SetLabelObject(elast)
		e_reset:SetCondition(c71233859.descon)
		e_reset:SetOperation(c71233859.rstop)
		Duel.RegisterEffect(e_reset,tp)
	end
end

function c71233859.desfilter(c,fid)
	return c:GetFlagEffectLabel(71233859)==fid
end

function c71233859.descon(e,tp,eg,ep,ev,re,r,rp)
	local g = e:GetLabelObject()
	while g:GetLabel() ~= 0 do
		g = g:GetLabelObject()
	end
	g = g:GetLabelObject()
	if not g:IsExists(c71233859.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end

function c71233859.rstop(e,tp,eg,ep,ev,re,r,rp)
	local sg = e:GetLabelObject()
	while sg:GetLabel() ~= 0 do
		sg = sg:GetLabelObject()
	end
	sg = sg:GetLabelObject()
	local dg=sg:Filter(c71233859.desfilter,nil,e:GetLabel())
	sg:DeleteGroup()
	if dg:GetCount()>0 then
		local ecur = e:GetLabelObject()
		local elast = nil
		while ecur:GetLabel() ~= 0 do
			elast = ecur
			ecur = ecur:GetLabelObject()
			elast:Reset()
		end
		ecur:Reset()
		Duel.HintSelection(Group.FromCards(c))
		Duel.Hint(HINT_OPSELECTED,1-tp,1162)
	end
end
