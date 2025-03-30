--北极天熊滑行
function c53865474.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,53865474+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c53865474.target)
	e1:SetOperation(c53865474.activate)
	c:RegisterEffect(e1)
	--nimadezhegeyaowozenmexiea
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(53865474)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,53865474)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(16471775)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(89771220)
	c:RegisterEffect(e4)
end

function c53865474.filter(c,e,tp)
	return c:IsSetCard(0x163) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c53865474.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c53865474.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c53865474.activate(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c53865474.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
			if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_ATTACK)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1,true)
				sc:RegisterFlagEffect(53865474,RESET_EVENT+RESETS_STANDARD,0,1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetCountLimit(1)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetLabelObject(sc)
				e2:SetCondition(c53865474.descon)
				e2:SetOperation(c53865474.desop)
				Duel.RegisterEffect(e2,tp)
		   end
		   if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		   local e3=Effect.CreateEffect(e:GetHandler())
		   e3:SetType(EFFECT_TYPE_FIELD)
		   e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		   e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		   e3:SetTargetRange(1,0)
		   e3:SetTarget(c53865474.splimit)
		   e3:SetReset(RESET_PHASE+PHASE_END)
		   Duel.RegisterEffect(e3,tp)
		   end 
		   Duel.SpecialSummonComplete()
end
function c53865474.descon(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	if sc:GetFlagEffect(53865474)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end

function c53865474.desop(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	Duel.Destroy(sc,REASON_EFFECT)
end
function c53865474.splimit(e,c)
	return c:IsLevel(0)
end
