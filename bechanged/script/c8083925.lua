--直播☆双子入口页
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x152,0x153) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x153,0x152)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,id)==0
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,id)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(id,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	else return end
	if op==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,2)
		if g:GetCount()>0 then
			local sg=g:RandomSelect(tp,1)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
			g:RemoveCard(sg:GetFirst())
			if g:GetCount()>0 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
				sg=g:Select(tp,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
			end
		end
	end
end
function s.splimit(e,c)
	return not c:IsSetCard(0x2151) and c:IsLocation(LOCATION_EXTRA)
end
function s.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x153)
end
function s.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x152)
end