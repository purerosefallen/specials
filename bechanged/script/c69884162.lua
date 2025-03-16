--E・HERO アナザー・ネオス
function c69884162.initial_effect(c)
	aux.EnableDualAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,69884162+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c69884162.spcon)
	e1:SetTarget(c69884162.sptg)
	e1:SetOperation(c69884162.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--code
	aux.EnableChangeCode(c,89943723,LOCATION_MZONE,aux.IsDualState)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(aux.IsDualState)
	e2:SetTarget(c69884162.thtg)
	e2:SetOperation(c69884162.thop)
	c:RegisterEffect(e2)
end
function c69884162.spfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9,0x1f,0x3008) and c:IsControler(tp) and Duel.GetMZoneCount(tp,c)>0
end
function c69884162.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:IsLocation(LOCATION_HAND) or Duel.CheckReleaseGroupEx(tp,c69884162.spfilter,1,REASON_SPSUMMON,true,c,tp)
end
function c69884162.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	if c:IsLocation(LOCATION_DECK) then
		local g=Duel.GetReleaseGroup(tp,true,REASON_SPSUMMON):Filter(c69884162.spfilter,c,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local tc=g:SelectUnselect(nil,tp,false,true,1,1)
		if tc then
			e:SetLabelObject(tc)
			return true
		else return false end
	elseif c:IsLocation(LOCATION_HAND) then return true end
end
function c69884162.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if c:IsLocation(LOCATION_DECK) then
		local g=e:GetLabelObject()
		Duel.Release(g,REASON_SPSUMMON)
	else return true end
end
function c69884162.thfilter(c)
	return c:IsSetCard(0x9,0x1f,0x3008) and c:IsAbleToHand()
end
function c69884162.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69884162.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c69884162.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c69884162.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
