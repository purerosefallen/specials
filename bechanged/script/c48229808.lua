--ホルスの黒炎竜 LV8
---@param c Card
function c48229808.initial_effect(c)
	aux.AddCodeList(c,16528181)
	--c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c48229808.splimit)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(48229808,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c48229808.condition)
	e2:SetTarget(c48229808.target)
	e2:SetOperation(c48229808.operation)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,48229808+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c48229808.sprcon)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,48229809)
	e4:SetCost(c48229808.tgcost)
	e4:SetTarget(c48229808.tgtg)
	e4:SetOperation(c48229808.tgop)
	c:RegisterEffect(e4)
end
c48229808.lvup={48229808}
c48229808.lvdn={75830094,48229808}
function c48229808.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	if Duel.IsExistingMatchingCard(c48229808.sprfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) then return se:IsHasType(EFFECT_TYPE_ACTIONS)
	else return sc:IsSetCard(0x19d) and sc:IsType(TYPE_MONSTER) end
end
function c48229808.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev)
end
function c48229808.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c48229808.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c48229808.sprfilter(c)
	return c:IsFaceup() and c:IsCode(16528181)
end
function c48229808.sprcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c48229808.sprfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c48229808.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,c) and c:IsAbleToGraveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c48229808.filter(c)
	return aux.IsCodeListed(c,16528181) and not c:IsCode(48229808) and c:IsAbleToHand()
end
function c48229808.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c48229808.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c48229808.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.SelectMatchingCard(tp,c48229808.filter,tp,LOCATION_DECK,0,1,1,nil)
	if tg and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,tg)~=0
		and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(48229808,1)) then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
	end
end
