SP_RULE={}
--如果没有规则卡，填false
SP_RULE.Card=90502999
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = false
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 0

SP_RULE.RuleName="无法自拔"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message={"发动赌博卡时，召唤出宝箱怪的几率大幅增加。"}

--第一个抽卡阶段执行，tp是AI。
function SP_RULE.InitAdjust(tp)
    CUNGUI.ChestCheck = 3
end
