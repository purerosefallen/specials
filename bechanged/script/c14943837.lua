--デブリ・ドラゴン
---@param c Card
function c14943837.initial_effect(c)
	aux.AddCodeList(c,44508094)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c14943837.synlimit)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14943837,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,14943837)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c14943837.sptg)
	e2:SetOperation(c14943837.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(14943837,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,14943838)
	e5:SetTarget(c14943837.sumtg)
	e5:SetOperation(c14943837.sumop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetCountLimit(1,14943839)
	e6:SetCondition(c14943837.thcon)
	e6:SetTarget(c14943837.thtg)
	e6:SetOperation(c14943837.thop)
	c:RegisterEffect(e6)
	if not c14943837.global_check then
		c14943837.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c14943837.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c14943837.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_SYNCHRO) then
		Duel.RegisterFlagEffect(rp,14943837,RESET_PHASE+PHASE_END,0,1)
	end
end
function c14943837.tgfilter(c)
	return (c:IsSetCard(0xa3) or aux.IsCodeListed(c,44508094)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c14943837.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14943837.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c14943837.filter(c)
	return aux.IsCodeListed(c,44508094) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c14943837.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c14943837.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0
		and g:GetFirst():IsPreviousLocation(LOCATION_HAND)
		and Duel.IsExistingMatchingCard(c14943837.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(14943837,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c14943837.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c14943837.synlimit(e,c)
	if not c then return false end
	return not (c:IsRace(RACE_DRAGON) and c:IsLevel(7,8) or c:IsSetCard(0xc2))
end
function c14943837.filter2(c,e,sp)
	return c:IsAttackBelow(500) and c:IsCanBeSpecialSummoned(e,0,sp,false,false,POS_FACEUP)
end
function c14943837.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c14943837.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c14943837.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c14943837.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c14943837.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.ResetFlagEffect(tp,14943837)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c14943837.discon)
	e1:SetValue(c14943837.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c14943837.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function c14943837.discon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,14943837)==0
end
function c14943837.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c14943837.thfilter2(c)
	return c:IsSetCard(0x1017) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c14943837.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14943837.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14943837.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c14943837.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end