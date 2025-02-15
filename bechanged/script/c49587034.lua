--光の封札剣
---@param c Card
function c49587034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c49587034.target)
	e1:SetOperation(c49587034.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51858306,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c49587034.thtg)
	e2:SetOperation(c49587034.thop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10045474,0))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c49587034.handcon)
	c:RegisterEffect(e3)
	if not c49587034.global_check then
		c49587034.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c49587034.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c49587034.checkop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if ep==1-tp and re:IsActiveType(TYPE_MONSTER) and (LOCATION_HAND)&loc~=0 then
		Duel.RegisterFlagEffect(ep,49587034,RESET_PHASE+PHASE_END,0,1)
	end
end
function c49587034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil,tp,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c49587034.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	local rs=g:RandomSelect(1-tp,1)
	local card=rs:GetFirst()
	if card==nil then return end
	if Duel.Remove(card,POS_FACEDOWN,REASON_EFFECT)>0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local ph=Duel.GetCurrentPhase()
		local cp=Duel.GetTurnPlayer()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,4)
		e1:SetCondition(c49587034.thcon)
		e1:SetOperation(c49587034.thop)
		e1:SetLabel(1)
		card:RegisterEffect(e1)
		e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,3)
		e:GetHandler():RegisterFlagEffect(49587034,RESET_EVENT+0x1e60000,0,1)
		c49587034[e:GetHandler()]=e1
		e:SetLabelObject(tc)
	end
end
function c49587034.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c49587034.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetOwner():SetTurnCounter(ct)
	if ct==4 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		e:GetOwner():ResetFlagEffect(1082946)
	else
		e:SetLabel(ct+1)
	end
end
function c49587034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject():GetLabelObject()
	if chk==0 then return tc and tc:GetFlagEffect(49587034)~=0 and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c49587034.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	if tc:GetFlagEffect(49587034)~=0 and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c49587034.handcon(e)
	return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),49587034)
end