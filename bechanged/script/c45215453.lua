--ヴァイロン・デルタ
---@param c Card
function c45215453.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c45215453.matfilter,nil,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45215453,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c45215453.thcon)
	e1:SetTarget(c45215453.thtg)
	e1:SetOperation(c45215453.thop)
	c:RegisterEffect(e1)
	--defense attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c45215453.matfilter(c,syncard)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsTuner(syncard)
end
function c45215453.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsDefensePos()
end
function c45215453.filter(c)
	return c:IsType(TYPE_EQUIP) and ((c:IsAbleToHand()) or (c:CheckEquipTarget(e:GetHandler()) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()))
end
function c45215453.filter1(c)
	return c:IsType(TYPE_EQUIP) and (c:CheckEquipTarget(e:GetHandler()) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden())
end
function c45215453.filter2(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c45215453.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45215453.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c45215453.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=not (c:IsFacedown() or c:IsAttackPos() or not c:IsRelateToEffect(e)) and Duel.IsExistingMatchingCard(c45215453.filter1,tp,LOCATION_DECK,0,1,nil,e:GetHandler())
	local b2=Duel.IsExistingMatchingCard(c45215453.filter2,tp,LOCATION_DECK,0,1,nil,e:GetHandler())
	if not b1 or b2 then return end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,1),1},{b2,aux.Stringid(id,2),2})
	if op==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	tg=Duel.SelectMatchingCard(tp,c45215453.filter1,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler())
	if tg:GetCount()>0 then
	tc=tg:GetFirst()
		Duel.Equip(tp,tc,c,true,false)
		end
	elseif op==2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c45215453.filter2,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler())
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	end
end
