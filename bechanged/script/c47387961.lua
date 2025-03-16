--No.8 纹章王 基因组继承者
--No.8 紋章王ゲノム・ヘリター
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,77571455)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x76),4,2)
	c:EnableReviveLimit()
	--indes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indval)
	c:RegisterEffect(e0)

	--attack up
	-- 效果②-1：战斗交换
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	-- 效果②-2：效果复制
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.copytg)
	e2:SetOperation(s.copyop)
	c:RegisterEffect(e2)
	-- 效果②-3：名称变更
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE) -- 修改事件类型
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.atkcon)
	e3:SetOperation(s.naop)
	c:RegisterEffect(e3)
	-- 效果②-4：效果发动名称变更 (克隆并修改事件类型)
	local e4=e3:Clone()
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(s.chaincon)
	c:RegisterEffect(e4)
end
aux.xyz_number[id]=8
function s.indval(e,c)
	return not c:IsSetCard(0x48)
end
-- 战斗交换目标
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:GetBaseAttack()>0 end
end

-- 战斗交换操作
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(bc:GetBaseAttack())
		c:RegisterEffect(e2)
	end
end
-- 效果复制目标 (修改为不取对象)
function s.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_MZONE,1,nil)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
	end
end
function s.nefilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsAttackPos()
	and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)

end

-- 效果复制操作 (修改为处理时选择)
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc and c:IsRelateToEffect(e) then
		-- 新增无效效果
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_DISABLE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0)
		local e00=Effect.CreateEffect(c)
		e00:SetType(EFFECT_TYPE_SINGLE)
		e00:SetCode(EFFECT_DISABLE_EFFECT)
		e00:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e00)
		c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		Duel.BreakEffect()
		if c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(77571455)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
-- 攻击宣言条件
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and re:GetHandler():IsFaceup()
	and not c:IsCode(77571455)
end

-- 连锁事件条件
function s.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsType(TYPE_MONSTER)
	and re:GetHandler():IsFaceup() and not c:IsCode(77571455)
end
-- 名称变更操作
function s.naop(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if e:GetCode()==EVENT_CHAINING then rc=re:GetHandler() end
	if rc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(77571455)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_CHANGE_CODE)
        e2:SetValue(rc:GetOriginalCodeRule())
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2)
	end
end