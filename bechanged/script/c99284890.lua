--壺魔神
---@param c Card
function c99284890.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c99284890.cost1)
	e1:SetOperation(c99284890.operation1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c99284890.cost)
	e2:SetTarget(c99284890.target)
	e2:SetOperation(c99284890.operation)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c99284890.spcon)
	e3:SetCost(c99284890.spcost)
	e3:SetTarget(c99284890.sptg)
	e3:SetOperation(c99284890.spop)
	c:RegisterEffect(e3)
end
function c99284890.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c99284890.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c99284890.drcon1)
	e1:SetOperation(c99284890.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c99284890.regcon)
	e2:SetOperation(c99284890.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c99284890.drcon2)
	e3:SetOperation(c99284890.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c99284890.cfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c99284890.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99284890.cfilter,1,nil,tp) and not Duel.IsChainSolving()
end
function c99284890.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,99284890)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,99284890+1,0,0,0)
end
function c99284890.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99284890.cfilter,1,nil,tp) and Duel.IsChainSolving()
end
function c99284890.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,99284890,RESET_CHAIN,0,1)
end
function c99284890.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99284890)>0
end
function c99284890.drop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,99284890)
	Duel.ResetFlagEffect(tp,99284890)
	Duel.Hint(HINT_CARD,0,99284890)
	Duel.Draw(tp,ct,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,99284890+1,0,0,0)
end
function c99284890.filter(c)
	return c:IsCode(55144522) and c:IsAbleToGraveAsCost()
end
function c99284890.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99284890.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c99284890.filter,1,1,REASON_COST)
end
function c99284890.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c99284890.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,99284890+1,0,0,0)
	Duel.RegisterFlagEffect(tp,99284890+1,0,0,0)
	Duel.RegisterFlagEffect(tp,99284890+1,0,0,0)
end
function c99284890.rfilter(c)
	return c:IsCode(55144522) and c:IsAbleToRemoveAsCost()
end
function c99284890.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99284890+1)>=3
end
function c99284890.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99284890.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c99284890.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99284890.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99284890.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end