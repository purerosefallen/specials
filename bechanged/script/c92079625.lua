--影依の炎核 ヴォイド
---@param c Card
function c92079625.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92079625,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,92079625)
	e1:SetTarget(c92079625.target)
	e1:SetOperation(c92079625.operation)
	c:RegisterEffect(e1)
	local e12=e1:Clone()
	e12:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
	--SendtoGrave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92079625,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,92079625)
	e2:SetCondition(c92079625.tgcon)
	e2:SetTarget(c92079625.tgtg)
	e2:SetOperation(c92079625.tgop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,92079625+2)
	e3:SetCondition(c92079625.con1)
	e3:SetTarget(c92079625.tg)
	e3:SetOperation(c92079625.op)
	c:RegisterEffect(e3)
	local e33=e3:Clone()
	e33:SetType(EFFECT_TYPE_QUICK_O)
	e33:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e33:SetCode(EVENT_FREE_CHAIN)
	e33:SetCondition(c92079625.con2)
	c:RegisterEffect(e33)
end
function c92079625.ccfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x9d)
end
function c92079625.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c92079625.ccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c92079625.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c92079625.ccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c92079625.tarfilter(c,e,tp,ec)
	return (c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ec:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE))
		or (c:IsFacedown() and c:IsCanChangePosition() and ec:IsAbleToGrave())
end
function c92079625.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c92079625.tarfilter(chkc,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(c92079625.tarfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c92079625.tarfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,c):GetFirst()
	if tc:IsFaceup() then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	end
	if tc:IsFacedown() then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
	end
end
function c92079625.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsFaceup() then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		elseif tc:IsFacedown() then
			if Duel.SendtoGrave(c,0x40) and c:IsLocation(LOCATION_GRAVE) then
				Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
			end
		end
	end
end
function c92079625.cfilter(c,tp)
	return c:IsFaceup()
		and Duel.IsExistingMatchingCard(c92079625.tgfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c92079625.tgfilter(c,att)
	return c:IsAbleToGrave() and c:IsAttribute(att) and c:IsSetCard(0x9d,0x1047)
end
function c92079625.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c92079625.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c92079625.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c92079625.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c92079625.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local att=tc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c92079625.tgfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,att)
		if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
			if tc:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(92079625,0)) then
				Duel.BreakEffect()
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function c92079625.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c92079625.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetClassCount(Card.GetOriginalAttribute)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c92079625.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetClassCount(Card.GetOriginalAttribute)
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
end
