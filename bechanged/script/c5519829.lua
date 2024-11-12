--メンタル・カウンセラー リリー
function c5519829.initial_effect(c)
	--atk change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5519829,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(c5519829.con)
	e1:SetCost(c5519829.cost)
	e1:SetTarget(c5519829.tg)
	e1:SetOperation(c5519829.op)
	c:RegisterEffect(e1)
	aux.CreateMaterialReasonCardRelation(c,e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(c5519829.matval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(56894757,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(function (e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return Duel.CheckLPCost(tp,500) end Duel.PayLPCost(tp,500) end)
	e3:SetTarget(c5519829.thtg)
	e3:SetOperation(c5519829.thop)
	c:RegisterEffect(e3)
end
function c5519829.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c5519829.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c5519829.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler():GetReasonCard()
	if chk==0 then return rc:IsRelateToEffect(e) and rc:IsFaceup() end
	Duel.SetTargetCard(rc)
end
function c5519829.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sync=Duel.GetFirstTarget()
	if not sync:IsRelateToChain() or sync:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	sync:RegisterEffect(e1)
end
function c5519829.matval(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_FAIRY)
end
function c5519829.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c5519829.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end