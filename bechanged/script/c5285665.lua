--E・HERO バブルマン・ネオ
---@param c Card
function c5285665.initial_effect(c)
	aux.AddCodeList(c,46411259)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c5285665.spcon)
	e1:SetTarget(c5285665.sptg)
	e1:SetOperation(c5285665.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(aux.dsercon)
	e1:SetTarget(c5285665.destg)
	e1:SetOperation(c5285665.desop)
	c:RegisterEffect(e1)
	--battle indestructable
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--damage val
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,5285665)
	e5:SetTarget(c5285665.settg)
	e5:SetOperation(c5285665.setop)
	c:RegisterEffect(e5)
end
function c5285665.spfilter(c,tp,f)
	return f(c) and (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3008) or aux.IsSetNameMonsterListed(c,0x3008)) and not c:IsCode(5285665) and c:IsControler(tp) and Duel.GetMZoneCount(tp,c)>0
end
function c5285665.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:IsLocation(LOCATION_HAND) or Duel.IsExistingMatchingCard(c5285665.spfilter,tp,LOCATION_ONFIELD,0,1,c,tp,Card.IsAbleToGraveAsCost)
end
function c5285665.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	if c:IsLocation(LOCATION_DECK) then
		local g=Duel.GetMatchingGroup(c5285665.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c,tp,Card.IsAbleToGraveAsCost)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=g:SelectUnselect(nil,tp,false,true,1,1)
		if tc then
			e:SetLabelObject(tc)
			return true
		else return false end
	elseif c:IsLocation(LOCATION_HAND) then return true end
end
function c5285665.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if c:IsLocation(LOCATION_DECK) then
		local g=e:GetLabelObject()
		Duel.Release(g,REASON_SPSUMMON)
	else return true end
end
function c5285665.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc and bc:IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c5285665.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function c5285665.setfilter(c)
	return (aux.IsSetNameMonsterListed(c,0x3008) and c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsCode(46411259)) and c:IsSSetable()
end
function c5285665.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5285665.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c5285665.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c5285665.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then Duel.SSet(tp,tc) end
end