--シューティング・スター
---@param c Card
function c47264717.initial_effect(c)
	aux.AddCodeList(c,44508094)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,47264717)
	e1:SetTarget(c47264717.target)
	e1:SetOperation(c47264717.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47264717,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c47264717.handcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,47264718)
	e3:SetCondition(c47264717.thcon)
	e3:SetTarget(c47264717.thtg)
	e3:SetOperation(c47264717.thop)
	c:RegisterEffect(e3)
end
function c47264717.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47264717.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c47264717.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0xa3) or aux.IsCodeListed(c,44508094)) and c:IsType(TYPE_MONSTER)
end
function c47264717.handcon(e)
	return Duel.IsExistingMatchingCard(c47264717.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c47264717.cfilter2(c,tp,rp)
	return c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and (c:IsCode(44508094) or c:GetPreviousTypeOnField()&TYPE_SYNCHRO~=0 and aux.IsCodeListed(c,44508094))
		and c:IsReason(REASON_COST+REASON_EFFECT) and rp==tp
end
function c47264717.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47264717.cfilter2,1,nil,tp,rp)
end
function c47264717.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c47264717.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end