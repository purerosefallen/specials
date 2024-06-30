--記憶破壊者
function c48700891.initial_effect(c)
  --damage
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(48700891,0))
  e1:SetCategory(CATEGORY_DAMAGE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_BATTLE_DAMAGE)
  e1:SetCondition(c48700891.condition)
  e1:SetTarget(c48700891.target)
  e1:SetOperation(c48700891.operation)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c48700891.actcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(56832966,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c48700891.atkcon)
	e3:SetCost(c48700891.atkcost)
	e3:SetOperation(c48700891.atkop)
	c:RegisterEffect(e3)
end
function c48700891.condition(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp -- and Duel.GetAttackTarget()==nil
end
function c48700891.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(ct*300)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function c48700891.operation(e,tp,eg,ep,ev,re,r,rp)
  local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  Duel.Damage(p,ct*300,REASON_EFFECT)
end
function c48700891.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c48700891.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local bc=e:GetHandler():GetBattleTarget()
	return bc~=nil and bc:GetSummonLocation()==LOCATION_EXTRA
end
function c48700891.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(48700891)==0 end
	c:RegisterFlagEffect(48700891,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c48700891.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
  local bc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and bc and bc:IsRelateToBattle() then
    local atk = bc:GetAttack()
    if atk <= 0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end
