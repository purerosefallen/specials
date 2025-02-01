--真紅眼の凶雷皇－エビル・デーモン
---@param c Card
function c39357122.initial_effect(c)
	aux.EnableDualAttribute(c)
	--fusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c39357122.spcost)
	e1:SetTarget(c39357122.sptg)
	e1:SetOperation(c39357122.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(aux.IsDualState)
	e2:SetTarget(c39357122.destg)
	e2:SetOperation(c39357122.desop)
	c:RegisterEffect(e2)
end
function c39357122.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c39357122.spfilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c39357122.spfilter2(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and aux.IsMaterialListSetCard(c,0x3b) and (not f or f(c))	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FCheckAdditional=c.red_eyes_fusion_check or c39357122.fcheck
	local res=c:CheckFusionMaterial(m,e:GetHandler(),chkf)
	aux.FCheckAdditional=nil
	return res
end
function c39357122.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0x3b)
end
function c39357122.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c39357122.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c39357122.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c39357122.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	if not c:IsRelateToChain() or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(c39357122.spfilter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c39357122.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c39357122.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		aux.FCheckAdditional=tc.red_eyes_fusion_check or c39357122.fcheck
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,e:GetHandler(),chkf)
			tc:SetMaterial(mat1)
			if mat1:IsExists(c39357122.fdfilter,1,nil) then
				local cg=mat1:Filter(c39357122.fdfilter,nil)
				Duel.ConfirmCards(1-tp,cg)
			end
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FCheckAdditional=nil
end
function c39357122.fdfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFacedown() or c:IsLocation(LOCATION_HAND)
end
function c39357122.filter(c,atk)
	return c:IsFaceup() and c:IsDefenseBelow(atk-1)
end
function c39357122.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c39357122.filter,tp,0,LOCATION_MZONE,1,nil,atk) end
	local g=Duel.GetMatchingGroup(c39357122.filter,tp,0,LOCATION_MZONE,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c39357122.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local atk=c:GetAttack()
	local g=Duel.GetMatchingGroup(c39357122.filter,tp,0,LOCATION_MZONE,nil,atk)
	Duel.Destroy(g,REASON_EFFECT)
end
