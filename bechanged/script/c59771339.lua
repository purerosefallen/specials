--ジャンク・バーサーカー
function c59771339.initial_effect(c)
	aux.AddMaterialCodeList(c,63977008)
	--synchro summon
	aux.AddSynchroProcedure(c,c59771339.tfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59771339,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,59771339+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c59771339.spcon)
	e2:SetTarget(c59771339.sptg)
	e2:SetOperation(c59771339.spop)
	c:RegisterEffect(e2)
	--atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(59771339,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c59771339.cost)
	e3:SetTarget(c59771339.target)
	e3:SetOperation(c59771339.operation)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(59771339,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c59771339.descon)
	e4:SetTarget(c59771339.destg)
	e4:SetOperation(c59771339.desop)
	c:RegisterEffect(e4)
	--attack all
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_ALL)
	e5:SetValue(c59771339.atkfilter)
	c:RegisterEffect(e5)
end
c59771339.material_setcode=0x1017
function c59771339.tfilter(c)
	return c:IsCode(63977008) or c:IsHasEffect(20932152)
end
function c59771339.spfilter(c,tp,lv)
	return c:IsFaceupEx() and c:IsControler(tp) and c:IsSetCard(0x66,0x43,0xa3) and c:IsLevel(lv) and c:IsAbleToRemoveAsCost()
end
function c59771339.gcheck(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c59771339.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local lv=c:GetLevel()-3
	if lv<1 then return end
	local g=Duel.GetMatchingGroup(c59771339.spfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,c,tp,lv)
	return g:CheckSubGroup(c59771339.gcheck,1,1,tp,c)
end
function c59771339.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local lv=c:GetLevel()-3
	if lv<1 then return end
	local g=Duel.GetMatchingGroup(c59771339.spfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,c,tp,lv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c59771339.gcheck,true,1,1,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c59771339.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c59771339.cfilter(c)
	return c:IsSetCard(0x43) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c59771339.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59771339.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c59771339.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c59771339.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,20,nil)
end
function c59771339.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local dg=Group.CreateGroup()
	for tc in aux.Next(g) do
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local atk=tc:GetAttack()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-e:GetLabel())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if atk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		end
	end
	Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
end
function c59771339.descon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return e:GetHandler()==Duel.GetAttacker() and d and d:IsDefensePos()
end
function c59771339.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttackTarget(),1,0,0)
end
function c59771339.desop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d:IsRelateToBattle() then
		Duel.Destroy(d,REASON_EFFECT)
	end
end
function c59771339.atkfilter(e,c)
	return c:IsPosition(POS_DEFENSE)
end