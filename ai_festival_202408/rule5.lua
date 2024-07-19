SP_RULE={}
--如果没有规则卡，填false
SP_RULE.Card=85742772
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = false
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 0

SP_RULE.RuleName="重力博弈"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message={"所有怪兽得到以下效果外文本。",
                    "·结束阶段发动。给予对方基本分伤害，数值为自己场上星级/阶级总和*200点。此类效果1回合只能使用1次。","·这张卡的攻击力下降这张卡的星级/阶级*200。"}

--第一个抽卡阶段执行，tp是AI
function SP_RULE.InitAdjust(tp)
    local g=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND)
    for tc in aux.Next(g) do
        if tc:IsType(TYPE_MONSTER) then
            --Atk update
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_UNCOPYABLE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetValue(SP_RULE.atkval)
            c:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetDescription(aux.Stringid(97342942,0))
            e2:SetCategory(CATEGORY_DAMAGE)
            e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
            e2:SetRange(LOCATION_MZONE)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_UNCOPYABLE)
            e2:SetCode(EVENT_PHASE+PHASE_END)
            e2:SetCountLimit(1,98765432)
            e2:SetOperation(SP_RULE.operation)
            c:RegisterEffect(e2)
        end
    end
end
function SP_RULE.atkval(e,c)
	local tp=c:GetControler()
    local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
    return -g:GetSum(SP_RULE.sum)
end

function SP_RULE.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
    local x=g:GetSum(SP_RULE.sum)
    Duel.Damage(1-tp,x,REASON_RULE)
end

function SP_RULE.sum(c)
    if c:IsLevelAbove(1) then return c:GetLevel()*200 end
    if c:IsRankAbove(1) then return c:GetRank()*200 end
    return 0
end