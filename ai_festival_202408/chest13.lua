CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "Knight of Hanoi"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    if Duel.GetLocationCount(1-rp,LOCATION_SZONE)<1 then return "然而汉诺骑士真是费拉不堪，什么作用都没有派上……" end
    return name2 .. "的防御更强了！"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local c={}
    local c[1]=Duel.CreateToken(1-rp,44095762)
    local c[2]=Duel.CreateToken(1-rp,61740673)
    local c[3]=Duel.CreateToken(1-rp,62279055)
    if Duel.GetLocationCount(1-rp,LOCATION_SZONE)>0 then
        Duel.SSet(1-rp,c[1])
    end
    if Duel.GetLocationCount(1-rp,LOCATION_SZONE)>0 then
        Duel.SSet(1-rp,c[2])
    end
    if Duel.GetLocationCount(1-rp,LOCATION_SZONE)>0 then
        Duel.SSet(1-rp,c[3])
    end
end