--魔導原典 クロウリー
---@param c Card
function c50756327.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SPELLCASTER),2,2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50756327,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,50756327)
	e1:SetCondition(c50756327.thcon)
	e1:SetTarget(c50756327.thtg)
	e1:SetOperation(c50756327.thop)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50756327,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCountLimit(1)
	e2:SetCondition(c50756327.ntcon)
	e2:SetTarget(c50756327.nttg)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,50756328)
	e3:SetTarget(c50756327.target)
	e3:SetOperation(c50756327.activate)
	c:RegisterEffect(e3)
end
function c50756327.deckconfilter(c)
	return c:IsCode(47679935,33981008) and c:IsFaceup()
end
function c50756327.deckcon(tp)
	return Duel.IsExistingMatchingCard(c50756327.deckconfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c50756327.cfilter(c)
	return c:IsCode(47679935,33981008) and c:IsAbleToGrave()
end
function c50756327.fselect(g,e,tp)
	return g:GetClassCount(Card.GetCode)==2 and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
		and Duel.IsExistingMatchingCard(c50756327.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function c50756327.spfilter(c,e,tp,g)
	return c:IsCode(11270236) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function c50756327.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if c50756327.deckcon(tp) then loc=loc|LOCATION_DECK end
	local g=Duel.GetMatchingGroup(c50756327.cfilter,tp,loc,0,nil)
	if chk==0 then return g:CheckSubGroup(c50756327.fselect,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c50756327.activate(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if c50756327.deckcon(tp) then loc=loc|LOCATION_DECK end
	local g=Duel.GetMatchingGroup(c50756327.cfilter,tp,loc,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local rg=g:SelectSubGroup(tp,c50756327.fselect,false,2,2,e,tp)
	if rg and Duel.SendtoGrave(rg,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c50756327.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
			sg:GetFirst():CompleteProcedure()
		end
	end
end
function c50756327.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c50756327.thfilter(c)
	return c:IsSetCard(0x106e) and c:IsAbleToHand()
end
function c50756327.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c50756327.thfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50756327.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c50756327.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,sg1)
		local cg=sg1:RandomSelect(1-tp,1)
		local tc=cg:GetFirst()
		tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
function c50756327.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c50756327.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_SPELLCASTER)
end
