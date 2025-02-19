--カップ・オブ・エース
---@param c Card
function c37812118.initial_effect(c)
	aux.AddCodeList(c,73206827)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c37812118.target)
	e1:SetOperation(c37812118.activate)
	c:RegisterEffect(e1)
end
function c37812118.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c37812118.activate(e,tp,eg,ep,ev,re,r,rp)
	local res
	if Duel.IsEnvironment(73206827,tp,LOCATION_FZONE) then
		local off=1
		local ops={}
		local opval={}
		if Duel.IsPlayerCanDraw(tp,2) then
			ops[off]=aux.Stringid(37812118,1)
			opval[off-1]=0
			off=off+1
		end
		if Duel.IsPlayerCanDraw(1-tp,2) then
			ops[off]=aux.Stringid(37812118,2)
			opval[off-1]=1
			off=off+1
		end
		if off==1 then return end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		res=opval[op]
	else
		res=1-Duel.TossCoin(tp,1)
	end
	if res==0 then Duel.Draw(tp,2,REASON_EFFECT)
	else Duel.Draw(1-tp,2,REASON_EFFECT) end
end
