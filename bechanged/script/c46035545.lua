--DD 魔导贤者 尼古拉
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.pentg)
	e2:SetOperation(s.penop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
--o
function s.penfilter(c,e,tp)
	return c:IsSetCard(0xaf) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter(c)
    return c:IsDiscardable(REASON_EFFECT) and c:IsSetCard(0x10af) and c:IsType(TYPE_MONSTER)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_PZONE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,tp,LOCATION_PZONE)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.penfilter,tp,LOCATION_PZONE,0,c,e,tp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 and #g>0 then
		local tc=g:GetFirst()
        if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
            local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
            if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
                local cg=sg:Select(tp,1,1,nil)
                Duel.SendtoGrave(cg,REASON_DISCARD+REASON_EFFECT)
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_FIELD)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetTargetRange(LOCATION_MZONE,0)
                e1:SetTarget(s.atkfilter)
                e1:SetValue(2000)
                e1:SetReset(RESET_PHASE+PHASE_END)
                Duel.RegisterEffect(e1,tp)
                local e3=e1:Clone()
                e3:SetCode(EFFECT_UPDATE_DEFENSE)
                Duel.RegisterEffect(e3,tp)
            end
        end
        
	end
end
function s.atkfilter(e,c)
    return c:IsSetCard(0xaf) and c:IsLevelBelow(6) and c:IsFaceup()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_PZONE)
end
function s.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10af) and c:IsAbleToHand()
end
function s.pfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_MZONE,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.limit(c)
    return c:IsFaceup() and c:IsSetCard(0xae)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_HAND) then
		local ct=0
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
		if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_EXTRA,0,1,ct,nil)
		local pc=g:GetFirst()
		while pc do
			Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
            if not Duel.IsExistingMatchingCard(s.limit,tp,LOCATION_ONFIELD,0,1,nil) then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_CANNOT_TRIGGER)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                pc:RegisterEffect(e1,true)
            end
			pc=g:GetNext()
		end
	end
end
