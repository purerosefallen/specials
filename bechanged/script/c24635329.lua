--聖なる影 ケイウス
---@param c Card
function c24635329.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24635329,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,24635329)
	e1:SetTarget(c24635329.target)
	e1:SetOperation(c24635329.operation)
	c:RegisterEffect(e1)
	local e12=e1:Clone()
	e12:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24635329,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,24635329+1)
	e2:SetCondition(c24635329.tgcon)
	e2:SetTarget(c24635329.tgtg)
	e2:SetOperation(c24635329.tgop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,24635329+2)
	e3:SetCondition(c24635329.con1)
	e3:SetTarget(c24635329.tg)
	e3:SetOperation(c24635329.op)
	c:RegisterEffect(e3)
	local e33=e3:Clone()
	e33:SetType(EFFECT_TYPE_QUICK_O)
	e33:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e33:SetCode(EVENT_FREE_CHAIN)
	e33:SetCondition(c24635329.con2)
	c:RegisterEffect(e33)
end
function c24635329.ccfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x9d)
end
function c24635329.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c24635329.ccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c24635329.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24635329.ccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c24635329.tarfilter(c,e,tp,ec)
	return (c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ec:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE))
		or (c:IsFacedown() and c:IsCanChangePosition() and ec:IsAbleToGrave())
end
function c24635329.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c24635329.tarfilter(chkc,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(c24635329.tarfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c24635329.tarfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,c):GetFirst()
	if tc:IsFaceup() then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	end
	if tc:IsFacedown() then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
	end
end
function c24635329.op(e,tp,eg,ep,ev,re,r,rp)
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
function c24635329.filter(c,e,tp)
	return c:IsSetCard(0x9d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE)
end
function c24635329.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c24635329.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c24635329.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c24635329.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_DEFENSE)~=0 and tc:IsFacedown() then
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c24635329.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c24635329.tgfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c24635329.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24635329.tgfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c24635329.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c24635329.tgfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local lv=tc:GetOriginalLevel()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(lv*100)
		e1:SetTargetRange(LOCATION_MZONE,0)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetValue(-lv*100)
		e3:SetTargetRange(0,LOCATION_MZONE)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_UPDATE_DEFENSE)
		Duel.RegisterEffect(e4,tp)
	end
end
