--量子猫
---@param c Card
function c87772572.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,87772572+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c87772572.target)
	e1:SetOperation(c87772572.activate)
	c:RegisterEffect(e1)
	--set1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c87772572.setcon1)
	e2:SetTarget(c87772572.settg1)
	e2:SetOperation(c87772572.setop1)
	c:RegisterEffect(e2)
	--set2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c87772572.setcon2)
	e3:SetTarget(c87772572.settg2)
	e3:SetOperation(c87772572.setop2)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c87772572.discon)
	e4:SetOperation(c87772572.disop)
	c:RegisterEffect(e4)
	--act in set turn
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(87772572,0))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCondition(c87772572.astcon)
	c:RegisterEffect(e5)
end
function c87772572.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rac=0
		local crac=1
		while bit.band(RACE_ALL,crac)~=0 do
			local catt=1
			for iatt=0,7 do
				if Duel.IsPlayerCanSpecialSummonMonster(tp,87772572,0,TYPES_EFFECT_TRAP_MONSTER,0,2200,4,crac,catt) then
					rac=rac+crac
					break
				end
				catt=catt*2
			end
			crac=crac*2
		end
		e:SetLabel(rac)
		return e:IsCostChecked()
			and rac~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local crac=Duel.AnnounceRace(tp,1,e:GetLabel())
	local att=0
	local catt=1
	for iatt=0,7 do
		if Duel.IsPlayerCanSpecialSummonMonster(tp,87772572,0,TYPES_EFFECT_TRAP_MONSTER,0,2200,4,crac,catt) then
			att=att+catt
		end
		catt=catt*2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	catt=Duel.AnnounceAttribute(tp,1,att)
	e:SetLabel(crac)
	Duel.SetTargetParam(catt)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c87772572.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rac=e:GetLabel()
	local att=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,87772572,0,TYPES_EFFECT_TRAP_MONSTER,0,2200,4,rac,att) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP,att,rac)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	local code=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_CODE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(code)
		c:RegisterEffect(e1)
	end
end
function c87772572.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c87772572.settg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanTurnSet() end
end
function c87772572.setop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c87772572.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c87772572.setfilter(c)
	return c:IsAllTypes(TYPE_CONTINUOUS|TYPE_TRAP) and c:IsSSetable()
end
function c87772572.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,0x1f00)>1 and Duel.IsExistingMatchingCard(c87772572.setfilter,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,0,1,0,0)
end
function c87772572.setop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c87772572.setfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SSet(tp,g:GetFirst())~=0 and c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c87772572.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetHandler():IsOriginalCodeRule(e:GetHandler():GetCode())
end
function c87772572.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c87772572.astcon(e)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	local tep=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER)
	return tep==1-e:GetHandlerPlayer()
end
