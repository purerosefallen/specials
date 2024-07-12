CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Message = "结果宝箱里突然飘出了一股甜甜的迷雾！"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    local c=Duel.CreateToken(1-rp,31305911)
    if Duel.GetMZoneCount(1-rp)<1
        or not Duel.IsCanBeSpecialSummoned(c,0,1-rp,true,true) then return "然而，场上似乎并没有什么变化……" end
    return "迷雾散去，" .. name2 .. "的场上似乎变甜了！"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    while Duel.GetMZoneCount(1-rp)>0 do
        local c=Duel.CreateToken(1-rp,31305911)
        if Duel.SpecialSummonStep(c,0,1-rp,1-rp,true,true,POS_FACEUP_DEFENSE)<1 then
            break
        end
    end
    Duel.SpecialSummonComplete()
end