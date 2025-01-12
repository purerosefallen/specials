--ガジェット・トレーラー
---@param c Card
function c28002611.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28002611,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c28002611.tg)
	e1:SetOperation(c28002611.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86938484,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c28002611.sptg2)
	e2:SetOperation(c28002611.spop2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(284224,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c28002611.descon)
	e3:SetTarget(c28002611.destg)
	e3:SetOperation(c28002611.desop)
	c:RegisterEffect(e3)
end
function c28002611.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c28002611.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28002611.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c28002611.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28002611.filter,tp,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(g:GetCount()*800)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c28002611.cfilter(c,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsRace(RACE_MACHINE) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0
end
function c28002611.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c28002611.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28002611.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c28002611.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	local c=e:GetHandler()
	local tc=tg:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28002611.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and re:GetHandler():IsLocation(LOCATION_MZONE) and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsCanChangePosition()
		and re:GetHandler():IsSetCard(0x26)
end
function c28002611.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(aux.AND(Card.IsFaceupEx,Card.IsSetCard),tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,0x51)
	if chk==0 then return e:GetHandler():GetFlagEffect(28002611)<ct end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
	e:GetHandler():RegisterFlagEffect(28002611,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
end
function c28002611.desop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.ChangePosition(re:GetHandler(),POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end