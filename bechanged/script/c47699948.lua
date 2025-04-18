--シンクロ・ディレンマ
function c47699948.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,47699948+EFFECT_COUNT_CODE_OATH)
	e0:SetCost(c47699948.cost)
	e0:SetOperation(c47699948.activate)
	c:RegisterEffect(e0)
	Duel.AddCustomActivityCounter(47699948,ACTIVITY_SPSUMMON,c47699948.counterfilter)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47699948,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,47699949)
	e1:SetCost(c47699948.spcost)
	e1:SetTarget(c47699948.sptg1)
	e1:SetOperation(c47699948.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47699948,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,47699949)
	e2:SetTarget(c47699948.sptg2)
	e2:SetOperation(c47699948.spop2)
	c:RegisterEffect(e2)
end
function c47699948.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_SYNCHRO)
end
function c47699948.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(47699948,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c47699948.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c47699948.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO)
end
function c47699948.thfilter(c)
	return c:IsSetCard(0x1017) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c47699948.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c47699948.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,47699949,0,TYPES_TOKEN_MONSTER,nil,nil,nil,nil,nil,POS_FACEUP,tp) and Duel.SelectYesNo(tp,aux.Stringid(47699948,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local tc=sg:GetFirst()
		if tc and tc:IsType(TYPE_MONSTER) then
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,47699949)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(tc:GetBaseAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(tc:GetBaseDefense())
			token:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_LEVEL)
			e3:SetValue(tc:GetOriginalLevel())
			token:RegisterEffect(e3)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CHANGE_RACE)
			e4:SetValue(tc:GetOriginalRace())
			token:RegisterEffect(e4)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e5:SetValue(tc:GetOriginalAttribute())
			token:RegisterEffect(e5)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c47699948.costfilter(c,e,tp)
	return c:IsSetCard(0x1017) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
		and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c47699948.spfilter,tp,LOCATION_HAND,0,1,c,e,tp)
end
function c47699948.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47699948.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47699948.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c47699948.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c47699948.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c47699948.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c47699948.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c47699948.desfilter(c,e,tp)
	local code=c:GetOriginalCode()
	return Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c47699948.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,code,e,tp)
end
function c47699948.spfilter2(c,code,e,tp)
	return not c:IsCode(code) and c:IsSetCard(0x1017) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47699948.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c47699948.desfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c47699948.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c47699948.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c47699948.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47699948.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc:GetOriginalCode(),e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
