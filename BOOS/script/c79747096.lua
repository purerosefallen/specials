--CNo.1 ゲート・オブ・カオス・ヌメロン－シニューニャ
function c79747096.initial_effect(c)
	aux.AddCodeList(c,15232745,41418852)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,4,c79747096.ovfilter,aux.Stringid(79747096,0))
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79747096,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79747096.rmcon)
	e1:SetTarget(c79747096.rmtg)
	e1:SetOperation(c79747096.rmop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c79747096.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c79747096.indes)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79747096,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1)
	e4:SetCondition(c79747096.spcon)
	e4:SetTarget(c79747096.sptg)
	e4:SetOperation(c79747096.spop)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
end
aux.xyz_number[79747096]=1
function c79747096.ovfilter(c)
	return c:IsFaceup() and c:IsCode(15232745)
end
function c79747096.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79747096.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local mg=Duel.GetOverlayGroup(tp,1,1)
	local g=g+mg
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c79747096.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local mg=Duel.GetOverlayGroup(tp,1,1)
	local g=g+mg
	if g:GetCount()>0 then
		local rt=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if rt>3 then
			Duel.RegisterFlagEffect(tp,79747096,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
			Duel.RegisterFlagEffect(1-tp,79747096,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
		end
	end
end
function c79747096.indes(e,c)
	return not c:IsSetCard(0x48)
end
function c79747096.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(79747096,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
	else
		e:SetLabel(0)
		c:RegisterFlagEffect(79747096,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
	end
end
function c79747096.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetFlagEffect(79747096)>0
		and e:GetLabelObject():GetLabel()~=Duel.GetTurnCount()
end
function c79747096.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c79747096.damfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetAttack()>0
end
function c79747096.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsEnvironment(41418852,tp,LOCATION_FZONE)
		and Duel.IsExistingMatchingCard(c79747096.damfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c79747096.damfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		local dam=g:GetSum(Card.GetAttack)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
