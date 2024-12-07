--帝王の溶撃
function c48716527.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c48716527.actcon)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c48716527.distg)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
end
function c48716527.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c48716527.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c48716527.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c48716527.distg(e,c)
	return not c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
