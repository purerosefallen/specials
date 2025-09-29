function aux.PreloadUds()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		for tp=0,1 do
			local player_type = Duel.GetRegistryValue("player_type_" .. tostring(tp))
			local key = "redrew_" .. player_type
			if not Duel.GetRegistryValue(key) and Duel.SelectYesNo(tp,1297) then
				local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
				Duel.SendtoDeck(g,nil,0,REASON_RULE)
				local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,3,3,nil)
				Duel.SendtoHand(sg,nil,REASON_RULE)
				Duel.ShuffleDeck(tp)
				Duel.SetRegistryValue(key, '1')
			end
		end
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end
