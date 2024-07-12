CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Message = "结果宝箱里突然刮出了一股妖异的龙卷风！"

function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    local g=Duel.GetFieldGroup(1-rp,LOCATION_SZONE,0)
    if #g<1 then return "龙卷风静静地散去了……" end
    return name .. "场上的魔法陷阱卡被吹散了！"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local g=Duel.GetFieldGroup(1-rp,LOCATION_SZONE,0)
    Duel.Destroy(g,REASON_RULE)
end