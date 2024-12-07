--ヴァイロン・マター
---@param c Card
function c41858121.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c41858121.target)
	e1:SetOperation(c41858121.activate)
	c:RegisterEffect(e1)
end
function c41858121.filter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToDeck()
end
function c41858121.thfilter(c)
	return c:IsSetCard(0x30) and c:IsAbleToHand()
end
function c41858121.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
	local b3=Duel.IsExistingMatchingCard(c41858121.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(41858121,0)},
		{b2,aux.Stringid(41858121,1)},
		{b3,aux.Stringid(41858121,2)})
	e:SetLabel(op)
	if op==1 then Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) end
	if op==2 then Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD) end
	if op==3 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK) end
end
function c41858121.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local ck=false
	if op==1 then
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then ck=true end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if Duel.Destroy(dg,REASON_EFFECT)>0 then ck=true end
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c41858121.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			if Duel.SendtoHand(g,nil,REASON_EFFECT) then
				Duel.ConfirmCards(1-tp,g)
				ck=true
			end
		end
	end
	local dg=Duel.GetMatchingGroup(c41858121.filter,tp,LOCATION_GRAVE,0,nil)
	if ck==true and #dg>=3 and Duel.SelectYesNo(tp,aux.Stringid(41858121,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=dg:Select(tp,3,3,nil)
		Duel.BreakEffect()
		Duel.SendtoDeck(sg,nil,2,0x40)
	end
end