--侵略の侵喰崩壊
function c90934570.initial_effect(c)
	--remove & tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c90934570.target)
	e1:SetOperation(c90934570.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90934570,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,90934570)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c90934570.thtg)
	e2:SetOperation(c90934570.thop)
	c:RegisterEffect(e2)
end
function c90934570.rmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa) and c:IsAbleToRemove()
end
function c90934570.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c90934570.rmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c90934570.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,g2:GetCount(),0,0)
end
function c90934570.operation(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	if g1:GetFirst():IsRelateToEffect(e) and g1:GetFirst():IsFaceup() and Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)~=0 then
		local hg=g2:Filter(Card.IsRelateToEffect,nil,e)
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
	end
end
function c90934570.thfilter(c)
	return c:IsSetCard(0x100a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c90934570.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90934570.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c90934570.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c90934570.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if (tc:IsSummonable(true,nil,1) or tc:IsMSetable(true,nil,1))
			and Duel.SelectYesNo(tp,aux.Stringid(90934570,3)) then
			Duel.BreakEffect()
			local s1=tc:IsSummonable(true,nil,1)
			local s2=tc:IsMSetable(true,nil,1)
			if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
				Duel.Summon(tp,tc,true,nil,1)
			else
				Duel.MSet(tp,tc,true,nil,1)
			end
		end
	end
end