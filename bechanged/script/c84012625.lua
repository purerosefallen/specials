--シューティング・ソニック
---@param c Card
function c84012625.initial_effect(c)
	aux.AddCodeList(c,44508094)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84012625,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c84012625.target)
	e1:SetOperation(c84012625.activate)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84012625,2))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.bpcon)
	e2:SetTarget(c84012625.target2)
	e2:SetOperation(c84012625.activate2)
	c:RegisterEffect(e2)
	--release replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(84012625)
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
end
function c84012625.thfilter(c)
	return (c:IsSetCard(0xa3) or aux.IsCodeListed(c,44508094)) and c:IsAbleToHand()
end
function c84012625.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84012625.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84012625.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c84012625.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c84012625.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa3) and c:IsType(TYPE_SYNCHRO)
end
function c84012625.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c84012625.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c84012625.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c84012625.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c84012625.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		--return to hand
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetOwnerPlayer(tp)
		e1:SetCondition(c84012625.tdcon)
		e1:SetOperation(c84012625.tdop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
function c84012625.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tp==e:GetOwnerPlayer() and tc and tc:IsControler(1-tp)
end
function c84012625.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
