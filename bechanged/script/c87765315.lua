--真竜の目覚め
function c87765315.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,87765315)
	e1:SetTarget(c87765315.target)
	e1:SetOperation(c87765315.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87765315,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c87765315.ccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c87765315.thtg)
	e2:SetOperation(c87765315.thop)
	c:RegisterEffect(e2)
end
function c87765315.thfilter(c)
	return c:IsSetCard(0xf9) and c:IsAbleToHand()
end
function c87765315.gcheck(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)==1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)==1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)==1
end
function c87765315.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c87765315.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.AND(Card.IsSetCard,Card.IsFaceupEx),tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),0xf9)
		and g:CheckSubGroup(c87765315.gcheck,3,3,tp) end
	local sg=Duel.GetMatchingGroup(aux.AND(Card.IsSetCard,Card.IsFaceupEx),tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler(),0xf9)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c87765315.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.AND(Card.IsSetCard,Card.IsFaceupEx),tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e),0xf9)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local sg=Duel.GetMatchingGroup(c87765315.thfilter,tp,LOCATION_DECK,0,nil)
		if #sg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local ssg=sg:SelectSubGroup(tp,c87765315.gcheck,false,3,3)
			if ssg then
				Duel.SendtoHand(ssg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,ssg)
			end
		end
	end
end
function c87765315.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xda)
end
function c87765315.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xc7) and not c:IsType(TYPE_PENDULUM)
end
function c87765315.filter3(c,e,tp)
	return c:IsSetCard(0xda,0xc7) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c87765315.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c87765315.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c87765315.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c87765315.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c87765315.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c87765315.filter3,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(87765315,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c87765315.filter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
