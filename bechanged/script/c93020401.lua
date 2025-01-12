--灯影之机界骑士
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.hspcon)
	e1:SetValue(s.hspval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)

end
function s.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function s.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return 0,zone
end
function s.spcfilter(c,tp,mc)
	if c:IsPreviousControler(tp) then return false end
	local zone=mc:GetColumnZone(LOCATION_ONFIELD)
	local seq=c:GetPreviousSequence()+16
	if c:IsPreviousLocation(LOCATION_SZONE) then seq=seq+8 end
	return zone and bit.extract(zone,seq)~=0
end
function s.jfilter(c)
	return c:IsSetCard(0x10c)and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(s.jfilter,tp,LOCATION_ONFIELD,0,nil)
	local chk=false
	local mc=mg:GetFirst()
	while chk==false and mc do
		chk=eg:IsExists(s.spcfilter,1,nil,tp,mc)
		mc=mg:GetNext()
	end
	return chk
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x10c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_HAND)
end
function s.thfilter(c,tp)
	return  c:IsControler(1-tp) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,1-tp,LOCATION_ONFIELD)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_MZONE) then return end
	local g=c:GetColumnGroup()
	local tg=g:Filter(s.thfilter,nil,tp)
	if tg and #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
