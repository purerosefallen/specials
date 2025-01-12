--超级量子必杀 阿尔方球
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,58753372,10424147)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Activate2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(aux.NOT(s.condition))
	e3:SetTarget(s.target2)
	e3:SetOperation(s.activate2)
	c:RegisterEffect(e3)
	--activate field spell
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.actcost)
	e2:SetTarget(s.acttg)
	e2:SetOperation(s.actop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10dc)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 and Duel.IsPlayerCanSpecialSummon(1-tp) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,1-tp,LOCATION_EXTRA,0,1,nil,e,1-tp) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,s.spfilter,1-tp,LOCATION_EXTRA,0,1,1,nil,e,1-tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,1-tp,1-tp,true,false,POS_FACEUP)
		end
	end
end
function s.tgfilter(c)
	return c:IsSetCard(0xdc) and c:IsAbleToGrave()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end

function s.costfilter(c)
	return c:IsCode(58753372) and c:IsAbleToRemoveAsCost()
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.actfilter(c,tp)
	return c:IsCode(10424147) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.actfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(s.actfilter,tp,LOCATION_DECK,0,nil,tp)
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local op=te:GetOperation()
		if op then
			op(te,tp,e:GetHandler(),tp,ev,e,REASON_EFFECT,tp)
		end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
