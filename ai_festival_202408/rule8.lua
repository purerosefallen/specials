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
	for p=0,1 do
		local c=Duel.CreateToken(p,52503575)
		Duel.MoveToField(c,p,p,LOCATION_SZONE,POS_FACEUP,true)
	end
end

--给规则卡添加效果。只会执行一次。
function SP_RULE.InitRuleCard(c)
	--double damage
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_EXTRA)
    e1:SetTargetRange(1,0)
    e1:SetValue(function (e,re,val,r,rp,rc)
		return val*2
	end)
    c:RegisterEffect(e1)
end