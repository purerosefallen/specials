--影雄の烬 エグリスタ
local s,id,o=GetID()
function s.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e11)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_FUSION_SUMMON)
	e2:SetCondition(s.fspcon)
	e2:SetTarget(s.fsptg)
	e2:SetOperation(s.fspop)
	c:RegisterEffect(e2)
	s.shadoll_flip_effect=e1
	--shaddoll
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+2)
	e3:SetCondition(s.con)
	e3:SetTarget(s.tg)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
end
function s.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsSetCard(0x9d) and c:IsFaceup()
end
function s.rfilter(c)
	return c:IsType(TYPE_FLIP) and c:IsSetCard(0x9d)
end
function s.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x9d) and not c:IsRace(RACE_ROCK) and not c:IsCode(id)) then return false end
	local te=c.shadoll_flip_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.efffilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(s.efffilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.efffilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te=tc.shadoll_flip_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local te=tc.shadoll_flip_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function s.fspcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL and e:GetHandler():IsReason(REASON_EFFECT)
end
function s.mfilter(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function s.sfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9d) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.gfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and s.mfilter(c,e)
end
function s.fsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(s.mfilter,nil,e)
			+Duel.GetMatchingGroup(s.gfilter,tp,LOCATION_GRAVE,0,nil,e)
		local res=Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD)
end
function s.fspop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.mfilter,nil,e)
		+Duel.GetMatchingGroup(s.gfilter,tp,LOCATION_GRAVE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		::cancel::
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			if #mat<2 then goto cancel end
			tc:SetMaterial(mat)
			Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			if #mat<2 then goto cancel end
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.tarfilter(c,e,tp,ec)
	return c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ec:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.tarfilter(chkc,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(s.tarfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,s.tarfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,c):GetFirst()
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0
	and c:IsRelateToEffect(e)
		then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		end
	end
end
