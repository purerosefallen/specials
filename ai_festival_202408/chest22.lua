CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "缝合线套装"
CHEST.EffectMessage = "给自己进行了紧急缝合！"

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    Duel.SetLP(rp,Duel.GetLP(rp) * 2)
end