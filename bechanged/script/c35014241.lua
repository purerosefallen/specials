--リミットオーバー・ドライブ
function c35014241.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35014241,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c35014241.cost)
	e1:SetTarget(c35014241.target)
	e1:SetOperation(c35014241.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35014241,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c35014241.target2)
	e2:SetOperation(c35014241.activate2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35014241,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c35014241.target3)
	e3:SetOperation(c35014241.activate3)
	c:RegisterEffect(e3)
end
function c35014241.cfilter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER) and c:IsAbleToExtraAsCost()
		and Duel.IsExistingMatchingCard(c35014241.cfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp,c)
end
function c35014241.cfilter2(c,e,tp,tc)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and not c:IsType(TYPE_TUNER) and c:IsAbleToExtraAsCost()
		and Duel.IsExistingMatchingCard(c35014241.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel()+tc:GetLevel(),Group.FromCards(c,tc))
end
function c35014241.spfilter(c,e,tp,lv,mg)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c35014241.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(c35014241.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c35014241.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c35014241.cfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp,g1:GetFirst())
	e:SetLabel(g1:GetFirst():GetLevel()+g2:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,SEQ_DECKTOP,REASON_COST)
end
function c35014241.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c35014241.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c35014241.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c35014241.spfilter(c,e,tp)
	return (c:IsSetCard(0xc2) or (c:IsLevel(7,8) and c:IsRace(RACE_DRAGON)))
		and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c35014241.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35014241.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c35014241.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c35014241.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c35014241.splimit)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end
function c35014241.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c35014241.spfilter3(c,code,lv,e,tp,mc)
	return c:IsLevel(lv) and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,true)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c35014241.filter3(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(c35014241.spfilter3,tp,LOCATION_EXTRA,0,1,nil,c:GetCode(),c:GetOriginalLevel(),e,tp,c)
end
function c35014241.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c35014241.filter3(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c35014241.filter3,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c35014241.filter3,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c35014241.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local code=tc:GetCode()
	local lv=tc:GetOriginalLevel()
	if Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c35014241.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,code,lv,e,tp,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end