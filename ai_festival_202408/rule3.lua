SP_RULE={}
--如果没有规则卡，填false
SP_RULE.Card=18756904
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = false
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 0

SP_RULE.RuleName="讨价还价"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message={"双方的所有怪兽得到以下效果外文本：","·这张卡造成战斗伤害时发动。自己回复战斗伤害的数值。"}

--第一个抽卡阶段执行，tp是AI
function SP_RULE.InitAdjust(tp)
    local g=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND)
    for tc in aux.Next(g) do
        if tc:IsType(TYPE_MONSTER) then
            local e2=Effect.CreateEffect(c)
            e2:SetDescription(aux.Stringid(545781,0))
            e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
            e2:SetCode(EVENT_BATTLE_DAMAGE)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_UNCOPYABLE)
            e2:SetOperation(SP_RULE.operation)
            c:RegisterEffect(e2)
        end
    end
end

function SP_RULE.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(tp,ev,REASON_RULE)
end