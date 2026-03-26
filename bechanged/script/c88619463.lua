--黒の魔法神官
function c88619463.initial_effect(c)
	aux.AddCodeList(c,46986414)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c88619463.spcon)
	e2:SetTarget(c88619463.sptg)
	e2:SetOperation(c88619463.spop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88619463,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_NEGATE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c88619463.discon)
	e3:SetTarget(c88619463.distg)
	e3:SetOperation(c88619463.disop)
	c:RegisterEffect(e3)
	--手坑
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(29436665,0))
	e5:SetCategory(CATEGORY_DECKDES+CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_HAND)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCondition(c88619463.condition)
	e5:SetCost(c88619463.cost)
	e5:SetTarget(c88619463.target)
	e5:SetOperation(c88619463.operation)
	c:RegisterEffect(e5)
end
function c88619463.rfilter(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(6) and (c:IsControler(tp) or c:IsFaceup())
end
function c88619463.gr(g,tp,su)
	return ((g:GetCount()==1 and g:GetFirst():IsCode(46986414))
		or g:GetCount()==2) and Duel.GetMZoneCount(tp,g)>0
end
function c88619463.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c88619463.rfilter,nil,tp)
	return rg:CheckSubGroup(c88619463.gr,1,2,tp,REASON_SPSUMMON)
end
function c88619463.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c88619463.rfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c88619463.gr,true,1,2,tp,REASON_SPSUMMON)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c88619463.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c88619463.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_TRAP+TYPE_SPELL) and Duel.IsChainNegatable(ev)
end
function c88619463.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c88619463.disop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFacedown() or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c88619463.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_TRAP+TYPE_SPELL) and Duel.IsChainNegatable(ev)
end
function c88619463.costfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGraveAsCost()
end
function c88619463.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and
		Duel.IsExistingMatchingCard(c88619463.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88619463.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c88619463.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c88619463.heimoshu(c,e,tp)
	return c:IsCode(46986414) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c88619463.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88619463.heimoshu,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local c=e:GetHandler()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e3:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e3,true)
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		end
	end
	Duel.SpecialSummonComplete()
end