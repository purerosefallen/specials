CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "机械降神装置"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    local c=Duel.CreateToken(rp,10000000)
    if Duel.GetMZoneCount(rp)<3 or not c:IsCanBeSpecialSummoned(e,0,rp,true,true) then
        return "不过这个装置似乎坏掉了……"
    end
    return name .. "使用了装置！"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local t = {10000000,10000010,10000020}
    for _,i in ipairs(t) do
        local c=Duel.CreateToken(rp,i)
        Duel.SpecialSummon(c,0,rp,rp,true,true,POS_FACEUP)
    end
end