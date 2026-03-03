--深渊之相剑龙
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--spsummon itself
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetLabelObject(e11)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id+2)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	--手坑效果
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_HAND)
	e11:SetCountLimit(1,id)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCondition(s.jxcon1)
	e11:SetTarget(s.jxtg)
	e11:SetOperation(s.xjop)
	c:RegisterEffect(e11)
	local e21=e11:Clone()
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e21:SetCondition(s.jxcon2)
	c:RegisterEffect(e21)
end
function s.splimit(e,se,sp,st)
	return se:IsActiveType(TYPE_MONSTER) and se:GetHandler():IsRace(RACE_WYRM)
end
function s.egfilter(c,se)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT)
		and (not c:IsPreviousLocation(LOCATION_ONFIELD) or (c:GetPreviousTypeOnField()&TYPE_MONSTER>0 and not c:IsPreviousLocation(LOCATION_SZONE)))
		and (se==nil or c:GetReasonEffect()~=se)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(s.egfilter,1,nil,se)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		c:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
end
function s.fselect(g)
	return g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=1 and g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
end
function s.rmfilter(c,e)
	if not c:IsCanBeEffectTarget(e) or not c:IsAbleToRemove() then return false end
	return c:IsLocation(LOCATION_FZONE+LOCATION_MZONE) or c:IsType(TYPE_MONSTER)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_FZONE,LOCATION_FZONE+LOCATION_MZONE+LOCATION_GRAVE,nil,e)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,s.fselect,false,1,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function s.level(c)
	return c:IsLevelAbove(8) end
function s.jxcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.level,tp,0,LOCATION_MZONE,1,nil)
end
function s.jxcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.level,tp,0,LOCATION_MZONE,1,nil)
end
function s.jxfilter(c)
	return (c:IsLevel(8) or c:IsLevel(4)) and c:IsAbleToRemove() and not c:IsCode(id)
end
function s.jxtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.jxfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(s.jxfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.jxfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.jxop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsAttribute(ATTRIBUTE_WATER)
	then
	Duel.BreakEffect()
	Duel.Damage(1-tp,1200,REASON_EFFECT)
end
end
