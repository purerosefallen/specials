--House Rules Duel: Use Three Draw One
--In this duel, both players each have a counter.
--When cards leave the hand, the corresponding player's counter increases by 1.
--When the counter reaches 3, that player draws 1 card and the counter decreases by 3.

USE3DRAW1={
	leaveCount={[0]=0,[1]=0},
	prevCount={[0]=-1,[1]=-1},
	inDraw=false,
	countCards={
		[0]={[1]=40640057,[2]=11662742}, -- クリボー and ジェルエンデュオ
		[1]={[1]=15232745,[2]=42230449}  -- No.1 ゲート・オブ・ヌメロン－エーカム and No.2 ゲート・オブ・ヌメロン－ドゥヴェー
	},
	drawCards={[0]=33784505,[1]=4896788} -- 壺盗み and 強欲な壺の精霊
}

function Auxiliary.PreloadUds()
	--global field effect to count cards leaving hand
	local e1 = Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCondition(USE3DRAW1.Condition)
	e1:SetOperation(USE3DRAW1.CountOperation)
	Duel.RegisterEffect(e1,0)
end

function USE3DRAW1.Condition(e,tp,eg,ep,ev,re,r,rp)
	--Suspend the effect if a draw is currently happening
	return not USE3DRAW1.inDraw
end

function USE3DRAW1.CountOperation(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end

	local g=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND)
	if #g==0 then
		return
	end

	---@type Card
	for tc in aux.Next(g) do
		local owner=tc:GetPreviousControler()
		USE3DRAW1.leaveCount[owner]=USE3DRAW1.leaveCount[owner]+1
	end

	USE3DRAW1.inDraw=true

	-- Check all players for draws
	for player=0,1 do
		local count=USE3DRAW1.leaveCount[player]
		local drewCards=false
		while count>=3 do
			if Duel.IsPlayerCanDraw(player,1) then
				if not drewCards then
					Duel.Hint(HINT_CARD,0,USE3DRAW1.drawCards[player])
					drewCards=true
				end
				Duel.Draw(player,1,REASON_RULE)
			end
			count=count-3
		end
		USE3DRAW1.leaveCount[player]=count
		-- Show the current count card only if it changed
		if count~=USE3DRAW1.prevCount[player] then
			local cardId=USE3DRAW1.countCards[player][count]
			if cardId then
				Duel.Hint(HINT_CARD,player,cardId)
			end
			USE3DRAW1.prevCount[player]=count
		end
	end

	USE3DRAW1.inDraw=false
end
