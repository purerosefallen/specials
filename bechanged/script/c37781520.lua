--水精鱗－リードアビス
function c37781520.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37781520,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c37781520.spcon)
	e1:SetCost(c37781520.spcost)
	e1:SetTarget(c37781520.sptg)
	e1:SetOperation(c37781520.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37781520,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c37781520.thcon)
	e2:SetTarget(c37781520.thtg)
	e2:SetOperation(c37781520.thop)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37781520,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,37781520)
	e3:SetCost(c37781520.hdcost)
	e3:SetTarget(c37781520.hdtg)
	e3:SetOperation(c37781520.hdop)
	c:RegisterEffect(e3)
end
function c37781520.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c37781520.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c37781520.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37781520.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c37781520.cfilter,1,3,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c37781520.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c37781520.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
end
function c37781520.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c37781520.thfilter(c)
	if not (c:IsSetCard(0x75) and c:IsType(TYPE_SPELL+TYPE_TRAP)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c37781520.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37781520.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c37781520.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c37781520.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end
function c37781520.costfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0x74)
end
function c37781520.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c37781520.costfilter,1,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroup(tp,c37781520.costfilter,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c37781520.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c37781520.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
