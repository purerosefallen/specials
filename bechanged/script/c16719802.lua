--スター・ブライト・ドラゴン
function c16719802.initial_effect(c)
	aux.AddCodeList(c,44508094)
	--hand synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(c16719802.matval)
	c:RegisterEffect(e1)
	--register HOpT
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_PRE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetLabelObject(e1)
	e0:SetCondition(c16719802.hsyncon)
	e0:SetOperation(c16719802.hsynreg)
	c:RegisterEffect(e0)
	--synclv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetValue(c16719802.synclv)
	c:RegisterEffect(e2)
	--lv up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16719802,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c16719802.tg)
	e3:SetOperation(c16719802.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c16719802.matval(e,c)
	return c:IsType(TYPE_SYNCHRO) and (c:IsSetCard(0xa3) or aux.IsCodeListed(c,44508094))
end
function c16719802.hsyncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c16719802.matval(nil,c:GetReasonCard()) and c:IsPreviousLocation(LOCATION_HAND)
end
function c16719802.hsynreg(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():UseCountLimit(tp)
end
function c16719802.synclv(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	return (2<<16)+lv
end
function c16719802.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c16719802.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c16719802.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c16719802.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c16719802.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c16719802.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
