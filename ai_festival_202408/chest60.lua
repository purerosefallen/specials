CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "手札抹杀"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
CHEST.EffectMessage = "使用了手札抹杀！"

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
	local h1=Duel.GetFieldGroupCount(rp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(rp,0,LOCATION_HAND)
	local g=Duel.GetFieldGroup(rp,LOCATION_HAND,LOCATION_HAND)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	Duel.BreakEffect()
	Duel.Draw(rp,h1,REASON_EFFECT)
	Duel.Draw(1-rp,h2,REASON_EFFECT)
end