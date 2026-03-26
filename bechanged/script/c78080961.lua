--SPYRAL－ジーニアス
function c78080961.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78080961,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c78080961.thtg)
	e1:SetOperation(c78080961.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78080961,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c78080961.spcon)
	e3:SetCost(c78080961.spcost)
	e3:SetTarget(c78080961.sptg)
	e3:SetOperation(c78080961.spop)
	c:RegisterEffect(e3)
end
function c78080961.thfilter(c)
	return c:IsSetCard(0x10ee) and c:IsAbleToHand()
end
function c78080961.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78080961.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c78080961.whateffect(e,tp,eg,ep,ev,re,r,rp)
	return c:IsCode(83827392) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==8
end
function c78080961.eight(c,e,tp,mc)
	return c:IsCode(93039339) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
	and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c78080961.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c78080961.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then end
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c78080961.whateffect,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c78080961.eight,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(78080961,2))
		and c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp)
		and not c:IsImmuneToEffect(e)
		then
		local c=e:GetHandler()
		if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c78080961.eight,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
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
end
function c78080961.cfilter(c)
	return c:IsFaceup() and c:IsCode(41091257)
end
function c78080961.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c78080961.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c78080961.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c78080961.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c78080961.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
	end
end
