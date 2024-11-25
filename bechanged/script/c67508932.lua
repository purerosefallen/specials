--時械神祖ヴルガータ
function c67508932.initial_effect(c)
	aux.AddCodeList(c,9409625,36894320,72883039)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c67508932.hspcon)
	e0:SetTarget(c67508932.hsptg)
	e0:SetOperation(c67508932.hspop)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67508932,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(c67508932.rmcond)
	e4:SetTarget(c67508932.rmtg)
	e4:SetOperation(c67508932.rmop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67508932,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c67508932.spcon)
	e5:SetTarget(c67508932.sptg)
	e5:SetOperation(c67508932.spop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c67508932.target)
	e6:SetOperation(c67508932.operation)
	c:RegisterEffect(e6)
end
function c67508932.hspfilter(c,tp,sc)
	return c:IsLevel(10) and c:IsAttack(0) and c:IsRace(RACE_FAIRY)
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c67508932.hspcon(e,c)
	if c==nil then return Duel.GetFlagEffect(tp,67508932)==0 end
	return Duel.CheckReleaseGroupEx(c:GetControler(),c67508932.hspfilter,1,REASON_SPSUMMON,false,nil,c:GetControler(),c)
end
function c67508932.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c67508932.hspfilter,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c67508932.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	c:SetMaterial(Group.FromCards(tc))
	Duel.Release(tc,REASON_SPSUMMON)
	Duel.RegisterFlagEffect(tp,67508932,RESET_PHASE+PHASE_END,0,1)

end
function c67508932.rmcond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.dsercon(e,tp,eg,ep,ev,re,r,rp) and c:IsSummonLocation(LOCATION_EXTRA) and c:GetBattledGroupCount()>0
end
function c67508932.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,1-tp,LOCATION_MZONE)
end
function c67508932.rfilter(c)
	return not c:IsReason(REASON_REDIRECT)
end
function c67508932.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		local rg=og:Filter(c67508932.rfilter,nil)
		if #rg>0 then
			local lab=0
			if c:GetFlagEffect(67508933)==0 then
				lab=c:GetFieldID()
				c:RegisterFlagEffect(67508933,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,lab)
			else
				lab=c:GetFlagEffectLabel(67508933)
			end
			for oc in aux.Next(rg) do
				oc:RegisterFlagEffect(67508932,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,lab)
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(HALF_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c67508932.spfilter(c,e,tp,sp)
	local lab=c:GetFlagEffectLabel(67508932)
	return lab and lab==e:GetHandler():GetFlagEffectLabel(67508933)
		and c:GetReasonPlayer()==tp
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,sp)
end
function c67508932.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(67508933)>0
end
function c67508932.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c67508932.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,e,tp,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,tp,LOCATION_REMOVED)
end
function c67508932.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c67508932.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,e,tp,1-tp)
	local sp=1-tp
	local res=false
	local ft2=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_ONFIELD,0,1,nil,9409625,36894320,72883039) and Duel.IsExistingMatchingCard(c67508932.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp,tp) and ft2>0 and (#tg==0 or Duel.SelectYesNo(tp,aux.Stringid(67508932,5))) then
		ft=ft2
		res=true
		sp=tp
		tg=Duel.GetMatchingGroup(c67508932.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,e,tp,tp)
	end
	if ft<=0 or #tg==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,sp,false,false,POS_FACEUP)
	end
end
function c67508932.pfilter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsCode(9409625,36894320,72883039)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c67508932.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c67508932.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c67508932.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67508932.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end