--カオス－黒魔術の儀式
function c76792184.initial_effect(c)
	aux.AddCodeList(c,46986414,12266229,30208479,47963370)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76792184)
	e1:SetTarget(c76792184.target)
	e1:SetOperation(c76792184.activate)
	c:RegisterEffect(e1)

end
function c76792184.filter(c,e,tp)
	return c:IsCode(12266229,30208479,47963370) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c76792184.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c76792184.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c76792184.rfilter(c,tp)
	return (c:IsFaceupEx() or c:IsControler(tp))
		and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and c:IsReleasableByEffect()
end
function c76792184.gcheck(g,tp,lv)
	return g:GetSum(Card.GetLevel)==lv
end
function c76792184.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c76792184.filter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
		local lv=tc:GetLevel()
		local g=Duel.GetMatchingGroup(c76792184.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:SelectSubGroup(tp,c76792184.gcheck,false,1,g:GetCount(),tp,lv)
		if sg and sg:GetCount()>0 then
			Duel.Release(sg,REASON_EFFECT)
		end
	end
end