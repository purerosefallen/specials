--ダーク・スプロケッター
function c61632317.initial_effect(c)
	--hand synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(c61632317.matval)
	c:RegisterEffect(e1)
	--register HOpT
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_PRE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetLabelObject(e1)
	e0:SetCondition(c61632317.hsyncon)
	e0:SetOperation(c61632317.hsynreg)
	c:RegisterEffect(e0)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(61632317,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c61632317.descon)
	e2:SetTarget(c61632317.destg)
	e2:SetOperation(c61632317.desop)
	c:RegisterEffect(e2)
end
function c61632317.matval(e,c)
	return c:IsType(TYPE_SYNCHRO)
end
function c61632317.hsyncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c61632317.matval(nil,c:GetReasonCard()) and c:IsPreviousLocation(LOCATION_HAND)
end
function c61632317.hsynreg(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():UseCountLimit(tp)
end
function c61632317.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
		and e:GetHandler():GetReasonCard():IsAttribute(ATTRIBUTE_DARK)
end
function c61632317.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c61632317.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c61632317.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c61632317.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c61632317.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c61632317.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
