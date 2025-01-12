--ナンバーズ・エヴァイユ
function c20994205.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20994205.condition)
	e1:SetTarget(c20994205.target)
	e1:SetOperation(c20994205.activate)
	c:RegisterEffect(e1)
	if not c20994205.global_check then
		c20994205.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c20994205.chk)
		Duel.RegisterEffect(ge1,0)
	end
end
function c20994205.chkfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c20994205.chk(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		for tc in aux.Next(eg) do
			if c20994205.chkfilter(tc,p) then
				Duel.RegisterFlagEffect(p,20994205,0,0,1)
			end
		end
	end
end
function c20994205.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,20994205)>0
end
function c20994205.nofilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48) and aux.GetXyzNumber(c)
end
function c20994205.spfilter(c,e,tp)
	return c20994205.nofilter(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c20994205.gselect(g,spg)
	return spg:IsExists(c20994205.spnofilter,1,g,g:GetSum(aux.GetXyzNumber))
end
function c20994205.spnofilter(c,sum)
	return aux.GetXyzNumber(c)==sum
end
function c20994205.gcheck(max)
	return  function(g)
				return g:GetClassCount(Card.GetRank)==#g and g:GetSum(aux.GetXyzNumber)<=max
			end
end
function c20994205.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return false end
		local mg=Duel.GetMatchingGroup(c20994205.nofilter,tp,LOCATION_EXTRA,0,nil)
		local spg=Duel.GetMatchingGroup(c20994205.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if #mg<5 or #spg==0 then return false end
		local _,max=spg:GetMaxGroup(aux.GetXyzNumber)
		aux.GCheckAdditional=c20994205.gcheck(max)
		local res=mg:CheckSubGroup(c20994205.gselect,4,4,spg)
		aux.GCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c20994205.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	local mg=Duel.GetMatchingGroup(c20994205.nofilter,tp,LOCATION_EXTRA,0,nil)
	local spg=Duel.GetMatchingGroup(c20994205.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if #mg<5 or #spg==0 then return end
	local _,max=spg:GetMaxGroup(aux.GetXyzNumber)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	aux.GCheckAdditional=c20994205.gcheck(max)
	local sg=mg:SelectSubGroup(tp,c20994205.gselect,false,4,4,spg)
	aux.GCheckAdditional=nil
	if sg then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=spg:FilterSelect(tp,c20994205.spnofilter,1,1,sg,sg:GetSum(aux.GetXyzNumber)):GetFirst()
		xyz:SetMaterial(nil)
		Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		xyz:CompleteProcedure()
		Duel.Overlay(xyz,sg)
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(xyz,Group.FromCards(c))
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetCondition(c20994205.splimitcon)
		e1:SetTarget(c20994205.splimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		xyz:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(63060238)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetAbsoluteRange(tp,1,0)
		e2:SetCondition(c20994205.splimitcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		xyz:RegisterEffect(e2,true)
		if xyz:IsCode(23187256) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(20994205,1))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetValue(c20994205.tglimit)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			xyz:RegisterEffect(e3,true)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(c20994205.efilter)
			e4:SetOwnerPlayer(tp)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			xyz:RegisterEffect(e4,true)
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_FIELD)
			e5:SetCode(EFFECT_CHANGE_DAMAGE)
			e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e5:SetRange(LOCATION_MZONE)
			e5:SetTargetRange(1,0)
			e5:SetValue(0)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			xyz:RegisterEffect(e5,true)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_NO_EFFECT_DAMAGE)
			xyz:RegisterEffect(e6,true)
		end
	end
end
function c20994205.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c20994205.tglimit(e,c)
	return c and not c:IsSetCard(0x48)
end
function c20994205.splimitcon(e)
	return e:GetHandler():IsControler(e:GetOwnerPlayer())
end
function c20994205.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c20994205.nofilter(c)
end
