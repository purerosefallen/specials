--ホルスの黒炎竜 LV4
---@param c Card
function c75830094.initial_effect(c)
	aux.AddCodeList(c,16528181)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,75830094+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c75830094.sprcon)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e2)
	--search or special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75830094,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,75830095)
	e3:SetCondition(c75830094.spcon)
	e3:SetTarget(c75830094.sptg)
	e3:SetOperation(c75830094.spop)
	c:RegisterEffect(e3)
end
c75830094.lvup={11224103}
function c75830094.sprfilter(c)
	return c:IsFaceup() and c:IsCode(16528181)
end
function c75830094.sprcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75830094.sprfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c75830094.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and re:IsActivated()
end
function c75830094.spfilter(c,lv,e,tp)
	if not (c:IsRace(RACE_DRAGON) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x19d) and c:IsLevelAbove(lv+1)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75830094.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return Duel.IsExistingMatchingCard(c75830094.spfilter,tp,LOCATION_DECK,0,1,nil,lv,e,tp) end
end
function c75830094.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c75830094.spfilter,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			if tc:IsCode(11224103) and tc:IsLocation(LOCATION_MZONE) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(75830094,1)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
