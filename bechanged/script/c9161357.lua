--No.6 先史遗产 大西洲巨人
function c9161357.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9161357,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c9161357.eqcon)
	e1:SetTarget(c9161357.eqtg)
	e1:SetOperation(c9161357.eqop)
	c:RegisterEffect(e1)
	--lp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9161357,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c9161357.lpcost)
	e2:SetOperation(c9161357.lpop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9161357,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9161357)
	e3:SetCondition(c9161357.eqcon2)
	e3:SetTarget(c9161357.eqtg2)
	e3:SetOperation(c9161357.eqop2)
	c:RegisterEffect(e3)
end
aux.xyz_number[9161357]=6

--eq1
function c9161357.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9161357.filter(c)
	return c:IsSetCard(0x48) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9161357.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9161357.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9161357.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c9161357.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c9161357.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9161357.eqlimit1)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(9161357,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c9161357.eqlimit1(e,c)
	return e:GetOwner()==c
end

--lp
function c9161357.lpfilter(c,tp)
	return c:GetFlagEffect(9161357)~=0 and c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and c:IsAbleToGraveAsCost()
end
function c9161357.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local eqg=c:GetEquipGroup()
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 and eqg:IsExists(c9161357.lpfilter,1,nil,tp)
		and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,9161358,0,0,0)
	local ec=eqg:FilterSelect(tp,c9161357.lpfilter,1,1,nil,tp)
	Duel.SendtoGrave(ec,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9161357.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
end

--eqquick
function c9161357.eqcon2(e,c)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,9161358)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c9161357.eqfilter2(c,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c9161357.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9161357.eqfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c9161357.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c9161357.eqfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9161357.eqlimit)
		tc:RegisterEffect(e1)
		Duel.RegisterFlagEffect(tp,9161357,RESET_EVENT+RESETS_STANDARD,0,1)
		Duel.BreakEffect()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		c:RegisterEffect(e3)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e5)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9161357,3))
		tc:RegisterFlagEffect(9161357,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c9161357.eqlimit(e,c)
	return c==e:GetLabelObject()
end
