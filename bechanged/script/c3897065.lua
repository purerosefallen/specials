--超级交通机人-隐形合体
function c3897065.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode4(c,61538782,98049038,71218746,984114,true,true)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e1:SetTarget(c3897065.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--indes2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetCondition(c3897065.atcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(3897065,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c3897065.condition)
	e5:SetTarget(c3897065.target)
	e5:SetOperation(c3897065.operation)
	c:RegisterEffect(e5)
	end

------indes
function c3897065.indtg(e,c)
	return e:GetHandler():GetEquipGroup():IsContains(c)
end

------atkall
function c3897065.atcon(e)
	return e:GetHandler():GetEquipCount()>0
end


------
function c3897065.cfilter(c,tp)
	return c:IsFaceup() and c:GetSequence()>4 and c:GetControler()~=tp
end
function c3897065.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3897065.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler()) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c3897065.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c3897065.cfilter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c3897065.filter(c,e,tp)
	return c:IsFaceup() and c:GetSequence()>4 and c:IsRelateToEffect(e) and c:IsControler(1-tp)
end
function c3897065.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	local g=eg:Filter(c3897065.filter,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

