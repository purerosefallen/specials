CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "五条悟"

--效果名称。同样二选一，EffectMessage优先级更高。
CHEST.EffectMessage = "脸色一暗：我学五条悟？真的假的？"

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    Duel.SetLP(rp,math.ceil(Duel.GetLP(rp) / 2))
end