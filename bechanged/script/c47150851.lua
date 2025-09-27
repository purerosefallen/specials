--ガーディアン・グラール
function c47150851.initial_effect(c)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(c47150851.etarget)
	e3:SetValue(c47150851.efilter)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c47150851.spcon)
	c:RegisterEffect(e4)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,47150851)
	e5:SetTarget(c47150851.eqtg)
	e5:SetOperation(c47150851.eqop)
	c:RegisterEffect(e5)
end
function c47150851.etarget(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c)
end
function c47150851.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c47150851.filter(c,ec)
	return c:IsCode(32022366) and c:CheckEquipTarget(ec)
end
function c47150851.spfilter(c,e,tp)
	return c:IsSetCard(0x52) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47150851.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c47150851.filter,tp,0x11,0,1,nil,e:GetHandler())
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47150851.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
end
function c47150851.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c47150851.filter,tp,0x11,0,1,nil,c)
		and c:IsFaceup() and c:IsRelateToEffect(e)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47150851.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(47150851,0)},{b2,aux.Stringid(47150851,1)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47150851.filter),tp,0x11,0,1,1,nil,c)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),c)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c47150851.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c47150851.cfilter(c)
	return c:IsFaceup() and c:IsCode(32022366)
end
function c47150851.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==1
		or Duel.IsExistingMatchingCard(c47150851.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil))
end
