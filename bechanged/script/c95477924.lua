--マジシャンズ・サルベーション
---@param c Card
function c95477924.initial_effect(c)
	aux.AddCodeList(c,46986414,38033121,48680970)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95477924+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,95477926)
	e2:SetTarget(c95477924.target)
	e2:SetOperation(c95477924.activate)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95477924,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,95477925)
	e3:SetCondition(c95477924.spcon)
	e3:SetTarget(c95477924.sptg)
	e3:SetOperation(c95477924.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c95477924.setfilter(c)
	return aux.IsCodeListed(c,46986414,38033121) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c95477924.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c95477924.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c95477924.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	if not Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceupEx,Card.IsCode),tp,LOCATION_ONFIELD,0,1,nil,48680970) then ft=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c95477924.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
		if sg:GetCount()>0 then
			Duel.SSet(tp,sg)
		end
	end
end
function c95477924.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(46986414,38033121) and c:IsSummonPlayer(tp)
end
function c95477924.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95477924.cfilter,1,nil,tp)
end
function c95477924.tgfilter(c,e,tp,g)
	return g:IsContains(c) and Duel.IsExistingMatchingCard(c95477924.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c95477924.spfilter(c,e,tp,code)
	return c:IsCode(46986414,38033121) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function c95477924.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c95477924.cfilter,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c95477924.tgfilter(chkc,e,tp,g) end
	if chk==0 then return Duel.IsExistingTarget(c95477924.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,g)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c95477924.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c95477924.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local code=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c95477924.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,code)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
