--暗闇を吸い込むマジック・ミラー
---@param c Card
function c99735427.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c99735427.disop)
	c:RegisterEffect(e2)
end
function c99735427.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc,eff=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_EFFECT)
	-- 临时添加被武僧洗回卡组的反转效果无效 相杀算场上发动统一使用透破拔卡片密码标记处理类透破拔条件
	local c=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT):GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and (loc==LOCATION_MZONE or loc==LOCATION_GRAVE or (loc==LOCATION_DECK and c:GetFlagEffect(44178886)>0) or ((loc==LOCATION_GRAVE or loc==LOCATION_REMOVED) and eff:GetLabel()==65703851) )
		and re:GetHandler():IsAttribute(ATTRIBUTE_DARK) then
		Duel.NegateEffect(ev)
	end
end