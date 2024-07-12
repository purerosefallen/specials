CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "狂赌之渊"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    if Duel.GetLocationCount(rp,LOCATION_SZONE)+Duel.GetLocationCount(1-rp,LOCATION_SZONE)<1 then
        return "但在场的人都没有心思再赌了！"
    end
    return "决斗者们摩拳擦掌准备大赌一场！"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local code=0
    local c=nil
    for p in [0,1] do
        code=CUNGUI.GambleCards[math.random(#CUNGUI.GambleCards)]
        c=Duel.CreateToken(p,code)
        while Duel.SSet(p,c)>0 do
            code=CUNGUI.GambleCards[math.random(#CUNGUI.GambleCards)]
            c=Duel.CreateToken(p,code)
        end
    end
end