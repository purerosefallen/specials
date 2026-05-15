--シャイニング・アブソーブ
---@param c Card
function c90263923.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c90263923.target)
	e1:SetOperation(c90263923.activate)
	c:RegisterEffect(e1)
end
function c90263923.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c90263923.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c90263923.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c90263923.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_ATTACK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c90263923.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c90263923.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEUP_ATTACK)
	-- 新增变量声明
	local fid=e:GetHandler():GetFieldID()
	local elast = nil
	local count = 0
	if g:GetCount()>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local sc=g:GetFirst()
		local atk=tc:GetAttack()
		while sc do
			if not sc:IsImmuneToEffect(e) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetValue(atk)
				-- RegisterEffect前插入
				e1:SetLabelObject(elast or g)
				elast = e1
				e1:SetLabel(count)
				count = count + 1
				sc:RegisterEffect(e1)
				-- 最后一个RegisterEffect后插入FlagEffect
				sc:RegisterFlagEffect(90263923,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			end
			sc=g:GetNext()
		end
		-- while循环后插入e_reset相关代码
		if elast ~= nil then
			g:KeepAlive()
			local e_reset=Effect.CreateEffect(e:GetHandler())
			e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e_reset:SetCode(EVENT_PHASE+PHASE_END)
			e_reset:SetReset(RESET_PHASE+PHASE_END)
			e_reset:SetCountLimit(1)
			e_reset:SetLabel(fid)
			e_reset:SetLabelObject(elast)
			e_reset:SetCondition(c90263923.descon)
			e_reset:SetOperation(c90263923.rstop)
			Duel.RegisterEffect(e_reset,tp)
		end
	end
end

function c90263923.desfilter(c,fid)
	return c:GetFlagEffectLabel(90263923)==fid
end

function c90263923.descon(e,tp,eg,ep,ev,re,r,rp)
	local g = e:GetLabelObject()
	while g:GetLabel() ~= 0 do
		g = g:GetLabelObject()
	end
	g = g:GetLabelObject()
	if not g:IsExists(c90263923.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end

function c90263923.rstop(e,tp,eg,ep,ev,re,r,rp)
	local sg = e:GetLabelObject()
	while sg:GetLabel() ~= 0 do
		sg = sg:GetLabelObject()
	end
	sg = sg:GetLabelObject()
	local dg=sg:Filter(c90263923.desfilter,nil,e:GetLabel())
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
