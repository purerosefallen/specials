--天使のサイコロ
---@param c Card
function c74137509.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c74137509.target)
	e1:SetOperation(c74137509.activate)
	c:RegisterEffect(e1)
end
function c74137509.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c74137509.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	-- 新增变量声明
	local fid=e:GetHandler():GetFieldID()
	local elast = nil
	local count = 0
	if g:GetCount()>0 then
		local d=Duel.TossDice(tp,1)
		local sc=g:GetFirst()
		while sc do
			if not sc:IsImmuneToEffect(e) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetValue(d*100)
				-- RegisterEffect前插入
				e1:SetLabelObject(elast or g)
				elast = e1
				e1:SetLabel(count)
				count = count + 1
				sc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				e2:SetLabelObject(elast or g)
				elast = e2
				e2:SetLabel(count)
				count = count + 1
				sc:RegisterEffect(e2)
				-- 最后一个RegisterEffect后插入FlagEffect
				sc:RegisterFlagEffect(74137509,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
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
			e_reset:SetCondition(c74137509.descon)
			e_reset:SetOperation(c74137509.rstop)
			Duel.RegisterEffect(e_reset,tp)
		end
	end
end

function c74137509.desfilter(c,fid)
	return c:GetFlagEffectLabel(74137509)==fid
end

function c74137509.descon(e,tp,eg,ep,ev,re,r,rp)
	local g = e:GetLabelObject()
	while g:GetLabel() ~= 0 do
		g = g:GetLabelObject()
	end
	g = g:GetLabelObject()
	if not g:IsExists(c74137509.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end

function c74137509.rstop(e,tp,eg,ep,ev,re,r,rp)
	local sg = e:GetLabelObject()
	while sg:GetLabel() ~= 0 do
		sg = sg:GetLabelObject()
	end
	sg = sg:GetLabelObject()
	local dg=sg:Filter(c74137509.desfilter,nil,e:GetLabel())
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
