--暗黒ヴェロキ
---@param c Card
function c52319752.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c52319752.condtion)
	e1:SetTarget(c52319752.atktg)
	e1:SetValue(c52319752.val)
	c:RegisterEffect(e1)
end
function c52319752.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL
end
function c52319752.val(e,c)
	if Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil then return 400
	elseif e:GetHandler()==Duel.GetAttackTarget() then return -400
	else return 0 end
end
function c52319752.atktg(e,c)
	return c==e:GetHandler()
end