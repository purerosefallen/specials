--超级量子合神-炎磁巨阵
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act in set turn
	local ee=Effect.CreateEffect(c)
	ee:SetDescription(aux.Stringid(id,1))
	ee:SetType(EFFECT_TYPE_SINGLE)
	ee:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	ee:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	ee:SetCondition(s.actcon)
	ee:SetCost(s.cost)
	c:RegisterEffect(ee)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(s.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.mttg)
	e3:SetOperation(s.mtop)
	c:RegisterEffect(e3)
	--play fieldspell
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.aftg)
	e4:SetOperation(s.afop)
	c:RegisterEffect(e4)

end
function s.cofilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xdc)
	and c:GetOverlayGroup() and c:GetOverlayGroup():GetCount()>0
	and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function s.actcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if not Duel.IsExistingMatchingCard(s.cofilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then return false	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	return Duel.IsExistingMatchingCard(s.cofilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cofilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local cg=Duel.SelectMatchingCard(tp,s.cofilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local cc=cg:GetFirst()
	cc:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.tglimit(e,c)
	return c:IsSetCard(0xdc)
end
function s.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xdc)
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,c)
end
function s.filter2(c,e)
	return c:IsType(TYPE_MONSTER) and (c:IsFaceup()or not c:IsLocation(LOCATION_ONFIELD)) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,tc,e)
	if g:GetCount()>0 then
		local og=g:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,g)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function s.affilter(c,tp)
	return c:IsCode(47819246) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.aftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.affilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
end
function s.afop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.affilter),tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc then
		local field=tc:IsType(TYPE_FIELD)
		if field then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local ttc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
			if  tc:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
			if ttc:IsFaceup() then
				Duel.Equip(tp,tc,ttc)
				--Equip limit
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(s.eqlimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			else
				tc:CancelToGrave(false)
			end
		end
		if field then
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function s.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==c
		or c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0xdc) and c:IsType(TYPE_XYZ)
end
