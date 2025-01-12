--救世竜 セイヴァー・ドラゴン
---@param c Card
function c21159309.initial_effect(c)
	--hand synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21159309)
	e1:SetValue(c21159309.matval)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,21159310)
	e2:SetCondition(c21159309.thcon)
	e2:SetTarget(c21159309.thtg)
	e2:SetOperation(c21159309.thop)
	c:RegisterEffect(e2)
end
function c21159309.matval(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x3f)
end
function c21159309.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c21159309.filter(c)
	return (c:IsSetCard(0x3f) or aux.IsCodeListed(c,63436931)) and c:IsAbleToHand()
end
function c21159309.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21159309.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21159309.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21159309.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end