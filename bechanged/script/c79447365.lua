--トゥーン・マスク
function c79447365.initial_effect(c)
	aux.AddCodeList(c,15259703)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c79447365.condition)
	e1:SetTarget(c79447365.target)
	e1:SetOperation(c79447365.activate)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79447365,0))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(c79447365.handcon)
	c:RegisterEffect(e4)
end
function c79447365.filter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c79447365.handcon(e)
	return Duel.IsExistingMatchingCard(c79447365.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c79447365.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c79447365.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79447365.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c79447365.filter(c,e,tp)
	local lv=0
	if c:IsType(TYPE_XYZ) then
		lv=c:GetRank()
	else
		lv=c:GetLevel()
	end
	return c:IsFaceup() and (Duel.IsExistingMatchingCard(c79447365.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,lv) or c:IsControlerCanBeChanged())
end
function c79447365.spfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv) and c:IsType(TYPE_TOON) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c79447365.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c79447365.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c79447365.filter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c79447365.filter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
end
function c79447365.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local lv=0
	if tc:IsType(TYPE_XYZ) then
		lv=tc:GetRank()
	else
		lv=tc:GetLevel()
	end
	if Duel.IsExistingMatchingCard(c79447365.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,lv) and (not tc:IsControlerCanBeChanged() or Duel.SelectYesNo(tp,aux.Stringid(79447365,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c79447365.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,lv)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	elseif tc:IsControlerCanBeChanged() then
		Duel.GetControl(tc,tp)
	end
end
