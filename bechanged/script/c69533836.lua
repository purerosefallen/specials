--魂を刻む右
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,70902743)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.immval)
	c:RegisterEffect(e3)
	--change atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.atktg)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.atkcon2)
	e5:SetTarget(s.atktg2)
	e5:SetOperation(s.atkop2)
	c:RegisterEffect(e5)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function s.immval(e,re)
	local qc=e:GetHandler():GetEquipTarget()
	return re:IsActivated() and e:GetHandlerPlayer()~=re:GetOwnerPlayer() and qc and qc:IsCode(70902743)
end
function s.atkfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()~=atk
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local qc=c:GetEquipTarget()
	local tg=qc:IsRace(RACE_DRAGON) and qc:IsType(TYPE_SYNCHRO)
	local res1=tg and Duel.IsExistingMatchingCard(s.atkfilter,tp,0,LOCATION_MZONE,1,nil,qc:GetAttack())
	local res2=not tg and qc:IsDestructable(e) and c:IsDestructable(e)
	if chk==0 then return res1 or res2 end
	if res1 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	else
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		local g1=Group.FromCards(c,qc)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local qc=c:GetEquipTarget()
	local b=qc:IsRace(RACE_DRAGON) and qc:IsType(TYPE_SYNCHRO)
	if b and qc:IsType(TYPE_MONSTER) and qc:IsFaceup() then
		local atk=qc:GetAttack()
		local g=Duel.GetMatchingGroup(s.atkfilter,tp,0,LOCATION_MZONE,nil,atk)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	elseif not b and qc:IsDestructable(e) and c:IsDestructable(e) and qc:IsType(TYPE_MONSTER) and qc:IsFaceup() then
		local g=Group.FromCards(qc,c)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			if not c:IsLocation(LOCATION_GRAVE) or not c:IsAbleToHand() then return end
			local fid=c:GetFieldID()
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_TOHAND)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(c)
			e1:SetCondition(s.thcon)
			e1:SetOperation(s.thop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else
		return true
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if aux.NecroValleyFilter()(e:GetLabelObject()) then
		Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
	end
end
function s.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc
end
function s.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and not c:IsAttack(0)
end
function s.atktg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and s.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local qc=c:GetEquipTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local atk=tc:GetAttack()
		if qc:IsFaceup() and c:IsRelateToEffect(e) and atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			qc:RegisterEffect(e1)
		end
	end
end
