--エトワール・サイバー
---@param c Card
function c11460577.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c11460577.condtion)
	e1:SetTarget(c11460577.atktg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
end
function c11460577.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil
end
function c11460577.atktg(e,c)
	return c==e:GetHandler()
end