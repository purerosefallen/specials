--CNo.39 希望皇ホープレイV
function c66970002.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c66970002.ovfilter)
	c:EnableReviveLimit()
	--xyz no pohuai
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(c66970002.tglimit)
	c:RegisterEffect(e0)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66970002,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c66970002.tdcon)
	e1:SetTarget(c66970002.tdtg)
	e1:SetOperation(c66970002.tdop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetDescription(aux.Stringid(66970002,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c66970002.descost)
	e2:SetTarget(c66970002.destg)
	e2:SetOperation(c66970002.desop)
	e2:SetCondition(c66970002.rmcon)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e2)
end
aux.xyz_number[66970002]=39
--up on r4
function c66970002.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f) and c:IsType(TYPE_XYZ) and c:IsRank(4)
end
--no pohuai
function c66970002.tglimit(e,c)
	return c and not c:IsSetCard(0x48)
end
--my turn
function c66970002.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c66970002.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c66970002.tdfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c66970002.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c66970002.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66970002.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c66970002.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
end
function c66970002.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
function c66970002.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c66970002.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetAttack())
end
function c66970002.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		local atk=tc:GetAttack()
		if atk<0 or tc:IsFacedown() then atk=0 end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
