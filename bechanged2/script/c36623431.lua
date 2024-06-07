--コアキメイルの鋼核
function c36623431.initial_effect(c) 
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCondition(c36623431.condition)
	e1:SetTarget(c36623431.thtg)
	e1:SetOperation(c36623431.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCost(c36623431.cost)
	e2:SetTarget(c36623431.thtg)
	e2:SetOperation(c36623431.thop)
	c:RegisterEffect(e2)
end
function c36623431.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end 
function c36623431.costfilter(c)
	return c:IsSetCard(0x1d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c36623431.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36623431.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c36623431.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST) 
end
function c36623431.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c36623431.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
