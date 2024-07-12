CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "中型黑洞"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    if Duel.GetFieldGroupCount(1-rp,LOCATION_HAND,0)<1 then
        return "但" .. name2 .. "站得太远了！"
    end
    return name2 .. "的手卡被吸进了黑洞！"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local g=Duel.GetFieldGroup(1-rp,LOCATION_HAND,0)
    if #g>3 then g=g:RandomSelect(1-rp,3)
    Duel.SendtoGrave(g,REASON_RULE+REASON_DISCARD)
end