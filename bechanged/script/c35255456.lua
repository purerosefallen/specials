--ミラクル・コンタクト
---@param c Card
function c35255456.initial_effect(c)
	aux.AddCodeList(c,89943723)
	aux.AddSetNameMonsterList(c,0x3008)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35255456,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,35255456)
	e1:SetTarget(c35255456.thtg)
	e1:SetOperation(c35255456.thop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35255456,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c35255456.target)
	e2:SetOperation(c35255456.activate)
	c:RegisterEffect(e2)
end
function c35255456.ffilter(c,tp)
	return c:IsType(TYPE_FUSION) and aux.IsCodeListed(c,89943723)
		and Duel.IsExistingMatchingCard(c35255456.thfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function c35255456.thfilter(c,fc)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsType(TYPE_MONSTER)
		 and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c35255456.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35255456.ffilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
end
function c35255456.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c35255456.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.GetMatchingGroup(c35255456.thfilter,tp,LOCATION_DECK,0,nil,tc)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
		if sg and sg:GetCount()>0 then
			local tc=sg:GetFirst()
			if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			else
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end
function c35255456.filter(c)
	return c:IsCode(42015635,14088859) and c:IsAbleToHand()
end
function c35255456.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35255456.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c35255456.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c35255456.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end