--在这里切换阶段
local rule_number = 3

function Auxiliary.PreloadUds()
    Duel.LoadScript("special-step" .. tostring(rule_number) .. ".lua")
    CUNGUI.PreloadUds()
end