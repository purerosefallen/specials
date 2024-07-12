CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "连接禁卡之门"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    local c=Duel.CreateToken(rp,37818794)
    if Duel.GetLocationCountFromEx(rp,rp,nil,c)<1 or not c:IsCanBeSpecialSummoned(e,0,rp,true,true) then
        return name2 .. "强行关闭了大门！"
    end
    return "“是谁在呼唤我？”"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local c=Duel.CreateToken(rp,37818794)
    Duel.SpecialSummon(c,0,rp,rp,true,true,POS_FACEUP)
end