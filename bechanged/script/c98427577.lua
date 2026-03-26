--くず鉄のかかし
function c98427577.initial_effect(c)
	aux.AddCodeList(c,76774528)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c98427577.condition)
	e1:SetTarget(c98427577.target)
	e1:SetOperation(c98427577.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98427577,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c98427577.spcon)
	e2:SetTarget(c98427577.sptg)
	e2:SetOperation(c98427577.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98427577,1))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e3)
end
function c98427577.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c98427577.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c98427577.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c98427577.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c98427577.spfilter2(c,e,tp)
	return c:IsCode(76774528) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98427577.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98427577.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98427577.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c98427577.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp)
	if tg then
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end