CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "绝望"

--效果名称。同样二选一，EffectMessage优先级更高。
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    if rp == CUNGUI.AI then name = CUNGUI.GetAIName() end
    local g=Duel.GetFieldGroup(rp,0,LOCATION_MZONE)
    if #g>0 then
        return name .. "顿时觉得眼前的敌人高不可攀……"
    end
    return "但" .. name .. "意志坚定，并未受到影响！"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local g=Duel.GetFieldGroup(rp,0,LOCATION_MZONE)
    for c in aux.Next(g) do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(100000)
        c:RegisterEffect(e1)
    end
end