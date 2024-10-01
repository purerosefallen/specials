CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "最强宝藏"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
CHEST.EffectMessage = "得到了无穷的力量！"

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local table = {33396948,8124921,44519536,70903634,7902349}
    for _,i in ipairs(table) do
        local c=Duel.CreateToken(rp,i)
        Duel.SendtoHand(c,nil,REASON_RULE)
    end
end