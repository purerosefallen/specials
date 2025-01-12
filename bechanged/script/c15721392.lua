--超级量子要请 阿尔方出动
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	--spsum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.xyztg)
	e2:SetOperation(s.xyzop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)

end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xdc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_DECKDES,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if sc and #sc>0 then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.exspfilter1(c,e,tp)
	return c:IsSetCard(0xdc) and c:IsFaceup() and c:IsCanOverlay()
	and Duel.IsExistingMatchingCard(s.exspfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.exspfilter2(c,e,tp,sc)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsSetCard(0x20dc)
		and c:IsType(TYPE_XYZ) and sc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0
		and not Duel.IsExistingMatchingCard(s.bfilter,tp,LOCATION_ONFIELD,0,1,nil,c)
end
function s.bfilter(c,tc)
	return tc:IsCode(c:GetCode()) and c:IsFaceup()
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.exspfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,s.exspfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.xefilter(c,tc)
	return aux.IsCodeListed(tc,c:GetCode()) and c:IsCanOverlay() and c:IsCanBeXyzMaterial(tc)and c:IsSetCard(0x10dc)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.exspfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
		local ec=g:GetFirst()
		ec:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(ec,Group.FromCards(tc))
		if Duel.SpecialSummon(ec,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
			ec:CompleteProcedure()
			if Duel.IsExistingMatchingCard(s.xefilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,ec)
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local xc=Duel.SelectMatchingCard(tp,s.xefilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,ec)
				if xc and #xc>0 then
					Duel.Overlay(ec,xc)
				end
			end
		end
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.chkfilter,1,nil)
end
function s.chkfilter(c)
	return c:IsSetCard(0x20dc) and c:IsType(TYPE_MONSTER)
end
function s.filter(c)
	return not c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0xdc)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil)
	and c:IsAbleToHand()end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,2,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand()and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		g=g:__add(c)
		if g:GetCount()==2 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	
	end
end
