--女忍者ヤエ
---@param c Card
function c82005435.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82005435,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82005435)
	e1:SetCost(c82005435.cost)
	e1:SetTarget(c82005435.target)
	e1:SetOperation(c82005435.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82005435,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,82005435+1)
	e2:SetCost(c82005435.spcost)
	e2:SetTarget(c82005435.sptg2)
	e2:SetOperation(c82005435.spop2)
	c:RegisterEffect(e2)
end
function c82005435.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c82005435.filter(c,e,tp)
	return c:IsSetCard(0x2b) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82005435.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82005435.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c82005435.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c82005435.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c82005435.costfilter(c)
	return c:IsType(0x1) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c82005435.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82005435.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=Duel.SelectMatchingCard(tp,c82005435.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(cg,REASON_COST+REASON_DISCARD)
end
function c82005435.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c82005435.filter2(c)
	return c:IsSetCard(0x61) and c:IsFaceup() and c:IsAbleToHand()
end
function c82005435.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82005435.filter1,tp,0,LOCATION_ONFIELD,1,nil)
		or Duel.IsExistingMatchingCard(c82005435.filter2,tp,LOCATION_ONFIELD,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c82005435.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82005435.filter1,tp,0,LOCATION_ONFIELD,nil)
	local sg2=Duel.GetMatchingGroup(c82005435.filter2,tp,LOCATION_ONFIELD,0,nil)
	if #sg>0 and #sg2<=0 then
		s=Duel.SelectOption(tp,aux.Stringid(82005435,1))
	end
	if #sg<=0 and #sg2>0 then
		s=Duel.SelectOption(tp,aux.Stringid(82005435,2))+1
	end
	if #sg>0 and #sg2>0 then
		s=Duel.SelectOption(tp,aux.Stringid(82005435,1),aux.Stringid(82005435,2))
	end
	if s==0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	elseif s==1 then
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
	end
end
