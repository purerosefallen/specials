--X－セイバー ガラハド
function c50604950.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c50604950.condtion)
	e1:SetValue(c50604950.atkval)
	e1:SetTarget(c50604950.atktg)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50604950,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCost(c50604950.cost)
	e2:SetOperation(c50604950.operation)
	c:RegisterEffect(e2)
end
function c50604950.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL
end
function c50604950.atkval(e,c)
	if Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil then return 300
	elseif e:GetHandler()==Duel.GetAttackTarget() then return -500
	else return 0 end
end
function c50604950.atktg(e,c)
	return c==e:GetHandler()
end
function c50604950.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0xd) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0xd)
	Duel.Release(g,REASON_COST)
end
function c50604950.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
