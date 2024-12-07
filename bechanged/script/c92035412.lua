--ヴァイロン・エレメント
---@param c Card
function c92035412.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92035412,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c92035412.spcon)
	e2:SetTarget(c92035412.sptg)
	e2:SetOperation(c92035412.spop)
	c:RegisterEffect(e2)
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c92035412.chcon)
	e3:SetTarget(c92035412.chtg)
	e3:SetOperation(c92035412.chop)
	c:RegisterEffect(e3)
end
function c92035412.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL) and not re:GetHandler():IsType(TYPE_EQUIP)
end
function c92035412.chfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function c92035412.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c92035412.chfilter,rp,0,LOCATION_ONFIELD,1,nil) end
end
function c92035412.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c92035412.repop)
end
function c92035412.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(1-tp,c92035412.chfilter,1-tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 then
		Duel.Destroy(g,0x40)
	end
end
function c92035412.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x30)
		and bit.band(c:GetPreviousTypeOnField(),TYPE_EQUIP)~=0
end
function c92035412.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c92035412.cfilter,nil,tp)
	e:SetLabel(ct)
	return ct>0
end
function c92035412.spfilter(c,e,tp)
	return c:IsSetCard(0x30) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c92035412.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c92035412.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c92035412.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>e:GetLabel() then ft=e:GetLabel() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c92035412.spfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc=g:GetNext()
	end
end
