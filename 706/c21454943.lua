--??????????????---@param c Card
function c21454943.initial_effect(c)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(21454943,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c21454943.condition)
	e1:SetCost(c21454943.cost)
	e1:SetTarget(c21454943.target)
	e1:SetOperation(c21454943.operation)
	c:RegisterEffect(e1)
end
function c21454943.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(tp) then
		e:SetLabelObject(d)
		return a:IsFaceup() and a:IsRace(RACE_PSYCHO) and a:IsRelateToBattle() and d and d:IsFaceup() and d:IsRelateToBattle()
	else
		e:SetLabelObject(a)
		return d and d:IsFaceup() and d:IsRace(RACE_PSYCHO) and d:IsRelateToBattle() and a and a:IsFaceup() and a:IsRelateToBattle()
	end
end
function c21454943.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if chk==0 then return Duel.CheckLPCost(tp,100,true) and e:GetHandler():GetFlagEffect(21454943)==0
						and (bc:IsAttackAbove(100) or bc:IsDefenseAbove(100)) end
	local lp=Duel.GetLP(tp)-1
	local alp=100
	local maxpay=bc:GetAttack()
	local def=bc:GetDefense()
	if maxpay<def then maxpay=def end
	if maxpay<lp then lp=maxpay end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21454943,1))
	if lp>=500 then alp=Duel.AnnounceNumber(tp,100,200,300,400,500)
	elseif lp>=400 then alp=Duel.AnnounceNumber(tp,100,200,300,400)
	elseif lp>=300 then alp=Duel.AnnounceNumber(tp,100,200,300)
	elseif lp>=200 then alp=Duel.AnnounceNumber(tp,100,200)
	end
	Duel.PayLPCost(tp,alp,true)
	e:SetLabel(alp)
	e:GetHandler():RegisterFlagEffect(21454943,RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c21454943.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=e:GetLabelObject()
	if chkc then return chkc==tc end
	if chk==0 then return tc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tc)
end
function c21454943.operation(e,tp,eg,ep,ev,re,r,rp)
	local elast = nil
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc or not tc:IsRelateToEffect(e) or not tc:IsControler(1-tp) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(-e:GetLabel())
	e1:SetLabelObject(elast)
	elast=e1
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
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
		e_reset:SetCondition(c21454943.rstcon)
		e_reset:SetOperation(c21454943.rstop)
		Duel.RegisterEffect(e_reset,tp)
	end
end
function c21454943.rstcon(e,tp,eg,ep,ev,re,r,rp)
    local ecur = e:GetLabelObject()
    local tc = ecur:GetHandler()
    return tc:GetLocation() == LOCATION_MZONE and tc:GetPosition()&POS_FACEUP ~= 0
end
function c21454943.rstop(e,tp,eg,ep,ev,re,r,rp)
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