CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))

function CHEST.EffectMessageAbsolute(e,rp)
    local g=Duel.GetFieldGroup(rp,LOCATION_MZONE,0)
    if #g == 0 then return "然而什么都没有发生……"
    return "被风刮到的怪兽们似乎变大了！"
end

function CHEST.MessageAbsolute(rp)
    local name=CUNGUI.GetPlayerName()
    if rp == CUNGUI.AI then name = CUNGUI.GetAIName() end

    return "结果宝箱里突然刮出了一股棕色的风，朝着" .. name .. "而去！"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local g=Duel.GetFieldGroup(rp,LOCATION_MZONE,0)
    for c in aux.Next(g) do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c:GetAttack() * 2)
        c:RegisterEffect(e1)
    end
end