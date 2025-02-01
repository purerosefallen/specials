--レッドアイズ・トランスマイグレーション
---@param c Card
function c45410988.initial_effect(c)
	aux.AddCodeList(c,19025379)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45410988,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c45410988.target)
	e1:SetOperation(c45410988.activate)
	c:RegisterEffect(e1)
	--ritual summon
	local e2=aux.AddRitualProcGreater(c,c45410988.filter,nil,c45410988.mfilter,nil,true)
	e2:SetDescription(aux.Stringid(45410988,1))
	c:RegisterEffect(e2)
end
function c45410988.spfilter(c,e,tp)
	return not c:IsCode(19025379) and c:IsLevelAbove(7) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or
	c:IsCode(19025379) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c45410988.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c45410988.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c45410988.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c45410988.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsCode(19025379) and tc:IsType(TYPE_RITUAL) then
			tc:SetMaterial(nil)
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c45410988.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsRace(RACE_DRAGON)
end
function c45410988.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3b)
end
