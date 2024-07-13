--ヌメロン・ネットワーク
function c41418852.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41418852,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(c41418852.cpcost)
	e1:SetTarget(c41418852.cptg)
	e1:SetOperation(c41418852.cpop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41418852,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c41418852.discon)
	e2:SetTarget(c41418852.distg)
	e2:SetOperation(c41418852.disop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(41418852,2))
	e4:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_SPSUMMON)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c41418852.discon2)
	e4:SetTarget(c41418852.distg2)
	e4:SetOperation(c41418852.disop2)
	c:RegisterEffect(e4)
	--remove overlay replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(41418852,3))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c41418852.rcon)
	e4:SetOperation(c41418852.rop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetTargetRange(1,1)
	e6:SetTarget(c41418852.splimit)
	c:RegisterEffect(e6)
end
function c41418852.cpfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsSetCard(0x14a) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function c41418852.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c41418852.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c41418852.cpfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c41418852.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c41418852.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function c41418852.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0x14a)
		and ep==e:GetOwnerPlayer() and re:GetActivateLocation()&LOCATION_MZONE~=0
end
function c41418852.rop(e,tp,eg,ep,ev,re,r,rp)
	return ev
end
function c41418852.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
		and ep==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c41418852.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c41418852.filter(c,tp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local condition=te:GetCondition()
	local target=te:GetTarget()
	return c:GetType(TYPE_SPELL+TYPE_TRAP) and te:GetCode()==EVENT_FREE_CHAIN
		and te:IsActivatable(1-tp)
		and (not condition or condition(te,1-tp,eg,ep,ev,re,r,rp))
		and (not target or target(te,tep,eg,ep,ev,re,r,rp,0))
		and (Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD))
end
function c41418852.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(c41418852.filter,nil,tp)
		if tg:GetCount()>0 then
			local ag=tg:Select(tp,1,1,nil)
			local te,ceg,cep,cev,cre,cr,crp=ag:GetFirst():CheckActivateEffect(false,true,true)
			if ag:GetFirst():IsType(TYPE_FIELD) then
				Duel.ResetFlagEffect(tp,15248873)
				local fc=Duel.GetFieldCard(tp,0,LOCATION_FZONE)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(ag:GetFirst(),tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
				Duel.Hint(HINT_CARD,0,ag:GetFirst():GetCode())
				te:UseCountLimit(1-tp,1,true)
			else
				Duel.ClearTargetCard()
				Duel.MoveToField(ag:GetFirst(),tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
				Duel.Hint(HINT_CARD,0,ag:GetFirst():GetCode())
				local tg=te:GetTarget()
				e:SetProperty(te:GetProperty())
				if not ag:GetFirst():IsType(TYPE_CONTINUOUS) then
					ag:GetFirst():CancelToGrave(false)
				end
				if tg then tg(e,1-tp,ceg,cep,cev,cre,cr,crp,1) end
				local op=te:GetOperation()
				if op then op(e,1-tp,eg,ep,ev,re,r,rp) end
				te:UseCountLimit(1-tp,1,true)
			end
		end
	end
end
function c41418852.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and rp==1-tp
end
function c41418852.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c41418852.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c41418852.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)~=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(c41418852.spfilter,nil,e,tp)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local ag=tg:Select(tp,1,1,nil)
			if ag:GetCount()>0 then
				local tc=ag:GetFirst()
				Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				Duel.SpecialSummonComplete()
			end
		end
	end
end
function c41418852.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end