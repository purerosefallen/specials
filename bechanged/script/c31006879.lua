--ライディング・デュエル！アクセラレーション！
---@param c Card
function c31006879.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,31006879+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c31006879.target)
	e1:SetOperation(c31006879.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c31006879.ctcon)
	e2:SetTarget(c31006879.cttg)
	e2:SetOperation(c31006879.ctop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c31006879.drcost)
	e3:SetTarget(c31006879.drtg)
	e3:SetOperation(c31006879.drop)
	c:RegisterEffect(e3)
end
function c31006879.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function c31006879.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1017) and c:IsAbleToHand()
end
function c31006879.acfilter(c,tp)
	return c:IsCode(36742774,1003840) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c31006879.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then
		if Duel.IsExistingMatchingCard(c31006879.acfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(31006879,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
			local g=Duel.SelectMatchingCard(tp,c31006879.acfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
			Duel.ResetFlagEffect(tp,15248873)
			local tc=g:GetFirst()
			if tc then
				local te=tc:GetActivateEffect()
				local b1=tc:IsAbleToHand()
				if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
				local b2=te:IsActivatable(tp,true,true)
				Duel.ResetFlagEffect(tp,15248873)
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				te:UseCountLimit(tp,1,true)
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			end
		end
	else
		local g=Duel.GetMatchingGroup(c31006879.filter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(31006879,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c31006879.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c31006879.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x104d)
end
function c31006879.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x104d,1)
end
function c31006879.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x104d,2,REASON_COST)
		and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.RemoveCounter(tp,1,0,0x104d,2,REASON_COST)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c31006879.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c31006879.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.DiscardHand(p,nil,1,1,REASON_EFFECT)
	end
end
