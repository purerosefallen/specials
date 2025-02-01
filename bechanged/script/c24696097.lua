--シューティング・スター・ドラゴン
function c24696097.initial_effect(c)
	aux.AddMaterialCodeList(c,44508094)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24696097,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c24696097.mtcon)
	e1:SetOperation(c24696097.mtop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24696097,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c24696097.discon)
	e2:SetTarget(c24696097.distg)
	e2:SetOperation(c24696097.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c26268488.valcheck)
	c:RegisterEffect(e3)
	--disable attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24696097,2))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c24696097.dacon)
	e4:SetTarget(c24696097.datg)
	e4:SetOperation(c24696097.daop)
	c:RegisterEffect(e4)
	--Revive
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(24696097,3))
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetCountLimit(1)
	e5:SetCondition(c24696097.sumcon)
	e5:SetTarget(c24696097.sumtg)
	e5:SetOperation(c24696097.sumop)
	c:RegisterEffect(e5)
end
c24696097.material_type=TYPE_SYNCHRO
function c24696097.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
end
function c24696097.cfilter(c)
	return c:IsType(TYPE_TUNER) and (c:IsLocation(LOCATION_DECK) or c:IsAbleToDeck())
end
function c24696097.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(24696097,4))
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c24696097.ccfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=sg:GetFirst()
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,44508094) and tc then
		Duel.ShuffleDeck(tp)
		if tc:IsLocation(LOCATION_DECK) then
			Duel.MoveSequence(tc,SEQ_DECKTOP)
		else
			Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:FilterCount(Card.IsType,nil,TYPE_TUNER)
	Duel.ShuffleDeck(tp)
	if ct>1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct-1)
		c:RegisterEffect(e1)
	elseif ct==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c24696097.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function c24696097.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=1
	if c:GetFlagEffectLabel(24696097) then ct=c:GetFlagEffectLabel(24696097) end
	if chk==0 then return c:GetFlagEffect(24696098)<ct end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	c:RegisterFlagEffect(24696098,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c24696097.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c24696097.valcheck(e,c)
	c:RegisterFlagEffect(24696097,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,c:GetMaterialCount()-1)
end
function c24696097.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end
function c24696097.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc==Duel.GetAttacker() end
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.GetAttacker():IsCanBeEffectTarget(e)
		and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetTargetCard(Duel.GetAttacker())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c24696097.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.NegateAttack()
		c:RegisterFlagEffect(24696097,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end
function c24696097.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(24696097)>0
end
function c24696097.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24696097.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
