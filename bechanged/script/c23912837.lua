--影光の聖選士
---@param c Card
function c23912837.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23912837,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e1:SetCountLimit(1,23912837)
	e1:SetTarget(c23912837.target)
	e1:SetOperation(c23912837.operation)
	c:RegisterEffect(e1)
	--pos change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23912837,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e2:SetCountLimit(1,23912837+1)
	e2:SetTarget(c23912837.postg)
	e2:SetOperation(c23912837.posop)
	c:RegisterEffect(e2)
end
function c23912837.filter(c,e,tp)
	return c:IsSetCard(0x9d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE)
end
function c23912837.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c23912837.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK)
end
function c23912837.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c23912837.filter),tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_DEFENSE)~=0 and tc:IsFacedown() then
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c23912837.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(23912837,2))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(23912837,3))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(23912837,2),aux.Stringid(23912837,3))
	end
	e:SetLabel(s)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c23912837.posop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEUP_DEFENSE)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEDOWN_DEFENSE)
		end
	end
end
