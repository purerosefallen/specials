--マスクド・チョッパー
---@param c Card
function c87350908.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87350908,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetLabel(65703851) --相杀算场上发动统一使用透破拔卡片密码标记处理类透破拔条件
	e1:SetCondition(aux.dserodcon)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetTarget(c87350908.damtg)
	e1:SetOperation(c87350908.damop)
	c:RegisterEffect(e1)
end
function c87350908.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c87350908.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
