--魔轟神クシャノ
function c97439806.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97439806,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c97439806.cost)
	e1:SetTarget(c97439806.tg)
	e1:SetOperation(c97439806.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(c97439806.matval)
	c:RegisterEffect(e2)
end
function c97439806.costfilter(c)
	return c:IsSetCard(0x35) and c:IsType(TYPE_MONSTER) and not c:IsCode(97439806)
		and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c97439806.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c97439806.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c97439806.costfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c97439806.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c97439806.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
function c97439806.matval(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end