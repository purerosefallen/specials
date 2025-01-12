--デスカイザー・ドラゴン／バスター
---@param c Card
function c1764972.initial_effect(c)
	aux.AddCodeList(c,80280737,33420078)
	c:EnableReviveLimit()
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.AssaultModeLimit)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1764972,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c1764972.cost)
	e1:SetTarget(c1764972.target)
	e1:SetOperation(c1764972.operation)
	c:RegisterEffect(e1)
	--Special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1764972,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c1764972.sptg1)
	e3:SetOperation(c1764972.spop1)
	c:RegisterEffect(e3)
	--Special summon2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1764972,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c1764972.spcon2)
	e4:SetTarget(c1764972.sptg2)
	e4:SetOperation(c1764972.spop2)
	c:RegisterEffect(e4)
end
c1764972.assault_name=6021033
function c1764972.costfilter1(c)
	return not c:IsPublic()
end
function c1764972.costfilter(c,tp)
	return (c:IsCode(33420078) or aux.IsCodeListed(c,33420078)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c1764972.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c1764972.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic()
		and Duel.IsExistingMatchingCard(c1764972.costfilter1,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c1764972.costfilter,tp,LOCATION_DECK,0,1,nil,tp) 
		and Duel.IsExistingMatchingCard(c1764972.costfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c1764972.costfilter1,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c1764972.costfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=Duel.SelectMatchingCard(tp,c1764972.costfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	sg:AddCard(tc)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c1764972.thfilter(c)
	return (aux.IsCodeListed(c,33420078) or aux.IsCodeListed(c,80280737)) and c:IsAbleToHand()
end
function c1764972.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1764972.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c1764972.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1764972.operation(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(c1764972.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c1764972.thfilter),tp,LOCATION_GRAVE,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1764972.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c1764972.thfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		g:AddCard(tc)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end
function c1764972.filter1(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1764972.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1764972.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1764972.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1764972.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c1764972.sfilter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1764972.spop1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c1764972.sfilter,nil,e,tp)
	if g:GetCount()==0 or g:GetCount()>ft or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return false end
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		tc:RegisterFlagEffect(1764972,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	g:KeepAlive()
	local de=Effect.CreateEffect(c)
	de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	de:SetCode(EVENT_PHASE+PHASE_END)
	de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	de:SetCountLimit(1)
	de:SetReset(RESET_PHASE+PHASE_END)
	de:SetLabel(fid)
	de:SetLabelObject(g)
	de:SetCondition(c1764972.descon)
	de:SetOperation(c1764972.desop)
	Duel.RegisterEffect(de,tp)
end
function c1764972.desfilter(c,fid)
	return c:GetFlagEffectLabel(1764972)==fid
end
function c1764972.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c1764972.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c1764972.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local dg=g:Filter(c1764972.desfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Destroy(dg,REASON_EFFECT)
end
function c1764972.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c1764972.spfilter2(c,e,tp)
	return c:IsCode(6021033) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1764972.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c1764972.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1764972.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1764972.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c1764972.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
