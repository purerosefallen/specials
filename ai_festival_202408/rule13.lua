SP_RULE={}
--如果没有规则卡，填false
SP_RULE.Card=93983867
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = false
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 0

SP_RULE.RuleName="葬送的宝箱怪"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message={"本局游戏中，宝箱怪出现时攻防皆为5000点。"}

local ccs = CUNGUI.CreateChestStep
CUNGUI.CreateChestStep = function(tp)
    local c=ccs(tp)
    if not c then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    e1:SetValue(5000)
    c:RegisterEffect(e1)
    e1=e1:Clone()
    e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
    c:RegisterEffect(e1)
    return c
end