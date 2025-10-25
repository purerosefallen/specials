--ピュアリィ・シェアリィ！？
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.cayjtg)
	e3:SetOperation(s.cayjop)
	c:RegisterEffect(e3)
end
function s.xsfr(c,e,tp,tc)
	return c:IsSetCard(0x18c) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and tc:IsCanBeXyzMaterial(c)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function s.xsfr2(c,e,tp)
	return c:IsSetCard(0x18c) and c:IsType(TYPE_XYZ)
end
function s.dsfr(c,e,tp)
	return c:IsSetCard(0x18c) and c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.xfr(c)
	return c:IsSetCard(0x18c) and c:IsType(TYPE_QUICKPLAY) and c:IsCanOverlay()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.dsfr,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.dsfr,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local sc1=g1:GetFirst()
	if not sc1 then return end
	Duel.SpecialSummon(sc1,0,tp,tp,false,false,POS_FACEUP)
	Duel.AdjustAll()
	if aux.MustMaterialCheck(sc1,tp,EFFECT_MUST_BE_XMATERIAL) 
		and Duel.IsExistingMatchingCard(s.xsfr2,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.xsfr,tp,LOCATION_EXTRA,0,1,nil,e,tp,sc1)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc2=Duel.SelectMatchingCard(tp,s.xsfr,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sc1):GetFirst()
		Duel.BreakEffect()
		sc2:SetMaterial(Group.FromCards(sc1))
		Duel.Overlay(sc2,Group.FromCards(sc1))
		Duel.SpecialSummon(sc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc2:CompleteProcedure()
		local g=Duel.GetMatchingGroup(s.xfr,tp,LOCATION_DECK,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=g:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.Overlay(sc2,sg:GetFirst())
		end
	end
end
function s.cayjtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cayj.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.cayjspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.cayjspfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.cayjop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.cayjspfilter(c,e,tp)
	return c:IsSetCard(0x18c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(1) and not c:IsType(TYPE_XYZ)
end