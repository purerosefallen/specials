--エクソシスター・アーメント
function c4408198.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,4408198+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c4408198.cost)
	e1:SetTarget(c4408198.target)
	e1:SetOperation(c4408198.activate)
	c:RegisterEffect(e1)
	if not c4408198.global_check then
		c4408198.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c4408198.checkcon)
		ge1:SetOperation(c4408198.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c4408198.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_XYZ)
end
function c4408198.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsSummonType,nil,SUMMON_TYPE_XYZ)
	local tc=g:GetFirst()
	while tc do
		if tc:IsSetCard(0x172) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),4408198,RESET_PHASE+PHASE_END,0,1)
		end
		if Duel.GetFlagEffect(0,4408198)>1 and Duel.GetFlagEffect(1,4408198)>1 then
			break
		end
		tc=g:GetNext()
	end
end
function c4408198.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c4408198.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c4408198.spfilter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x172)
		and Duel.IsExistingMatchingCard(c4408198.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c4408198.spfilter2(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x172) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and not Duel.IsExistingMatchingCard(c4408198.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c4408198.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c4408198.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c4408198.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c4408198.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c4408198.xyzfilter(c)
	return c:IsSetCard(0x172) and c:IsXyzSummonable(nil)
end
function c4408198.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4408198.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		Duel.AdjustAll()
		if not Duel.CheckLPCost(tp,800) then return end
		local b1=Duel.IsExistingMatchingCard(c4408198.xyzfilter,tp,LOCATION_EXTRA,0,1,nil)
		local b2=Duel.GetFlagEffect(tp,4408198)>1 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(4408198,1)},
			{b2,aux.Stringid(4408198,2)},
			{true,aux.Stringid(4408198,3)})
		if op==1 then
			Duel.BreakEffect()
			Duel.PayLPCost(tp,800)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c4408198.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil)
			Duel.XyzSummon(tp,g:GetFirst(),nil)
		elseif op==2 then
			Duel.BreakEffect()
			Duel.PayLPCost(tp,800)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end