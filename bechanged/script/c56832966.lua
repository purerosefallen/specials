--SNo.39 希望皇ホープ・ザ・ライトニング
function c56832966.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),5,3,c56832966.ovfilter,aux.Stringid(56832966,0))
	c:EnableReviveLimit()
	--xyz no pohuai
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(c56832966.indval)
	c:RegisterEffect(e0)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c56832966.actcon)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(56832966,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c56832966.atkcon)
	e3:SetCost(c56832966.atkcost)
	e3:SetOperation(c56832966.atkop)
	c:RegisterEffect(e3)
end
aux.xyz_number[56832966]=39
function c56832966.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f) and c:IsType(TYPE_XYZ) and c:IsRank(4)
end
--no pohuai
function c56832966.indval(e,c)
	return not c:IsSetCard(0x48)
end
function c56832966.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c56832966.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c56832966.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(56832966)==0 end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(56832966,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c56832966.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(5000)
		c:RegisterEffect(e1)
	end
end
