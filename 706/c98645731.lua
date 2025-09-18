--強欲で謙虚な壺
function c98645731.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98645731+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c98645731.cost)
	e1:SetTarget(c98645731.target)
	e1:SetOperation(c98645731.activate)
	c:RegisterEffect(e1)
	if not c98645731.global_check then
		c98645731.global_check=true
		c98645731[0]=false
		c98645731[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_NEGATED)
		ge1:SetOperation(c98645731.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetOperation(c98645731.checkop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_NEGATED)
		ge3:SetOperation(c98645731.checkop3)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_TURN_END)
		ge4:SetOperation(c98645731.clear)
		Duel.RegisterEffect(ge4,0)
	end
end
function c98645731.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local turnp=Duel.GetTurnPlayer()
	c98645731[turnp]=tc:IsControler(turnp)
end
function c98645731.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local ex=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	if ex and rp==turnp then
		c98645731[turnp]=true
	end
end
function c98645731.checkop3(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local ex=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	if ex and rp==turnp then
		c98645731[turnp]=false
	end
end
function c98645731.clear(e,tp,eg,ep,ev,re,r,rp)
	c98645731[0]=false
	c98645731[1]=false
end
function c98645731.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local turnp=Duel.GetTurnPlayer()
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and not c98645731[turnp] end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c98645731.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c98645731.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(p)
	end
end