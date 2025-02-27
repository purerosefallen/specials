--シャドール・リザード
---@param c Card
function c30328508.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30328508,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,30328508)
	e1:SetTarget(c30328508.target)
	e1:SetOperation(c30328508.operation)
	c:RegisterEffect(e1)
	--search
	local e12=e1:Clone()
	e12:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30328508,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,30328508+1)
	e2:SetCondition(c30328508.tgcon)
	e2:SetTarget(c30328508.tgtg)
	e2:SetOperation(c30328508.tgop)
	c:RegisterEffect(e2)
end
function c30328508.ccfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x9d)
end
function c30328508.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c30328508.ccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c30328508.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c30328508.ccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c30328508.tarfilter(c,e,tp,ec)
	return (c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ec:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE))
		or (c:IsFacedown() and c:IsCanChangePosition() and ec:IsAbleToGrave())
end
function c30328508.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c30328508.tarfilter(chkc,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(c30328508.tarfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c30328508.tarfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,c):GetFirst()
	if tc:IsFaceup() then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	end
	if tc:IsFacedown() then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
	end
end
function c30328508.op(e,tp,eg,ep,ev,re,r,rp)
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
function c30328508.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c30328508.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c30328508.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c30328508.filter(c)
	return c:IsSetCard(0x9d) and not c:IsCode(30328508) and c:IsAbleToGrave()
end
function c30328508.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30328508.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c30328508.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c30328508.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
