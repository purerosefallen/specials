--冥王の咆哮
---@param c Card
function c41925941.initial_effect(c)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_DAMAGE_CAL)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c41925941.condition)
	e1:SetCost(c41925941.cost)
	e1:SetTarget(c41925941.target)
	e1:SetOperation(c41925941.operation)
	c:RegisterEffect(e1)
end
function c41925941.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase~=PHASE_DAMAGE and phase~=PHASE_DAMAGE_CAL) or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(tp) then
		e:SetLabelObject(d)
		return a:IsFaceup() and a:IsRace(RACE_FIEND) and a:IsRelateToBattle()
			and d and d:IsFaceup() and d:IsRelateToBattle()
	elseif d and d:IsControler(tp) then
		e:SetLabelObject(a)
		return d:IsFaceup() and d:IsRace(RACE_FIEND) and d:IsRelateToBattle()
			and a and a:IsFaceup() and a:IsRelateToBattle()
	end
end
function c41925941.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if chk==0 then return Duel.CheckLPCost(tp,100,true) and (bc:IsAttackAbove(100) or bc:IsDefenseAbove(100)) end
	local maxc=Duel.GetLP(tp)
	local maxpay=bc:GetAttack()
	local def=bc:GetDefense()
	if maxpay<def then maxpay=def end
	if maxpay<maxc then maxc=maxpay end
	if maxc>25500 then maxc=25500 end
	maxc=math.floor(maxc/100)*100
	local t={}
	for i=1,maxc/100 do
		t[i]=i*100
	end
	local cost=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,cost,true)
	e:SetLabel(cost)
end
function c41925941.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return true end
	Duel.SetTargetCard(tc)
end
function c41925941.operation(e,tp,eg,ep,ev,re,r,rp)
	local elast = nil
	local bc=Duel.GetFirstTarget()
	local val=e:GetLabel()
	if not bc or not bc:IsRelateToEffect(e) or not bc:IsControler(1-tp) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetLabelObject(elast)
	elast=e1
	bc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetLabelObject(elast)
	elast=e2
	bc:RegisterEffect(e2)
	if not bc:IsImmuneToEffect(e) then
		local e_reset=Effect.CreateEffect(e:GetHandler())
		e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e_reset:SetCode(EVENT_PHASE+PHASE_END)
		e_reset:SetReset(RESET_PHASE+PHASE_END)
		e_reset:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e_reset:SetCountLimit(1)
		e_reset:SetLabelObject(elast)
		e_reset:SetCondition(c41925941.rstcon)
		e_reset:SetOperation(c41925941.rstop)
		Duel.RegisterEffect(e_reset,tp)
	end
end
function c41925941.rstcon(e,tp,eg,ep,ev,re,r,rp)
    local ecur = e:GetLabelObject()
    local tc = ecur:GetHandler()
    return tc:GetLocation() == LOCATION_MZONE and tc:GetPosition()&POS_FACEUP ~= 0
end
function c41925941.rstop(e,tp,eg,ep,ev,re,r,rp)
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