--パワー・ウォール
function c76403456.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN))
	e1:SetCondition(c76403456.condition)
	e1:SetTarget(c76403456.target)
	e1:SetOperation(c76403456.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c76403456.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetAttacker():IsControler(1-tp) and ((e:GetHandler():IsLocation(LOCATION_HAND) and Duel.GetTurnPlayer()==1-tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)) or not e:GetHandler():IsLocation(LOCATION_HAND))
end
function c76403456.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=math.ceil(Duel.GetBattleDamage(tp)/500)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,val)
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_AVOID_BATTLE_DAMAGE) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,0)
end
function c76403456.activate(e,tp,eg,ep,ev,re,r,rp)
	local val=math.ceil(Duel.GetBattleDamage(tp)/500)
	Duel.DiscardDeck(tp,val,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<val then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
