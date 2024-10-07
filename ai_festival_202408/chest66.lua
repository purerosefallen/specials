CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Message = "天上开始下金币雨了！"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    local g=Duel.GetFieldGroupCount(rp,LOCATION_HAND,0)
    local g2=Duel.GetFieldGroupCount(1-rp,LOCATION_HAND,0)
    if g>=6 and g2>=6 then return "但在场的人都是大富翁，没人愿意低头去捡钱……" end
    return "大家开始捡金币了！"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local d1=6-Duel.GetFieldGroupCount(rp,LOCATION_HAND,0)
    local d2=6-Duel.GetFieldGroupCount(1-rp,LOCATION_HAND,0)
    if d1>0 then
        Duel.Draw(rp,d1,REASON_RULE)
    end
    if d2>0 then
        Duel.Draw(rp,d2,REASON_RULE)
    end
end