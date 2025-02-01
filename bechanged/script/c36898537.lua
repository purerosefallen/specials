--メタファイズ・ホルス・ドラゴン
---@param c Card
function c36898537.initial_effect(c)
	aux.AddCodeList(c,16528181)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36898537,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c36898537.spcon)
	e1:SetTarget(c36898537.sptg)
	e1:SetOperation(c36898537.spop)
	c:RegisterEffect(e1)
	--mat check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c36898537.valcheck)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(36898537,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c36898537.immcon)
	e3:SetOperation(c36898537.immop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(36898537,1))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(c36898537.negcon)
	e4:SetTarget(c36898537.negtg)
	e4:SetOperation(c36898537.negop)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(36898537,2))
	e5:SetCategory(CATEGORY_CONTROL)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c36898537.ctcon)
	e5:SetTarget(c36898537.cttg)
	e5:SetOperation(c36898537.ctop)
	e5:SetLabelObject(e2)
	c:RegisterEffect(e5)
	--to grave and set
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c36898537.tgcon)
	e6:SetTarget(c36898537.tgtg)
	e6:SetOperation(c36898537.tgop)
	e6:SetLabelObject(e1)
	c:RegisterEffect(e6)
end
function c36898537.spfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(6) and c:IsAbleToGraveAsCost()
end
function c36898537.fselect(g,tp,sc)
	if Duel.GetLocationCountFromEx(tp,tp,g,sc)<=0 then return false end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	return tc1:IsLevel(tc2:GetLevel())
end
function c36898537.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c36898537.spfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c36898537.fselect,2,2,tp,c)
end
function c36898537.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c36898537.spfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c36898537.fselect,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c36898537.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local a=0
	if g:IsExists(Card.IsLevelAbove,1,nil,8) then
		a=1
	end
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
	e:SetLabel(a)
end
function c36898537.valcheck(e,c)
	local g=c:GetMaterial()
	local tpe=0
	local tc=g:GetFirst()
	while tc do
		if not tc:IsSynchroType(TYPE_TUNER) then
			tpe=bit.bor(tpe,tc:GetSynchroType())
		end
		tc=g:GetNext()
	end
	e:SetLabel(tpe)
end
function c36898537.immcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
		and bit.band(e:GetLabelObject():GetLabel(),TYPE_NORMAL)~=0
end
function c36898537.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c36898537.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c36898537.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c36898537.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
		and bit.band(e:GetLabelObject():GetLabel(),TYPE_EFFECT)~=0
end
function c36898537.negfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_NORMAL)
end
function c36898537.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c36898537.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c36898537.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c36898537.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c36898537.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c36898537.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
		and bit.band(e:GetLabelObject():GetLabel(),TYPE_PENDULUM)~=0
end
function c36898537.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c36898537.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToChangeControler,1-tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.GetControl(tc,tp)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
function c36898537.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end
function c36898537.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x19d) and c:IsAbleToGrave()
end
function c36898537.setfilter(c,tp)
	return c:IsCode(16528181) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c36898537.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36898537.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c36898537.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c36898537.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c36898537.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c36898537.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
	end
end
