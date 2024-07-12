SP_RULE={}
--如果没有规则卡，填false
SP_RULE.Card=37576645
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = false
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 0

SP_RULE.RuleName="贪欲沼泽"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message=["双方场上各发动1张【蛇毒沼泽】。"]

--第一个抽卡阶段执行，tp是AI
function SP_RULE.InitAdjust(tp)
    local c=Duel.CreateToken(tp,54306223)
    Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
    c=Duel.CreateToken(1-tp,54306223)
    Duel.MoveToField(c,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
end
