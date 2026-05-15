--海底に潜む深海竜
---@param c Card
function c4404099.initial_effect(c)
	c:EnableCounterPermit(0x23)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4404099,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetTarget(c4404099.addct)
	e1:SetOperation(c4404099.addc)
	c:RegisterEffect(e1)
	--attackup
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(c4404099.regop)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4404099,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c4404099.atkcon)
	e2:SetOperation(c4404099.atkop)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
end
function c4404099.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x23)
end
function c4404099.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x23,1)
	end
end
function c4404099.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x23)
	e:SetLabel(ct)
end
function c4404099.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	e:SetLabel(ct)
	return ct>0
end
function c4404099.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH+RACE_SEASERPENT)
end
function c4404099.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4404099.filter,tp,LOCATION_MZONE,0,nil)
	-- 新增变量声明
	local fid=e:GetHandler():GetFieldID()
	local elast = nil
	local count = 0
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(e:GetLabel()*200)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			-- RegisterEffect前插入
			e1:SetLabelObject(elast or g)
			elast = e1
			e1:SetLabel(count)
			count = count + 1
			tc:RegisterEffect(e1)
			-- 最后一个RegisterEffect后插入FlagEffect
			tc:RegisterFlagEffect(4404099,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		tc=g:GetNext()
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
		e_reset:SetCondition(c4404099.descon)
		e_reset:SetOperation(c4404099.rstop)
		Duel.RegisterEffect(e_reset,tp)
	end
end

function c4404099.desfilter(c,fid)
	return c:GetFlagEffectLabel(4404099)==fid
end

function c4404099.descon(e,tp,eg,ep,ev,re,r,rp)
	local g = e:GetLabelObject()
	while g:GetLabel() ~= 0 do
		g = g:GetLabelObject()
	end
	g = g:GetLabelObject()
	if not g:IsExists(c4404099.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end

function c4404099.rstop(e,tp,eg,ep,ev,re,r,rp)
	local sg = e:GetLabelObject()
	while sg:GetLabel() ~= 0 do
		sg = sg:GetLabelObject()
	end
	sg = sg:GetLabelObject()
	local dg=sg:Filter(c4404099.desfilter,nil,e:GetLabel())
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
