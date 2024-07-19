CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "欲望之香"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
CHEST.EffectMessage = "得到了可怕的力量！"

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    for i in {55144522,55144522,55144522,55144522,55144522} do
        local c=Duel.CreateToken(rp,i)
        Duel.SendtoHand(c,nil,REASON_RULE)
    end
end