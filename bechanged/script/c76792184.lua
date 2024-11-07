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
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(128454,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,76792185)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c76792184.thtg)
	e2:SetOperation(c76792184.thop)
	c:RegisterEffect(e2)
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
function c76792184.thfilter(c,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return aux.IsCodeListed(c,46986414,30208479,47963370) and (c:IsAbleToHand() or (ft>0 and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c76792184.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76792184.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c76792184.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c76792184.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end