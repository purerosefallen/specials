--ヴァイロン・アルファ
---@param c Card
function c56768355.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c56768355.matfilter,nil,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(56768355,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c56768355.eqcon)
	e1:SetTarget(c56768355.eqtg)
	e1:SetOperation(c56768355.eqop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(c56768355.indcon)
	e2:SetValue(c56768355.indval)
	c:RegisterEffect(e2)
end
function c56768355.matfilter(c,syncard)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsTuner(syncard)
end
function c56768355.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c56768355.filter(c,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c56768355.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c56768355.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_GRAVE+LOCATION_DECK)
end
function c56768355.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c56768355.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e:GetHandler()):GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c56768355.indcon(e)
	return e:GetHandler():GetEquipCount()>0
end
function c56768355.indval(e,re)
	if not re then return false end
	local ty=re:GetActiveType()
	return bit.band(ty,TYPE_SPELL+TYPE_TRAP)~=0 and bit.band(ty,TYPE_EQUIP)==0
end
