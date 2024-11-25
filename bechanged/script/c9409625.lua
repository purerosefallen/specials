--虚無械アイン
function c9409625.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9409625,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c9409625.drcost)
	e3:SetTarget(c9409625.drtg)
	e3:SetOperation(c9409625.drop)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9409625,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c9409625.cost)
	e4:SetTarget(c9409625.tdtg)
	e4:SetOperation(c9409625.tdop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9409625,3))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCondition(c9409625.handcon)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c9409625.drcon1)
	e6:SetOperation(c9409625.drop1)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(c9409625.regcon)
	e7:SetOperation(c9409625.regop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e8:SetCode(EVENT_CHAIN_SOLVED)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCondition(c9409625.drcon2)
	e8:SetOperation(c9409625.drop2)
	c:RegisterEffect(e8)
end
function c9409625.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetHandlerPlayer()
end
function c9409625.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(9409625)==0 end
	c:RegisterFlagEffect(9409625,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c9409625.drfilter(c)
	return c:IsLevel(10) and c:IsDiscardable()
end
function c9409625.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9409625.drfilter,tp,LOCATION_HAND,0,1,nil)
		and c9409625.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.DiscardHand(tp,c9409625.drfilter,1,1,REASON_COST+REASON_DISCARD)
	c9409625.cost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c9409625.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9409625.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9409625.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c9409625.setfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_ONFIELD,0,1,nil,36894320,72883039) and g:GetCount()>0 end
end
function c9409625.setfilter(c)
	return c:IsCode(36894320,72883039) and c:IsSSetable()
end
function c9409625.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9409625.setfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,sc)
	end
end
function c9409625.acop(c)
	return c:IsFaceup() and c:IsCode(36894320,72883039)
end
function c9409625.handcon(e,c)
	return Duel.IsExistingMatchingCard(c9409625.acop,e:GetHandler(),LOCATION_ONFIELD,0,1,nil)
end
function c9409625.filter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9409625.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9409625.filter,1,nil,1-tp)
		and not Duel.IsChainSolving()
end
function c9409625.drop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(aux.AND(Card.IsFaceup,Card.IsType),tp,0,LOCATION_MZONE,nil,TYPE_SYNCHRO)*2
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function c9409625.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9409625.filter,1,nil,1-tp)
		and Duel.IsChainSolving()
end
function c9409625.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(aux.AND(Card.IsFaceup,Card.IsType),tp,0,LOCATION_MZONE,nil,TYPE_SYNCHRO)*2
	while ct>0 do
		Duel.RegisterFlagEffect(tp,9409625,RESET_CHAIN,0,1)
		ct=ct-1
	end
end
function c9409625.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9409625)>0
end
function c9409625.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,9409625)
	Duel.ResetFlagEffect(tp,9409625)
	Duel.Draw(tp,n,REASON_EFFECT)
end