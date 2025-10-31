local function FirstTurn()
    local a = Duel.GetTurnCount(0)
    local b = Duel.GetTurnCount(1)
    return a + b == 1
end

aux.PreloadUds = function ()
	local e = Effect.GlobalEffect()
		e:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		e:SetCode(EVENT_PHASE + PHASE_DRAW)
		e:SetCountLimit(1)
		e:SetCondition(FirstTurn)
		e:SetOperation(function ()
			Duel.Draw(0, 1, REASON_RULE)
		end)
	Duel.RegisterEffect(e, 0)
end
