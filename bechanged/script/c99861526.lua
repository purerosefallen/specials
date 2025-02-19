--潜艇机人
function c99861526.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--damage reduce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetCondition(c99861526.rdcon)
	e2:SetValue(c99861526.rval)
	c:RegisterEffect(e2)
	--pos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99861526,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c99861526.poscon)
	e3:SetOperation(c99861526.posop)
	c:RegisterEffect(e3)
	--huishou
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99861526,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,99861526)
	e4:SetTarget(c99861526.thtg)
	e4:SetOperation(c99861526.thop)
	c:RegisterEffect(e4)
	end

function c99861526.rdcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c99861526.rval(e,damp)
	if damp==1-e:GetHandlerPlayer() then
		return e:GetHandler():GetBaseAttack()
	else return -1 end
end
function c99861526.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsAttackPos()
end
function c99861526.posop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end

-------------4
function c99861526.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x16) and ( c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP) ) and c:IsAbleToHand()
end
function c99861526.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99861526.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99861526.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c99861526.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99861526.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end


