--オーバー・コアリミット
function c36560997.initial_effect(c)
	aux.AddCodeList(c,36623431)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1d))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(36560997,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c36560997.atcost)
	e3:SetTarget(c36560997.attg)
	e3:SetOperation(c36560997.atop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1d))
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(36560997,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c36560997.thcon)
	e4:SetTarget(c36560997.thtg)
	e4:SetOperation(c36560997.thop)
	c:RegisterEffect(e4)
end
function c36560997.cfilter0(c,tp)
	return c:IsControler(tp) and c:IsCode(36623431)
end
function c36560997.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c36560997.cfilter0,1,e:GetHandler(),tp)
end
function c36560997.thfilter(c)
	return c:IsCode(36623431) and c:IsAbleToHand()
end
function c36560997.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36560997.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c36560997.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c36560997.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c36560997.cfilter(c)
	return c:IsCode(36623431) and c:IsDiscardable()
end
function c36560997.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36560997.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c36560997.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c36560997.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1d)
end
function c36560997.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36560997.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c36560997.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c36560997.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
