--マジシャンズ・ローブ
function c71696014.initial_effect(c)
	aux.AddCodeList(c,46986414)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(71696014,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK)
	e0:SetCountLimit(1,71696014+EFFECT_COUNT_CODE_OATH)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c71696014.sprcon)
	e0:SetTarget(c71696014.sprtg)
	e0:SetOperation(c71696014.sprop)
	c:RegisterEffect(e0)
	--spsummon (DM)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71696014,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,71696015)
	e1:SetCost(c71696014.cost)
	e1:SetTarget(c71696014.target1)
	e1:SetOperation(c71696014.operation1)
	c:RegisterEffect(e1)
	--spsummon (self)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71696014,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,71696016)
	e3:SetCondition(c71696014.condition2)
	e3:SetTarget(c71696014.target2)
	e3:SetOperation(c71696014.operation2)
	c:RegisterEffect(e3)
end
function c71696014.cfilter(c,tp,f)
	return f(c) and Duel.GetMZoneCount(tp,c)>0 and c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c71696014.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c71696014.cfilter,tp,LOCATION_ONFIELD,0,1,c,tp,Card.IsAbleToGraveAsCost)
end
function c71696014.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c71696014.cfilter,tp,LOCATION_ONFIELD,0,c,tp,Card.IsAbleToGraveAsCost)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c71696014.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
function c71696014.cdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c71696014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71696014.cdfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c71696014.cdfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c71696014.filter(c,e,tp)
	return c:IsCode(46986414) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71696014.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71696014.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c71696014.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71696014.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71696014.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and rp==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c71696014.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71696014.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
