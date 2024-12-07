--トゥーン・フリップ
function c27699122.initial_effect(c)
	aux.AddCodeList(c,15259703)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27699122+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c27699122.con)
	e1:SetTarget(c27699122.tg)
	e1:SetOperation(c27699122.op)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7459919,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c27699122.sptg)
	e4:SetOperation(c27699122.spop)
	c:RegisterEffect(e4)
end
function c27699122.ffilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c27699122.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27699122.ffilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c27699122.filter(c,e,tp)
	return c:IsSetCard(0x62,0x110) and c:IsAbleToHand()
end
function c27699122.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c27699122.filter,tp,LOCATION_DECK,0,nil,e,tp)
		return dg:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27699122.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c27699122.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	if sg then
		Duel.ConfirmCards(1-tp,sg)
		local tc=sg:RandomSelect(1-tp,1):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c27699122.spfilter(c,e,tp)
	return c:IsSetCard(0x110) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c27699122.setfilter(c,tp)
	return c:IsCode(15259703) and c:IsType(TYPE_FIELD) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c27699122.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsEnvironment(15259703) then
			return Duel.IsExistingMatchingCard(c27699122.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(c27699122.setfilter,tp,LOCATION_DECK,0,1,nil,tp)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c27699122.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsEnvironment(15259703) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c27699122.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.BreakEffect()
			Duel.Damage(tp,tc:GetAttack(),REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c27699122.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	end
end