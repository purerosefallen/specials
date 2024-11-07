--光と闇の洗礼
function c69542930.initial_effect(c)
	aux.AddCodeList(c,46986414,40737112)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69542930,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c69542930.target)
	e1:SetOperation(c69542930.activate)
	c:RegisterEffect(e1)
end
function c69542930.filter(c)
	return c:IsCode(46986414,40737112)
end
function c69542930.sfilter1(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
		and g:IsExists(c69542930.sfilter2,1,c,e,tp,c)
end
function c69542930.sfilter2(c,e,tp,oc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
		and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(1-tp,tp,nil,c)>0)
		and aux.gfcheck(Group.FromCards(c,oc),Card.IsCode,46986414,40737112)
end
function c69542930.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c69542930.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,nil)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and g:IsExists(c69542930.sfilter1,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED)
end
function c69542930.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c69542930.filter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,nil)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:IsExists(c69542930.sfilter1,1,nil,e,tp,g) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		local sc=g:FilterSelect(tp,c69542930.sfilter1,1,1,nil,e,tp,g):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
		local oc=g:FilterSelect(tp,c69542930.sfilter2,1,1,sc,e,tp,sc):GetFirst()
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(oc,0,tp,1-tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end