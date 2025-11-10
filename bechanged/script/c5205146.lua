--无限起动 压路机
function c5205146.initial_effect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5205146,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,5205146)
	e1:SetLabelObject(e0)
	e1:SetCondition(c5205146.spcon)
	e1:SetTarget(c5205146.sptg)
	e1:SetOperation(c5205146.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	--gain effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c5205146.matcheck)
	e3:SetTarget(c5205146.postg)
	e3:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(-1000)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,5205147)
	e5:SetTarget(c5205146.bstg)
	e5:SetOperation(c5205146.bsop)
	c:RegisterEffect(e5)	
end
function c5205146.cfilter(c,se)
	if c:IsLocation(LOCATION_REMOVED)
		and not (c:IsReason(REASON_RELEASE) or c:IsFaceup()) then return false end
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	if c:IsPreviousLocation(LOCATION_MZONE) then
		return c:GetPreviousAttributeOnField()&ATTRIBUTE_EARTH>0 and c:GetPreviousRaceOnField()&RACE_MACHINE>0
	else
		return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE)
	end
end
function c5205146.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(c5205146.cfilter,1,nil,se) and not eg:IsContains(c)
end
function c5205146.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c5205146.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c5205146.matcheck(e)
	return e:GetHandler():GetOriginalRace()==RACE_MACHINE
end
function c5205146.postg(e,c)
	return c:IsFaceup()
end


function c5205146.bfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and(c:IsAbleToHand() or c:IsAbleToExtra()) and not c:IsCode(5205146)
end
function c5205146.bstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and chkc:IsControler(tp) and c5205146.bfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5205146.bfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c5205146.bfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc:IsAbleToExtra() then
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function c5205146.bsop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if tg:GetCount()>0 then
	Duel.SendtoHand(tg,nil,REASON_EFFECT) 
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c5205146.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)	 
end
function c5205146.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_EARTH) or not c:IsRace(RACE_MACHINE)
end

