--アルカナフォースⅩⅧ－THE MOON
function c97452817.initial_effect(c)
	--coin
	aux.EnableArcanaCoin(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS)
	--coin effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97452817,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c97452817.spcon)
	e1:SetTarget(c97452817.sptg)
	e1:SetOperation(c97452817.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97452817,2))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c97452817.ctcon)
	e2:SetTarget(c97452817.cttg)
	e2:SetOperation(c97452817.ctop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,97452817)
	e3:SetCondition(c97452817.spcon2)
	e3:SetTarget(c97452817.sptg2)
	e3:SetOperation(c97452817.spop2)
	c:RegisterEffect(e3)
end
function c97452817.cfilter(c)
	return c:IsFaceup() and c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_COIN))
end
function c97452817.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c97452817.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c97452817.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c97452817.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(97452817,3)},{b2,aux.Stringid(97452817,4)})
		if op==1 then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		elseif op==2 then
			Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
function c97452817.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(FLAG_ID_ARCANA_COIN)==1
end
function c97452817.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,97452818,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c97452817.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,97452818,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,97452818)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetMZoneCount(tp)>0
		and Duel.SelectYesNo(tp,aux.Stringid(97452817,5)) then
		local token2=Duel.CreateToken(tp,97452818)
		Duel.SpecialSummon(token2,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c97452817.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and e:GetHandler():GetFlagEffectLabel(FLAG_ID_ARCANA_COIN)==0
end
function c97452817.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c97452817.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) then
		Duel.GetControl(tc,1-tp)
	end
end
