--月の女戦士
---@param c Card
function c64751286.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c64751286.condtion)
	e1:SetValue(1000)
	e1:SetTarget(c64751286.atktg)
	c:RegisterEffect(e1)
end
function c64751286.condtion(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local bc=c:GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsAttribute(ATTRIBUTE_LIGHT)
end
function c64751286.atktg(e,c)
	return c==e:GetHandler()
end