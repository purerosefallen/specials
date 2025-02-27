--星なる影 ゲニウス
---@param c Card
function c66675911.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66675911,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,66675911)
	e1:SetCost(c66675911.cost)
	e1:SetTarget(c66675911.target)
	e1:SetOperation(c66675911.operation)
	c:RegisterEffect(e1)
	local e12=e1:Clone()
	e12:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66675911,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,66675911)
	e2:SetCost(c66675911.cost)
	e2:SetCondition(c66675911.actcon)
	e2:SetTarget(c66675911.acttg)
	e2:SetOperation(c66675911.actop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,66675911+2)
	e3:SetCondition(c66675911.con1)
	e3:SetTarget(c66675911.tg)
	e3:SetOperation(c66675911.op)
	c:RegisterEffect(e3)
	local e33=e3:Clone()
	e33:SetType(EFFECT_TYPE_QUICK_O)
	e33:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e33:SetCode(EVENT_FREE_CHAIN)
	e33:SetCondition(c66675911.con2)
	c:RegisterEffect(e33)
end
function c66675911.ccfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x9d)
end
function c66675911.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c66675911.ccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c66675911.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66675911.ccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c66675911.tarfilter(c,e,tp,ec)
	return (c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ec:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE))
		or (c:IsFacedown() and c:IsCanChangePosition() and ec:IsAbleToGrave())
end
function c66675911.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66675911.tarfilter(chkc,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(c66675911.tarfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c66675911.tarfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,c):GetFirst()
	if tc:IsFaceup() then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	end
	if tc:IsFacedown() then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
	end
end
function c66675911.op(e,tp,eg,ep,ev,re,r,rp)
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
function c66675911.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c66675911.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9d)
end
function c66675911.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66675911.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66675911.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c66675911.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c66675911.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c66675911.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
	end
end
function c66675911.efilter(e,re)
	return e:GetHandler()~=re:GetOwner() and re:IsActiveType(TYPE_MONSTER)
end
function c66675911.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c66675911.actfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c66675911.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66675911.actfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66675911.actfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66675911.actfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c66675911.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1,true)
	end
end
