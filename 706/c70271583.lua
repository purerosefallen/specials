--カラクリ守衛 参壱参
function c70271583.initial_effect(c)
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e1)
	--pos change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70271583,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetOperation(c70271583.posop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(70271583,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c70271583.atkcon)
	e4:SetOperation(c70271583.atkop)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetCondition(c70271583.indcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c70271583.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
function c70271583.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and (e:GetHandler()==Duel.GetAttacker() or e:GetHandler()==Duel.GetAttackTarget())
end
function c70271583.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x11)
end
function c70271583.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=e:GetHandler():GetFieldID()
	local elast = nil
	local count = 0
	local g=Duel.GetMatchingGroup(c70271583.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(800)
			e1:SetLabelObject(elast or g)
			elast = e1
			e1:SetLabel(count)
			count = count + 1
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetLabelObject(elast or g)
			elast = e2
			e2:SetLabel(count)
			count = count + 1
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(70271583,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
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
		e_reset:SetCondition(c70271583.descon)
		e_reset:SetOperation(c70271583.rstop)
		Duel.RegisterEffect(e_reset,tp)
	end
end

function c70271583.desfilter(c,fid)
	return c:GetFlagEffectLabel(70271583)==fid
end

function c70271583.descon(e,tp,eg,ep,ev,re,r,rp)
	local g = e:GetLabelObject()
	while g:GetLabel() ~= 0 do
		g = g:GetLabelObject()
	end
	g = g:GetLabelObject()
	if not g:IsExists(c70271583.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end

function c70271583.rstop(e,tp,eg,ep,ev,re,r,rp)
	local sg = e:GetLabelObject()
	while sg:GetLabel() ~= 0 do
		sg = sg:GetLabelObject()
	end
	sg = sg:GetLabelObject()
	local dg=sg:Filter(c70271583.desfilter,nil,e:GetLabel())
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
function c70271583.indcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
