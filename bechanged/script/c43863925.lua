--エクソシスター・ステラ
function c43863925.initial_effect(c)
	aux.AddCodeList(c,16474916)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER+CATEGORY_DECKDES)
	e1:SetCountLimit(1,43863925)
	e1:SetTarget(c43863925.effeg)
	e1:SetOperation(c43863925.effop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43863925,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43863926)
	e2:SetCondition(c43863925.spcon)
	e2:SetTarget(c43863925.sptg)
	e2:SetOperation(c43863925.spop)
	c:RegisterEffect(e2)
end
function c43863925.effspfilter(c,e,tp)
	return c:IsSetCard(0x172) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43863925.effspfilter2(c,e,tp)
	return c:IsCode(16474916) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43863925.effeg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c43863925.effspfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c43863925.effspfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER+CATEGORY_DECKDES,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c43863925.cfilter(c)
	return c:IsFaceup() and c:IsCode(16474916)
end
function c43863925.splimit(e,c)
	return not c:IsSetCard(0x172)
end
function c43863925.effop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c43863925.effspfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c43863925.effspfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
	if not ( b1 or b2 ) then return end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(43863925,2)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(43863925,3)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local gg=Duel.IsExistingMatchingCard(c43863925.effspfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	if gg then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c43863925.effspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c43863925.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.BreakEffect()
		Duel.Recover(tp,800,REASON_EFFECT)
	end
	end
	elseif opval[op]==2 then
	local gg=Duel.IsExistingMatchingCard(c43863925.effspfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
	if gg then
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c43863925.splimit)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c43863925.effspfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c43863925.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.BreakEffect()
		Duel.Recover(tp,800,REASON_EFFECT)
	end
	end
	end
end
function c43863925.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c43863925.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x172) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c43863925.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c43863925.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c43863925.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c43863925.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local sc=g:GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
