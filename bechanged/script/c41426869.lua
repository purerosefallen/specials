--イリュージョンの儀式
function c41426869.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,64631466)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(41426869,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c41426869.sptg)
	e4:SetOperation(c41426869.spop)
	c:RegisterEffect(e4)
end
function c41426869.spfilter(c,e,tp)
	return c:IsSetCard(0x110) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c41426869.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c41426869.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c41426869.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c41426869.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		Duel.Damage(tp,tc:GetAttack(),REASON_EFFECT)
	end
end