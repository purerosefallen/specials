--M・HERO 剛火
function c58147549.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)
		return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.MaskChangeLimit(e,se,sp,st)
	end)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c58147549.atkup)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(39015,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c58147549.spcost)
	e3:SetTarget(c58147549.sptg)
	e3:SetOperation(c58147549.spop)
	c:RegisterEffect(e3)
end
function c58147549.atkfilter(c)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER)
end
function c58147549.atkup(e,c)
	return Duel.GetMatchingGroupCount(c58147549.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end
function c58147549.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c58147549.filter(c,e,tp,ec)
	return (c:IsType(TYPE_FUSION) and c:IsLevelAbove(8) 
		and c:CheckFusionMaterial() and c:IsSetCard(0x3008)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		or c:IsSetCard(0xa008) and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_MASK_CHANGE,tp,false,true))
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c58147549.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(c58147549.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c58147549.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c58147549.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsSetCard(0x3008) then
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	else
		Duel.SpecialSummon(tc,SUMMON_VALUE_MASK_CHANGE,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end