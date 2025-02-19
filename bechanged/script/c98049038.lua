--隐形机人
function c98049038.initial_effect(c)
	-----spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98049038,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98049038)
	e1:SetCost(c98049038.spcost1)
	e1:SetTarget(c98049038.sptg1)
	e1:SetOperation(c98049038.spop1)
	c:RegisterEffect(e1)
	-----tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98049038,1))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,98049039)
	e2:SetTarget(c98049038.thtg2)
	e2:SetOperation(c98049038.thop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	-------Des
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98049038,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetCountLimit(1,98049040)
	e4:SetTarget(c98049038.destg)
	e4:SetOperation(c98049038.desop)
	c:RegisterEffect(e4)
end


-------1
function c98049038.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION) and c:IsAbleToGraveAsCost()
end
function c98049038.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98049038.costfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98049038.costfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98049038.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98049038.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end

end


--------2
function c98049038.spfilter2(c,fc)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsAbleToHand()
end
function c98049038.gfilter2(c)
	return c:IsSetCard(0x1016) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION)and Duel.IsExistingMatchingCard(c98049038.spfilter2,c:GetOwner(),LOCATION_DECK,0,1,nil,c)
end
function c98049038.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(tp) and c98049038.gfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98049038.gfilter2,tp,(LOCATION_GRAVE+LOCATION_MZONE),0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	local g1=Duel.SelectTarget(tp,c98049038.gfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
end
function c98049038.thop2(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetFirstTarget()
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98049038.spfilter2,tp,LOCATION_DECK,0,1,1,nil,fc)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


--------4
function c98049038.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98049038.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT) end
end



