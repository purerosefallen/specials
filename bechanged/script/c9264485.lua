--ホルスのしもべ
---@param c Card
function c9264485.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9264485+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9264485.spcon)
	c:RegisterEffect(e1)
	--to hand or special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,9264486)
	e2:SetCondition(c9264485.thcon)
	e2:SetTarget(c9264485.thtg)
	e2:SetOperation(c9264485.thop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x19d))
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c9264485.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsLevel(8) and c:IsSetCard(0x19d)
end
function c9264485.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9264485.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9264485.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c9264485.thfilter(c,e,tp)
	if not (c:IsRace(RACE_DRAGON) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x19d)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9264485.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9264485.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c9264485.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9264485.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
