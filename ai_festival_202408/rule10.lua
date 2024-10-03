SP_RULE={}
--如果没有规则卡，填false
SP_RULE.Card=67464807
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = false
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 0

SP_RULE.RuleName="不得不赌"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message={"AI场上召唤一只宝箱怪。"}

--开局执行；此时还无法得知谁是AI。
function SP_RULE.Init()
    
end

--第一个抽卡阶段执行，tp是AI。
function SP_RULE.InitAdjust(tp)
	local c=CUNGUI.CreateChestStep(tp)
	if c then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(10000)
		c:RegisterEffect(e1)
		e1=e1:Clone()
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end

--给规则卡添加效果。只会执行一次。
function SP_RULE.InitRuleCard(c)
    
end