--ハンドレス・フェイク
function c40555959.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c40555959.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(40555959,0))
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c40555959.remcon)
	e2:SetTarget(c40555959.remtg)
	e2:SetOperation(c40555959.remop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40555959,5))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(c40555959.actcon)
	c:RegisterEffect(e3)
end
function c40555959.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil,tp,POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(c40555959.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(40555959,1)) then
		c40555959.remop(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():RegisterFlagEffect(40555959,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(40555959,2))
	end
end
function c40555959.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb)
end
function c40555959.remcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40555959.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c40555959.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(40555959)==0
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil,tp,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	e:GetHandler():RegisterFlagEffect(40555959,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c40555959.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil,tp,POS_FACEDOWN)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
		e1:SetCountLimit(1)
		e1:SetLabel(c40555959.counter)
		e1:SetCondition(c40555959.retcon)
		e1:SetOperation(c40555959.retop)
		e1:SetLabelObject(g)
		Duel.RegisterEffect(e1,tp)
		g:KeepAlive()
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(40555959,RESET_EVENT+RESETS_STANDARD,0,1)
			tc=g:GetNext()
		end
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_DRAW)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTargetRange(0,1)
	Duel.RegisterEffect(e3,tp)
end
function c40555959.retfilter(c)
	return c:GetFlagEffect(40555959)~=0
end
function c40555959.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c40555959.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c40555959.retfilter,nil)
	g:DeleteGroup()
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c40555959.actcon(e)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsSetCard),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,0xb)
end