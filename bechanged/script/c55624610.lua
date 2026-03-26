--スクラップ・ハンター
function c55624610.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55624610,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c55624610.destg)
	e1:SetOperation(c55624610.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55624610,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c55624610.descon2)
	e2:SetTarget(c55624610.destg2)
	e2:SetOperation(c55624610.desop2)
	c:RegisterEffect(e2)
end
function c55624610.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x24)
end
function c55624610.sfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
end
function c55624610.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c55624610.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c55624610.desfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c55624610.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c55624610.desfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c55624610.spfilter(c,e,tp)
	return c:IsSetCard(0x24) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55624610.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local res=tc:IsSetCard(0x24)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c55624610.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local dg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c55624610.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
			if dg:GetCount()>0 and res and Duel.SelectYesNo(tp,aux.Stringid(55624610,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=dg:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c55624610.descon2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d==e:GetHandler() then d=Duel.GetAttacker() end
	e:SetLabelObject(d)
	return d~=nil
end
function c55624610.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local d=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c55624610.desop2(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabelObject()
	local dam=d:GetBaseAttack()
	if d:IsRelateToBattle() and Duel.Destroy(d,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end