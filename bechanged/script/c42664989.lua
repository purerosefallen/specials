--天よりの宝札
function c42664989.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c42664989.target)
	e1:SetOperation(c42664989.operation)
	c:RegisterEffect(e1)
end
function c42664989.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetTurnCount()-Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,e:GetHandler())
	local ct2=Duel.GetTurnCount()-Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_HAND,e:GetHandler())
	if ct1>6 then ct1=6 end
	if ct2>6 then ct2=6 end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct1) or Duel.IsPlayerCanDraw(1-tp,ct2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct2)
end
function c42664989.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetTurnCount()-Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,e:GetHandler())
	local ct2=Duel.GetTurnCount()-Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_HAND,e:GetHandler())
	if ct1>6 then ct1=6 end
	if ct2>6 then ct2=6 end
	local bk=false
	if ct1>0 then
		Duel.Draw(tp,ct1,REASON_EFFECT)
		bk=true
	end
	if ct2>0 then
		if bk then Duel.BreakEffect() end
		Duel.Draw(1-tp,ct2,REASON_EFFECT)
	end
end
