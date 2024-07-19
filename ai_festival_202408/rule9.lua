SP_RULE={}
--如果没有规则卡，填false
SP_RULE.Card=63571750
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = false
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 0

SP_RULE.RuleName="财富之轮"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message={"双方场上特殊召唤3张宝箱怪。","那些宝箱怪的攻击力守备力变为2000。"}

--第一个抽卡阶段执行，tp是AI
function SP_RULE.InitAdjust(tp)
    for _=1,3 do
        for i=0,1 do
            local c=CUNGUI.CreateChestStep(i)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(2000)
            c:RegisterEffect(e1)
            e1=e1:Clone()
            e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
            c:RegisterEffect(e1)
        end
    end
	Duel.SpecialSummonComplete()
end
