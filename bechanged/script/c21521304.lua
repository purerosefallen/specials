--No.39 希望皇ビヨンド・ザ・ホープ
function c21521304.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(0,EFFECT_FLAG2_WICKED)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(function (e,tp,eg,ep,ev,re,r,rp) local ph=Duel.GetCurrentPhase()
	return ph>PHASE_MAIN1 and ph<PHASE_MAIN2 end)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21521304,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c21521304.spcost)
	e2:SetTarget(c21521304.sptg)
	e2:SetOperation(c21521304.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(c21521304.tglimit)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c21521304.regcon)
	e1:SetOperation(c21521304.regop)
	c:RegisterEffect(e1)
end
aux.xyz_number[21521304]=39
function c21521304.regcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return re and re:GetHandler():IsCode(45950291) and g:IsExists(Card.IsCode,1,nil,84013237)
end
function c21521304.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c21521304.efilter)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function c21521304.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c21521304.tglimit(e,c)
	return c and not c:IsSetCard(0x48)
end
function c21521304.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c21521304.rmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAbleToRemove()
end
function c21521304.spfilter(c,e,tp)
	return c:IsSetCard(0x107f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21521304.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c21521304.rmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c21521304.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c21521304.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c21521304.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,1250)
end
function c21521304.spop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local tc1=g1:GetFirst()
	if not tc1:IsRelateToEffect(e) or Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)==0 then return end
	local tc2=g2:GetFirst()
	if not tc2:IsRelateToEffect(e) or Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	Duel.BreakEffect()
	Duel.Recover(tp,1250,REASON_EFFECT)
end
