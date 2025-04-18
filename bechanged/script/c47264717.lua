--シューティング・スター
function c47264717.initial_effect(c)
	aux.AddCodeList(c,44508094,58120309)
	aux.AddMaterialCodeList(c,44508094,58120309)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c47264717.target)
	e1:SetOperation(c47264717.activate)
	c:RegisterEffect(e1)
	--Act in Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47264717,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCountLimit(1,47264717)
	e2:SetCondition(c47264717.handcon)
	c:RegisterEffect(e2)
end
function c47264717.cfilter(c)
	return c:IsSetCard(0xa3) and c:IsFaceup()
end
function c47264717.cfilter2(c)
	return (c:IsCode(44508094) or (aux.IsCodeListed(c,44508094) and c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_MZONE)))
		and c:IsFaceup()
end
function c47264717.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local ct=Duel.GetMatchingGroupCount(c47264717.cfilter2,tp,LOCATION_ONFIELD,0,nil)
	e:SetLabel(ct)
end
function c47264717.stfilter(c)
	return c:IsCode(58120309) and c:IsSSetable()
end
function c47264717.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c47264717.stfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if e:GetLabel()>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(47264717,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sc=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sc)
		end
	end
end
function c47264717.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0 or Duel.IsExistingMatchingCard(c47264717.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end