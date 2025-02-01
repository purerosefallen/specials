--真紅眼の黒炎竜
---@param c Card
function c30079770.initial_effect(c)
	aux.EnableDualAttribute(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,30079771)
	e2:SetCost(c30079770.thcost)
	e2:SetTarget(c30079770.thtg)
	e2:SetOperation(c30079770.thop)
	c:RegisterEffect(e2)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,30079770)
	e2:SetCondition(c30079770.damcon)
	e2:SetTarget(c30079770.damtg)
	e2:SetOperation(c30079770.damop)
	c:RegisterEffect(e2)
end
function c30079770.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c30079770.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3b) and c:IsAbleToHand() and not c:IsRace(RACE_DRAGON)
end
function c30079770.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30079770.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c30079770.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c30079770.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c30079770.damcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsDualState(e) and e:GetHandler():GetBattledGroupCount()>0
end
function c30079770.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetHandler():GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c30079770.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=c:GetBaseAttack()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
