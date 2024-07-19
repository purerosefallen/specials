SP_RULE={}
--如果没有规则卡，填false
SP_RULE.Card=10000
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = false
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 0

SP_RULE.RuleName="规则名称"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message={"规则详细介绍第一行","规则详细介绍第二行"}

--开局执行；此时还无法得知谁是AI。
function SP_RULE.Init()
    
end

--第一个抽卡阶段执行，tp是AI。
function SP_RULE.InitAdjust(tp)
    CUNGUI.CreateChestStep(tp)
end

--给规则卡添加效果。只会执行一次。双方各有1张规则卡。
function SP_RULE.InitRuleCard(c)
    
end