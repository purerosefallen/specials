--キング・スカーレット
---@param c Card
function c60433216.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60433216.target)
	e1:SetOperation(c60433216.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c60433216.condition)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c60433216.operation)
	c:RegisterEffect(e2)
end
function c60433216.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60433216,0,TYPES_NORMAL_TRAP_MONSTER+TYPE_TUNER,0,0,1,RACE_FIEND,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60433216.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,60433216,0,TYPES_NORMAL_TRAP_MONSTER+TYPE_TUNER,0,0,1,RACE_FIEND,ATTRIBUTE_FIRE) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TUNER+TYPE_TRAP)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c60433216.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1045) or aux.IsCodeListed(c,70902743)) and c:IsType(TYPE_MONSTER)
end
function c60433216.condition(e)
	return Duel.IsExistingMatchingCard(c60433216.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c60433216.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
