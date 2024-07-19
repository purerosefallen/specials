CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "最强谐星"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    local c=Duel.CreateToken(rp,33396958)
    if Duel.GetMZoneCount(rp)<5 or not c:IsCanBeSpecialSummoned(e,0,rp,true,true) then
        return name .. "看了一场很有趣的演出，但并没有什么卵用。"
    end
    return name .. "得到了来自谐星的一份大礼！"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    if Duel.GetMZoneCount(rp)<5 then return end
    for i in {33396958,8124921,44519536,70903634,7902349} do
        local c=Duel.CreateToken(rp,i)
        Duel.SpecialSummon(c,0,rp,rp,true,true,POS_FACEUP)
    end
end