--卡车机人
function c61538782.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(61538782,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,61538782)
	e1:SetCondition(c61538782.thcon)
	e1:SetTarget(c61538782.thtg)
	e1:SetOperation(c61538782.thop)
	c:RegisterEffect(e1)
	-----zhongkaizhuang
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(61538782,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,61538783)
	e2:SetTarget(c61538782.eqtg)
	e2:SetOperation(c61538782.eqop)
	c:RegisterEffect(e2)
end

-----------1
function c61538782.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
		and e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function c61538782.filter(c)
	return c:IsSetCard(0x16) and c:IsType(TYPE_MONSTER) and not c:IsCode(61538782) and c:IsAbleToHand()
end
function c61538782.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61538782.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c61538782.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c61538782.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

----------2

function c61538782.tgfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x16) and c:IsRace(RACE_MACHINE) and Duel.IsExistingMatchingCard(c61538782.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c61538782.eqfilter(c,tp)
	return c:IsFaceup() and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c61538782.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c61538782.tgfilter(chkc,tp) end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		return ft>0 and Duel.IsExistingTarget(c61538782.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c61538782.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c61538782.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc,tp):GetFirst()
	if ec and Duel.Equip(tp,ec,tc)then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetLabelObject(tc)
		e1:SetValue(c61538782.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
		--
		local e2=Effect.CreateEffect(ec)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(ec:GetAttack())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2,true)
	end
end
function c61538782.eqlimit(e,c)
	return c==e:GetLabelObject()
end

