--光天之摩诃毗卢
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,79791878)
	--spsum
	local ee=Effect.CreateEffect(c)
	ee:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	ee:SetType(EFFECT_TYPE_IGNITION)
	ee:SetRange(LOCATION_HAND)
	ee:SetCountLimit(1,id)
	ee:SetCondition(s.spcon1)
	ee:SetTarget(s.sptg1)
	ee:SetOperation(s.spop1)
	c:RegisterEffect(ee)
	--atk boost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(1)
	e1:SetCondition(s.eqcon)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetLabel(2)
	e2:SetCondition(s.eqcon)
	e2:SetValue(s.actlimit)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(3)
	e3:SetCondition(s.eqcon)
	e3:SetCost(s.negcost)
	e3:SetTarget(s.negtg)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
	--actlimit2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(0,1)
	e4:SetLabel(4)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.eqcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--double damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetLabel(5)
	e5:SetCondition(s.eqcon)
	e5:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e5)

end
function s.cfilter1(c)
	return c:IsCode(79791878) and c:IsFaceup() and c:IsAbleToGrave()
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.chkfilter(c)
	return aux.IsCodeListed(c,79791878) and (c:IsFaceup()or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_MONSTER)
end
function s.eqfilter(c,ec,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g<=0 then return end
	if 	Duel.SendtoGrave(g,REASON_EFFECT)and c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local numg=Duel.GetMatchingGroup(s.chkfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
			if numg==nil then return end
			local max=#numg+1
			local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
			if ft<=0 or c:IsFacedown() or not c:IsLocation(LOCATION_MZONE) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,math.min(ft,max),nil,c,tp)
			if not sg then return end
			local tc=sg:GetFirst()
			while tc do
				Duel.Equip(tp,tc,c,true,true)
				tc=sg:GetNext()
			end
			Duel.EquipComplete()
		
		end
	end
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lab=e:GetLabel()
	if c:GetEquipCount()<lab then return false end
	if (lab==2 or lab==4) then
		return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
	elseif lab==3 then
		if rp==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			return false
		end
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		return g and g:IsContains(c) and Duel.IsChainDisablable(ev)
	else
		return true
	end
end
function s.atkval(e,c)
	return c:GetEquipCount()*1000
end
function s.actlimit(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function s.negfilter(c)
	return (c:IsFaceup() or c:GetEquipTarget()) and c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.negfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.negfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
