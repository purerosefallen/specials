--透破抜き
function c65703851.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c65703851.condition)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(c65703851.activate)
	c:RegisterEffect(e1)
end
function c65703851.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc,eff=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_EFFECT)
	return (loc==LOCATION_HAND or loc==LOCATION_GRAVE) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and eff:GetLabel()~=65703851 --相杀算场上发动统一使用透破拔卡片密码标记处理类透破拔条件
end
function c65703851.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
