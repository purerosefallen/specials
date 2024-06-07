--七皇転生
function c57499304.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function (e)
		local tp=e:GetHandlerPlayer()
		return ((e:GetHandler():IsLocation(LOCATION_HAND) and Duel.GetFieldGroup(tp,0,LOCATION_MZONE):IsExists(function(tc)
			return tc:IsSummonLocation(LOCATION_EXTRA) and tc:IsFaceup()
		end,1,nil)) or not e:GetHandler():IsLocation(LOCATION_HAND))
	end)
	e1:SetCost(c57499304.cost)
	e1:SetTarget(c57499304.target)
	e1:SetOperation(c57499304.op)
	c:RegisterEffect(e1)
	--act in hand
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e5)
end
function c57499304.filter(c)
	local no=aux.GetXyzNumber(c)
	return (no and no>=101 and no<=107 and c:IsSetCard(0x48) and c:IsType(TYPE_XYZ))
		or c:GetOverlayGroup():IsExists(c57499304.filter,1,nil)
end
function c57499304.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c57499304.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c57499304.filter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetCount()
	local sg=g:Select(tp,1,ct,nil)
	local sc=sg:GetFirst()
	if c57499304.filter(sc) and sc:GetOverlayGroup():IsExists(c57499304.filter,1,nil) and Duel.SelectOption(tp,1005,aux.Stringid(57499304,0)) then
		Duel.Remove(sc:GetOverlayGroup(),POS_FACEUP,REASON_COST)
	end
	Duel.Remove(sc,POS_FACEUP,REASON_COST)
end
function c57499304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c57499304.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c57499304.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,57499304)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c57499304.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
	end
end
function c57499304.spfilter(c,e,tp)
	return not c:IsSetCard(0x48) and c:IsRankBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
