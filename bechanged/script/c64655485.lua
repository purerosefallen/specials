--E・HERO ブレイヴ・ネオス
function c64655485.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,89943723,c64655485.ffilter,1,true,true)
	aux.AddContactFusionProcedure(c,c64655485.cfilter,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,aux.tdcfop(c))
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c64655485.atkval)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(64655485,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdocon)
	e3:SetTarget(c64655485.thtg)
	e3:SetOperation(c64655485.thop)
	c:RegisterEffect(e3)
end
c64655485.material_setcode=0x8
function c64655485.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c64655485.ffilter(c)
	return c:IsLevelBelow(4) and c:IsFusionType(TYPE_EFFECT)
end
function c64655485.atkfilter(c)
	return c:IsSetCard(0x8,0x1f) and c:IsType(TYPE_MONSTER)
end
function c64655485.atkval(e,c)
	return Duel.GetMatchingGroupCount(c64655485.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end
function c64655485.thfilter(c)
	return aux.IsCodeListed(c,89943723) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c64655485.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64655485.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c64655485.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c64655485.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
