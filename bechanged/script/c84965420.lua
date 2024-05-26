--ドライトロン流星群
function c84965420.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,84965420+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c84965420.condition)
	e1:SetTarget(c84965420.target)
	e1:SetOperation(c84965420.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e5:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetMatchingGroupCount(function(c)
			return c:IsType(TYPE_RITUAL) and c:IsFaceup() and c:IsSetCard(0x154)
		end,tp,LOCATION_MZONE,0,nil)>0
	end)
	c:RegisterEffect(e5)
end
function c84965420.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c84965420.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsAbleToDeck()
end
function c84965420.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c84965420.filter,tp,LOCATION_MZONE,0,1,nil)
		and aux.NegateSummonCondition() and eg:IsExists(c84965420.cfilter,1,nil,tp)
end
function c84965420.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c84965420.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
