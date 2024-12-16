function Auxiliary.PreloadUds()
    local chk_effect = {false, false}
    local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function (e)
        for tp = 0, 1, 1 do
            local g = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
            if g:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(2857636, 1)) then
                local ct = Duel.SendtoDeck(g, tp, SEQ_DECKBOTTOM, REASON_RULE)
                Duel.Draw(tp, ct, REASON_RULE)
                Duel.ShuffleDeck(tp)
            end
        end
        e:Reset()
    end)
	Duel.RegisterEffect(e1,0)
    local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(function (e)
        if Duel.GetCurrentPhase() ~= PHASE_DRAW  then return end
        for tp = 0, 1, 1 do
            if Duel.GetLP(tp) > 4000 or chk_effect[tp] then goto continue end
            if Duel.IsExistingMatchingCard(nil, tp, LOCATION_DECK, 0, 1, nil) and Duel.SelectYesNo(tp, aux.Stringid(49838105, 1)) then
                chk_effect[tp] = true
                local g = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_DECK, 0, 1, 1, nil)
                Duel.MoveSequence(g:GetFirst(), SEQ_DECKTOP)
            end
            ::continue::
        end
    end)
	Duel.RegisterEffect(e2,0)
end