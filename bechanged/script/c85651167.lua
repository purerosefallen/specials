--真紅眼の鉄騎士－ギア・フリード
---@param c Card
function c85651167.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,85651167)
	e1:SetTarget(c85651167.sptg2)
	e1:SetOperation(c85651167.spop2)
	c:RegisterEffect(e1)
	--destroy equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(85651167,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_EQUIP)
	e2:SetTarget(c85651167.destg)
	e2:SetOperation(c85651167.desop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(85651167,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,85651168)
	e3:SetCost(c85651167.spcost)
	e3:SetTarget(c85651167.sptg)
	e3:SetOperation(c85651167.spop)
	c:RegisterEffect(e3)
end
function c85651167.eqfilter(c,tp)
	return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c85651167.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c85651167.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c85651167.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c85651167.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c85651167.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c85651167.eqlimit)
			tc:RegisterEffect(e1)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c85651167.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c85651167.eqlimit(e,c)
	return e:GetOwner()==c
end
function c85651167.damval(e,re,val,r,rp,rc)
	if r&REASON_EFFECT==REASON_EFFECT then
		return math.ceil(val/2)
	else return val end
end
function c85651167.filter1(c,ec)
	return c:GetEquipTarget()==ec
end
function c85651167.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c85651167.filter1,1,nil,e:GetHandler()) end
	local g=eg:Filter(c85651167.filter1,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c85651167.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c85651167.filter1,nil,e:GetHandler())
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and sg:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(85651167,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c85651167.spcostfilter(c,tp)
	return c:IsControler(tp) and c:IsAbleToGraveAsCost()
end
function c85651167.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetEquipGroup()
	if chk==0 then return g:IsExists(c85651167.spcostfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:FilterSelect(tp,c85651167.spcostfilter,1,1,nil,tp)
	Duel.SendtoGrave(tg,REASON_COST)
end
function c85651167.spfilter(c,e,tp)
	return c:IsSetCard(0x3b) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c85651167.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c85651167.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c85651167.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c85651167.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c85651167.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
