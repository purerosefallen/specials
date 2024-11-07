--E・HERO ゴッド・ネオス
function c31111109.initial_effect(c)
	aux.AddCodeList(c,89943723)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,c31111109.ffilter,2,2,c31111109.ffilter1,c31111109.ffilter2,c31111109.ffilter3)
	aux.AddContactFusionProcedure(c,c31111109.cfilter,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,aux.tdcfop(c))
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31111109,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c31111109.target)
	e1:SetOperation(c31111109.operation)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c31111109.atktg)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--may not return
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(42015635)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e4)
end
c31111109.material_setcode=0x8
function c31111109.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c31111109.ffilter(c,fc)
	return c:IsFusionSetCard(0x9,0x1f,0x8)
end
function c31111109.ffilter1(c,fc)
	return c:IsFusionSetCard(0x9)
end
function c31111109.ffilter2(c,fc)
	return c:IsFusionSetCard(0x1f)
end
function c31111109.ffilter3(c,fc)
	return c:IsFusionSetCard(0x8)
end
function c31111109.filter(c)
	return c:IsSetCard(0x9,0x1f,0x8) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_DECK+LOCATION_GRAVE) or not c:IsPublic())
end
function c31111109.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31111109.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c31111109.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,c31111109.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,99,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		local cg=g:Select(tp,1,1,nil)
		c:CopyEffect(cg:GetFirst():GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(g:GetCount()*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c31111109.atktg(e,c)
	return c:IsCode(89943723) or c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,89943723)
end