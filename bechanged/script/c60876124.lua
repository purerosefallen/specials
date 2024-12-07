--レア・ヴァリュー
---@param c Card
function c60876124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60876124.target)
	e1:SetOperation(c60876124.activate)
	c:RegisterEffect(e1)
end
function c60876124.filter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x1034) and c:IsAbleToGrave()
end
function c60876124.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c60876124.filter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c60876124.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60876124.filter,tp,LOCATION_HAND+LOCATION_SZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		if sg:GetFirst():IsLocation(LOCATION_GRAVE) then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end
