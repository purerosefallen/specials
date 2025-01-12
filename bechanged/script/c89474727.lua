--真閃珖竜 スターダスト・クロニクル
function c89474727.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(89474727,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c89474727.target)
	e2:SetOperation(c89474727.operation)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(89474727,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c89474727.discon)
	e3:SetTarget(c89474727.distg)
	e3:SetOperation(c89474727.disop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c89474727.valcheck)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(89474727,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCondition(c89474727.spcon)
	e5:SetTarget(c89474727.sptg)
	e5:SetOperation(c89474727.spop)
	c:RegisterEffect(e5)
end
c89474727.material_type=TYPE_SYNCHRO
function c89474727.filter(c)
	return c:IsFaceup()
end
function c89474727.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c89474727.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c89474727.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c89474727.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c89474727.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c89474727.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c89474727.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c89474727.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_DESTROY) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c89474727.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=1
	if c:GetFlagEffectLabel(89474727) then ct=c:GetFlagEffectLabel(89474727) end
	if chk==0 then return c:GetFlagEffect(89474728)<ct end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	c:RegisterFlagEffect(89474728,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c89474727.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c89474727.valcheck(e,c)
	c:RegisterFlagEffect(89474727,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,c:GetMaterialCount()-1)
end
function c89474727.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():IsPreviousControler(tp)
end
function c89474727.spfilter(c,e,tp)
	return c:IsLevelBelow(8) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_EXTRA) or c:IsFaceupEx())
		and (Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c89474727.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c89474727.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED)
end
function c89474727.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c89474727.spfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end