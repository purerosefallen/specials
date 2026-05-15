--D-HERO ダガーガイ
---@param c Card
function c55461064.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55461064,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c55461064.atkcon)
	e1:SetCost(c55461064.atkcost)
	e1:SetTarget(c55461064.atktg)
	e1:SetOperation(c55461064.atkop)
	c:RegisterEffect(e1)
end
function c55461064.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and aux.dscon(e,tp,eg,ep,ev,re,r,rp)
end
function c55461064.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c55461064.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xc008)
end
function c55461064.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55461064.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c55461064.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c55461064.filter,tp,LOCATION_MZONE,0,nil)
	-- 新增变量声明
	local fid=e:GetHandler():GetFieldID()
	local elast = nil
	local count = 0
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetOwnerPlayer(tp)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(800)
			-- RegisterEffect前插入
			e1:SetLabelObject(elast or g)
			elast = e1
			e1:SetLabel(count)
			count = count + 1
			tc:RegisterEffect(e1)
			-- 最后一个RegisterEffect后插入FlagEffect
			tc:RegisterFlagEffect(55461064,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
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
		e_reset:SetCondition(c55461064.descon)
		e_reset:SetOperation(c55461064.rstop)
		Duel.RegisterEffect(e_reset,tp)
	end
end

function c55461064.desfilter(c,fid)
	return c:GetFlagEffectLabel(55461064)==fid
end

function c55461064.descon(e,tp,eg,ep,ev,re,r,rp)
	local g = e:GetLabelObject()
	while g:GetLabel() ~= 0 do
		g = g:GetLabelObject()
	end
	g = g:GetLabelObject()
	if not g:IsExists(c55461064.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end

function c55461064.rstop(e,tp,eg,ep,ev,re,r,rp)
	local sg = e:GetLabelObject()
	while sg:GetLabel() ~= 0 do
		sg = sg:GetLabelObject()
	end
	sg = sg:GetLabelObject()
	local dg=sg:Filter(c55461064.desfilter,nil,e:GetLabel())
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
