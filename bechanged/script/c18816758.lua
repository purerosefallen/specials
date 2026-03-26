--侵略の波動
function c18816758.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c18816758.cost)
	e1:SetTarget(c18816758.target)
	e1:SetOperation(c18816758.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18816758,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,18816758)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c18816758.thtg)
	e2:SetOperation(c18816758.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18816758,2))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(c18816758.actcon)
	c:RegisterEffect(e3)
end
function c18816758.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa) and c:IsAbleToHandAsCost()
end
function c18816758.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18816758.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c18816758.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c18816758.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c18816758.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c18816758.thfilter(c)
	return c:IsSetCard(0x100a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c18816758.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18816758.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18816758.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c18816758.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if (tc:IsSummonable(true,nil,1) or tc:IsMSetable(true,nil,1))
			and Duel.SelectYesNo(tp,aux.Stringid(18816758,3)) then
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
function c18816758.actcon(e)
	return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end