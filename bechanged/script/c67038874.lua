--スクラップ・マインドリーダー
function c67038874.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67038874,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,67038874)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c67038874.condition)
	e1:SetTarget(c67038874.target)
	e1:SetOperation(c67038874.operation)
	c:RegisterEffect(e1)
	--hand synchro
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,67038875)
	e2:SetValue(c67038874.matval)
	c:RegisterEffect(e2)
end
function c67038874.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c67038874.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x24) and not c:IsCode(67038874)
end
function c67038874.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c67038874.filter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c67038874.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67038874.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c67038874.matval(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x24)
end