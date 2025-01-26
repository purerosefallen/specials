--スターダスト・シャオロン
---@param c Card
function c68543408.initial_effect(c)
	aux.AddCodeList(c,21159309,44508094)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,68543408)
	e1:SetCost(c68543408.cost)
	e1:SetTarget(c68543408.target)
	e1:SetOperation(c68543408.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,8706702)
	e2:SetCondition(c68543408.thcon)
	e2:SetTarget(c68543408.thtg)
	e2:SetOperation(c68543408.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(c68543408.valcon)
	c:RegisterEffect(e3)
end
function c68543408.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c68543408.filter(c)
	return (c:IsCode(21159309) or c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT)) and not c:IsCode(68543408) and c:IsAbleToHand()
end
function c68543408.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c68543408.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c68543408.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c68543408.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c68543408.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c68543408.cfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsSummonPlayer(tp)
end
function c68543408.ccfilter(c,tp)
	return (c:IsSetCard(44508094) or aux.IsCodeListed(c,44508094)) and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsSummonPlayer(tp)
end
function c68543408.thcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c68543408.ccfilter,1,nil,tp) then e:SetLabel(100) else e:SetLabel(0) end
	return eg:IsExists(c68543408.cfilter,1,nil,tp)
end
function c68543408.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c68543408.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if aux.NecroValleyNegateCheck(c) then return end
	if not aux.NecroValleyFilter()(c) then return end
	local b1=c:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetLabel()==100
	local op=aux.SelectFromOptions(tp,{b1,1190},{b2,1152})
	if op==1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
	if op==2 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c68543408.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end