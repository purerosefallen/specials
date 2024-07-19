SP_RULE={}
--如果没有规则卡，填false
SP_RULE.Card=5616412
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = false
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 0

SP_RULE.RuleName="拳拳到肉"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message={"双方场上各发动1张【最终突击命令】。双方受到的战斗伤害变为2倍。"}

--第一个抽卡阶段执行，tp是AI
function SP_RULE.InitAdjust(tp)
    local c=Duel.CreateToken(tp,52503575)
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    c=Duel.CreateToken(1-tp,52503575)
    Duel.MoveToField(c,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
end

--给规则卡添加效果。只会执行一次。
function SP_RULE.InitRuleCard(c)
	--double damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TRUE)
	e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e3)
end