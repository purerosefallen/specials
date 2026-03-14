--先史遗产-金字塔眼板
function c26345570.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x70))
	e2:SetValue(800)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c26345570.immtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetCondition(c26345570.indescon)
	e4:SetTarget(c26345570.indestg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetTarget(c26345570.rmlimit)
	e5:SetCondition(c26345570.indescon)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26345570,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,26345570)
	e6:SetCost(c26345570.thcost)
	e6:SetTarget(c26345570.thtg)
	e6:SetOperation(c26345570.thop)
	c:RegisterEffect(e6)
end

function c26345570.immtg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x70) and c:IsFaceup()
end

function c26345570.indesfilter(c)
	return c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack()
end
function c26345570.indescon(e)
	return Duel.IsExistingMatchingCard(c26345570.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c26345570.indestg(e,c)
	return c:IsSetCard(0x70) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c26345570.rmlimit(e,c,rp,r,re)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and c:IsSetCard(0x70) and c:IsFaceup()
		and r&REASON_EFFECT>0 and r&REASON_REDIRECT==0
end

function c26345570.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c26345570.thfilter(c)
	return c:IsSetCard(0x70) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c26345570.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26345570.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26345570.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26345570.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
