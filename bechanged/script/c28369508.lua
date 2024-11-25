--サブテラーマリスの潜伏
---@param c Card
function c28369508.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c28369508.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c28369508.thcon)
	e2:SetTarget(c28369508.thtg)
	e2:SetOperation(c28369508.thop)
	c:RegisterEffect(e2)
	--change pos
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_BATTLE_PHASE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetTarget(c28369508.postg)
	e3:SetOperation(c28369508.posop)
	c:RegisterEffect(e3)
	--act in set turn
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(28369508,0))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCondition(c28369508.actcon)
	c:RegisterEffect(e4)
end
function c28369508.actfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xed)
end
function c28369508.actcon(e)
	return Duel.IsExistingMatchingCard(c28369508.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c28369508.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c28369508.tgfilter)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	Duel.RegisterEffect(e2,tp)
	if Duel.IsExistingMatchingCard(c28369508.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	and Duel.SelectYesNo(tp,aux.Stringid(28369508,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local tg=Duel.SelectMatchingCard(tp,c28369508.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(tg)
		Duel.ChangePosition(tg:GetFirst(),POS_FACEDOWN_DEFENSE)
	end
end
function c28369508.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c28369508.tgfilter(e,c)
	return c:IsFacedown() and c:IsLocation(LOCATION_MZONE)
end
function c28369508.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c28369508.thfilter(c)
	return c:IsSetCard(0xed) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28369508.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28369508.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28369508.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c28369508.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c28369508.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xed) and c:IsCanTurnSet()
end
function c28369508.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c28369508.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28369508.filter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsSSetable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c28369508.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c28369508.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) then
		if c:IsRelateToEffect(e) then
			Duel.SSet(tp,c)
		end
	end
end
