--在这里切换阶段
local rule_number = 2

function Auxiliary.PreloadUds()
    Duel.LoadScript("special-step" .. tostring(rule_number) .. ".lua")
    CUNGUI.PreloadUds()
end

function Auxiliary.NoCardsInExtra(e)
	return Auxiliary.GetExtra(e,e:GetHandlerPlayer()):GetCount()==0
end

function Auxiliary.GetExtra(e,tp)
	return Duel.GetMatchingGroup(function (c)
        return c:IsFacedown() or c:IsType(TYPE_PENDULUM)
    end,tp,LOCATION_EXTRA,0,nil)
end