--スターライト・ロード
function c58120309.initial_effect(c)
	aux.AddCodeList(c,44508094)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c58120309.condition)
	e1:SetTarget(c58120309.target)
	e1:SetOperation(c58120309.activate)
	c:RegisterEffect(e1)
end
function c58120309.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return re:IsHasCategory(CATEGORY_DESTROY) or ex
end
function c58120309.sfilter(c,e,tp)
	return c:IsCode(44508094) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c58120309.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c58120309.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c58120309.sfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(58120309,0)) then
			local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c58120309.sfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
