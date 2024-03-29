function operate(tp)
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local eg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,mg)
	Duel.Hint(tp,HINT_SELECTMSG,HINTMSG_OPPO)
	local rg=mg:Select(tp,3,3,nil)
	Duel.ConfirmCards(tp,eg)
	if #eg>0 then
		Duel.Hint(tp,HINT_SELECTMSG,HINTMSG_OPPO)
		local rg2=eg:Select(tp,1,1,nil)
		rg:Merge(rg2)
	end
	Duel.ShuffleDeck(1-tp)
	Duel.ShuffleExtra(1-tp)
	Duel.Exile(rg,REASON_RULE)
	Duel.ShuffleDeck(1-tp)
	Duel.ShuffleExtra(1-tp)
end

function inititialize()
	operate(0)
	operate(1)
	Duel.Draw(0,5,REASON_RULE)
	Duel.Draw(1,5,REASON_RULE)
end

function Auxiliary.PreloadUds()
	-- one more draw
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		inititialize()
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end
