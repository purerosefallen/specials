SP_RULE={}
--如果没有规则卡，填false
SP_RULE.Card=8868767
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = false
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 0

SP_RULE.RuleName="死亡轮盘"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message={"开局时，双方LP回复92000，所有怪兽得到以下效果外文本：",
                    "·这张卡给对方造成战斗伤害时发动。自己投1次骰子。","投到6的场合，给对方造成100000点伤害。"}

--开局执行；此时还无法得知谁是AI。
function SP_RULE.Init()
    Duel.Recover(tp,92000,REASON_RULE)
    Duel.Recover(1-tp,92000,REASON_RULE)
end

--第一个抽卡阶段执行，tp是AI
function SP_RULE.InitAdjust(tp)
    local g=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND)
    for tc in aux.Next(g) do
        if tc:IsType(TYPE_MONSTER) then
            local e2=Effect.CreateEffect(c)
            e2:SetDescription(aux.Stringid(545781,1))
            e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
            e2:SetCode(EVENT_BATTLE_DAMAGE)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_UNCOPYABLE)
            e2:SetOperation(SP_RULE.operation)
            c:RegisterEffect(e2)
        end
    end
end

function SP_RULE.operation(e,tp)
    local d=Duel.TossDice(tp,1)
    if d==6 then
        Duel.Damage(1-tp,100000,REASON_RULE)
    end
end