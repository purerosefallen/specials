--无限起动 哥利亚巨人
function c23689428.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c23689428.matfilter,1,1)
	c:EnableReviveLimit()
	--Attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23689428,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,23689428)
	e1:SetCondition(c23689428.xyzcon)
	e1:SetTarget(c23689428.xyztg)
	e1:SetOperation(c23689428.xyzop)
	c:RegisterEffect(e1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(c23689428.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--tg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23689428,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCountLimit(1,23689429)
	e3:SetCost(c23689428.tgcost)
	e3:SetCondition(c23689428.tgcon)
	e3:SetTarget(c23689428.tgtg)
	e3:SetOperation(c23689428.tgop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(23689428,ACTIVITY_CHAIN,c23689428.chainfilter)
end

function c23689428.matfilter(c)
	return c:IsLinkSetCard(0x127) and not c:IsLinkType(TYPE_LINK)
end

function c23689428.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c23689428.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c23689428.filter2(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE)
end
function c23689428.xfilter3(c)
	return c:IsSetCard(0x127) and c:IsCanOverlay()
end
function c23689428.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c23689428.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23689428.filter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c23689428.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c23689428.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) and c:IsCanOverlay() then
		if Duel.Overlay(tc,Group.FromCards(c))~=0
		and c23689428.filter2(tc)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c23689428.xfilter3),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and tc:IsLocation(LOCATION_MZONE)
		and Duel.SelectYesNo(tp,aux.Stringid(23689428,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c23689428.xfilter3),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.Overlay(tc,g) end
		end
	end
end


function c23689428.condition(e)
	return e:GetHandler():GetOriginalRace()==RACE_MACHINE
end


function c23689428.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(23689428,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c23689428.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c23689428.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
	and Duel.IsExistingMatchingCard(c23689428.tgfilter,tp,LOCATION_DECK,0,1,nil)
end
function c23689428.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23689428.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c23689428.tgfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE)
	and c:IsAbleToGrave()
end
function c23689428.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c23689428.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function c23689428.chainfilter(re,tp,cid)
	return not re:GetHandler():IsType(TYPE_MONSTER) or ((re:GetHandler():IsRace(RACE_MACHINE) and re:GetHandler():IsAttribute(ATTRIBUTE_EARTH))
	or not (re:GetActivateLocation()==(LOCATION_GRAVE) or re:GetHandler():IsOnField()))
end
function c23689428.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER) and not(re:GetHandler():IsRace(RACE_MACHINE) and re:GetHandler():IsAttribute(ATTRIBUTE_EARTH)) 
	and (re:GetActivateLocation()==(LOCATION_GRAVE) or re:GetHandler():IsOnField())
end

