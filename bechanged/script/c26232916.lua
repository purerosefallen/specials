--隠れ里－忍法修練の地
---@param c Card
function c26232916.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26232916,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,26232916)
	e2:SetCondition(c26232916.thcon)
	e2:SetTarget(c26232916.thtg)
	e2:SetOperation(c26232916.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,26232917)
	e5:SetTarget(c26232916.reptg)
	e5:SetValue(c26232916.repval)
	e5:SetOperation(c26232916.repop)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_MSET)
	e6:SetRange(LOCATION_FZONE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c26232916.poscon)
	e6:SetTarget(c26232916.postg)
	e6:SetOperation(c26232916.posop)
	c:RegisterEffect(e6)
	local e66=e6:Clone()
	e66:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e66)
end
function c26232916.cfilter(c,tp)
	return c:IsFacedown() and c:IsControler(tp)
end
function c26232916.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26232916.cfilter,1,nil,tp)
end
function c26232916.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c26232916.cfilter,nil)
	if chk==0 then return #g>0 end
end
function c26232916.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c26232916.cfilter,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=eg:Select(tp,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsSetCard(0x2b) then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		end
	end
end
function c26232916.thcfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x2b) and c:IsControler(tp)
end
function c26232916.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26232916.thcfilter,1,nil,tp)
end
function c26232916.thfilter(c)
	return (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2b) or c:IsSetCard(0x61))
		and c:IsAbleToHand()
end
function c26232916.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26232916.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26232916.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26232916.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26232916.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c26232916.repfilter(c,tp)
	return c:IsFaceup() and (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2b) or c:IsSetCard(0x61))
		and c:IsOnField() and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function c26232916.rmfilter(c)
	return c:IsSetCard(0x2b) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c26232916.repval(e,c)
	return c26232916.repfilter(c,e:GetHandlerPlayer())
end
function c26232916.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c26232916.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c26232916.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tg=Duel.SelectMatchingCard(tp,c26232916.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		e:SetLabelObject(tg:GetFirst())
		return true
	end
	return false
end
function c26232916.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,26232916)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
