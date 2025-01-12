--魔神王的禁断契约书
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.sptg1)
	e2:SetOperation(s.spop1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.damcon)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
end
function s.spfilter1(c,e,tp)
	return c:IsSetCard(0x10af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.setfilter(c)
	return c:IsSetCard(0x10af) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
	local b2=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if chk==0 then return (Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) and b1)
		or (Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) and b2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_EXTRA)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
	local b2=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if not (#g1>=1 and b1) or not (#g2>=1 and b2) then return end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,3)},{b2,aux.Stringid(id,4)})
	if op==1 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>=2 then ft=2 end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=g1:Select(tp,1,ft,nil)
		if g:GetCount()>0 then
			local t1=g:GetFirst()
			local t2=g:GetNext()
			Duel.SpecialSummonStep(t1,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			t1:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			t1:RegisterEffect(e2,true)
			t1:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,c:GetFieldID())
			if t2 then
				Duel.SpecialSummonStep(t2,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				t2:RegisterEffect(e3,true)
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_DISABLE_EFFECT)
				e4:SetValue(RESET_TURN_SET)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				t2:RegisterEffect(e4,true)
				t2:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,c:GetFieldID())
			end
			if t1:IsPreviousLocation(LOCATION_EXTRA) or (t2 and t2:IsPreviousControler(LOCATION_EXTRA)) then
				Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
				local e5=Effect.CreateEffect(e:GetHandler())
				e5:SetType(EFFECT_TYPE_FIELD)
				e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e5:SetTargetRange(1,0)
				e5:SetTarget(s.splimit)
				e5:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e5,tp)
			end
		end
	end
	if op==2 then
		local ft=0
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ft=ft+1 end
		if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ft=ft+1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g2:Select(tp,1,ft,nil)
		local tc1=sg:GetFirst()
		local tc2=sg:GetNext()
		if tc1 then
			Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
		if tc2 then
			Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true) 
		end
	end
end
function s.splimit(e,c)
	return not c:IsSetCard(0xaf)
end
--fusion
function s.filter0(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_FIEND) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.filter3(c,e,tp,m,f,chkf)
	return c:GetType()&(TYPE_FUSION|TYPE_PENDULUM)==TYPE_FUSION+TYPE_PENDULUM 
	and c:IsRace(RACE_FIEND) and (not f or f(c))
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_PZONE,0,nil,e)
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if res then return true end
		res=Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1+mg2,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res and Duel.GetFlagEffect(tp,id)<=0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_PZONE,0,nil,e)
	mg2:Merge(mg1)
	local sg2=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,chkf)
	sg1:Merge(sg2)
	local mg4=nil
	local sg3=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg4=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg4,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
		local sg=sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if tc:GetType()&(TYPE_PENDULUM|TYPE_FUSION)==TYPE_PENDULUM+TYPE_FUSION then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat2)
				Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat=Duel.SelectFusionMaterial(tp,tc,mg4,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,2000)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

