--聖刻神龍－エネアード
function c64332231.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,c64332231.ovfilter,aux.Stringid(64332231,1),2,c64332231.xyzop)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64332231,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(c64332231.descost)
	e1:SetTarget(c64332231.destg)
	e1:SetOperation(c64332231.desop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(c64332231.tdcon)
	e2:SetTarget(c64332231.tdtg)
	e2:SetOperation(c64332231.tdop)
	c:RegisterEffect(e2)
end
function c64332231.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x69) and c:IsType(TYPE_XYZ)
end
function c64332231.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,64332231)==0 end
	Duel.RegisterFlagEffect(tp,64332231,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c64332231.tdcfilter(c,tp)
	return c:IsType(TYPE_MONSTER)
end
function c64332231.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c64332231.tdcfilter,1,e:GetHandler(),tp)
end
function c64332231.tdfilter(c)
	return c:IsSetCard(0x69) and c:IsAbleToDeck()
end
function c64332231.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=eg:FilterCount(c64332231.tdcfilter,e:GetHandler(),tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c64332231.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c64332231.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c64332231.tdfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c64332231.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c64332231.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c64332231.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,nil,1,REASON_EFFECT,true,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c64332231.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local rg=Duel.SelectReleaseGroupEx(tp,nil,1,99,REASON_EFFECT,true,nil)
	local ct2=Duel.Release(rg,REASON_EFFECT)
	if ct2==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct2,nil)
	Duel.HintSelection(dg)
	Duel.Destroy(dg,REASON_EFFECT)
end
