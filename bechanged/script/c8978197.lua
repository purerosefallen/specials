--ロード・オブ・ドラゴン－ドラゴンの統制者－
function c8978197.initial_effect(c)
	c:SetSPSummonOnce(8978197)
	--change name
	aux.EnableChangeCode(c,17985575)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8978197,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetTarget(c8978197.sptg)
	e1:SetOperation(c8978197.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8978197,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c8978197.thcost)
	e2:SetTarget(c8978197.thtg)
	e2:SetOperation(c8978197.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c8978197.tfilter(c,sc,tp)
	return c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
		and c:IsAbleToGrave() and c:IsType(TYPE_EFFECT)
end
function c8978197.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c8978197.tfilter(chkc,c,tp) end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c8978197.tfilter,tp,LOCATION_MZONE,0,1,nil,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c8978197.tfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c8978197.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_GRAVE) then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c8978197.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c8978197.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8978197.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c8978197.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c8978197.thfilter(c)
	return c:IsCode(71867500,43973174,48800175,71490127) and c:IsAbleToHand()
end
function c8978197.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c8978197.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c8978197.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c8978197.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SendtoHand(tg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg1)
	Duel.ShuffleHand(tp)
end
