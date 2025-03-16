--聖刻龍－ウシルドラゴン
function c30794966.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c30794966.hspcon)
	e1:SetTarget(c30794966.hsptg)
	e1:SetOperation(c30794966.hspop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c30794966.desreptg)
	e2:SetOperation(c30794966.desrepop)
	c:RegisterEffect(e2)
	--release
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,30794966)
	e3:SetCost(c30794966.cost)
	e3:SetTarget(c30794966.rltg)
	e3:SetOperation(c30794966.rlop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,30794966+1)
	e4:SetTarget(c30794966.thtg)
	e4:SetOperation(c30794966.thop)
	c:RegisterEffect(e4)
end
function c30794966.thfilter(c)
	return c:IsSetCard(0x69) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c30794966.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30794966.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c30794966.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c30794966.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c30794966.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c30794966.rlfilter(c)
	return c:IsSetCard(0x69) and c:IsType(0x1) and c:IsReleasableByEffect()
end
function c30794966.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c30794966.rlfilter,tp,0x3,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c30794966.rlop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c30794966.rlfilter,tp,0x3,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Release(g,REASON_EFFECT)
	end
end
function c30794966.rfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToDeckAsCost()
		and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsType(TYPE_NORMAL))
end
function c30794966.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c30794966.rfilter,tp,LOCATION_GRAVE,0,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:CheckSubGroup(aux.gffcheck,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,Card.IsType,TYPE_NORMAL)
end
function c30794966.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c30794966.rfilter,tp,LOCATION_GRAVE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,aux.gffcheck,true,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,Card.IsType,TYPE_NORMAL)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c30794966.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoDeck(g,nil,1,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c30794966.repfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x69) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c30794966.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE)
		and Duel.CheckReleaseGroupEx(tp,c30794966.repfilter,1,REASON_EFFECT,true,c) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectReleaseGroupEx(tp,c30794966.repfilter,1,1,REASON_EFFECT,true,c)
		e:SetLabelObject(g:GetFirst())
		return true
	else return false end
end
function c30794966.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Release(tc,REASON_EFFECT)
end
