--邪恶★双子轻松通关
local s,id,o=GetID()
function c34365442.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34365442,1))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,34365442)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c34365442.cost1)
	e1:SetTarget(c34365442.target1)
	e1:SetOperation(c34365442.activate1)
	c:RegisterEffect(e1)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34365442,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,34365442)
	e3:SetCondition(c34365442.condition2)
	e3:SetCost(c34365442.cost2)
	e3:SetTarget(c34365442.target2)
	e3:SetOperation(c34365442.activate2)
	c:RegisterEffect(e3)
    --attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(34365442,3))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,34365442)
	e4:SetCondition(s.scondition)
	e4:SetCost(s.scost)
	e4:SetTarget(s.target)
	e4:SetOperation(s.activate2)
	c:RegisterEffect(e4)
	--act in set turn
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,4))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetValue(id)
	e5:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCondition(s.condition)
	e5:SetCost(s.cost)
	c:RegisterEffect(e5)
end
function s.cfilter(c)
	return c:IsSetCard(0x152,0x153)  and c:IsAbleToGraveAsCost()
end
function s.condition(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c34365442.tgfilter1(c)
	return c:IsSetCard(0x152,0x153)	and c:IsFaceup()
end
function c34365442.cfilter1(c,tp)
	return c:IsSetCard(0x152,0x153) and c:GetBaseAttack()>0
		and (c:IsControler(tp) or c:IsFaceup()) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsExistingTarget(c34365442.tgfilter1,tp,LOCATION_MZONE,0,1,c)
end
function c34365442.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c34365442.cfilter1,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c34365442.cfilter1,1,1,nil,tp)
	if #sg>0 then
	e:SetLabel(sg:GetFirst():GetBaseAttack())
	Duel.Release(sg,REASON_COST)
	end
end
function c34365442.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c34365442.tgfilter1(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c34365442.tgfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c34365442.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c34365442.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function c34365442.cfilter2(c,tp)
	return c:IsSetCard(0x152,0x153)
		and (c:IsControler(tp) or c:IsFaceup()) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c34365442.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c34365442.cfilter2,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c34365442.cfilter2,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c34365442.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c34365442.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
--attack
function s.scondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and Duel.GetTurnPlayer()==tp
end
function s.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c34365442.cfilter2,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c34365442.cfilter2,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.filte(c)
    return c:IsSetCard(0x2151) and c:IsLink(2) and c:IsAttackable()
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
    e1:SetTarget(s.filter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
