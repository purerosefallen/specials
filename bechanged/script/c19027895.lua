--サラマングレイト・リヴァイブ
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--act in set turn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19027895,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.stgt)
	e2:SetOperation(s.sop)
	c:RegisterEffect(e2)
	--ATK Gain
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(aux.dscon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
function s.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.sfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.stgt(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	e:SetLabel(0)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.sfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.sfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.sfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.sop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.atkfilter1(c,e,tp)
	return c:IsSetCard(0x119) and c:IsFaceup() and c:GetBaseAttack()>0
		and Duel.IsExistingTarget(s.atkfilter2,tp,LOCATION_GRAVE,0,1,c,c:GetCode())
end
function s.atkfilter2(c,code)
	return c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsCode(code) and c:IsAbleToDeck()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,s.atkfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,s.atkfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),g1:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sc=g:GetFirst()
	if sc==tc then sc=g:GetNext() end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) and sc:IsRelateToEffect(e) and aux.NecroValleyFilter()(sc) and Duel.SendtoDeck(sc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local atk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(sc:GetCode())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
