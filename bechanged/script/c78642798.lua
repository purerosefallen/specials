--黄金の邪教神
function c78642798.initial_effect(c)
	--Change the Name
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78642798,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c78642798.rntg)
	e1:SetOperation(c78642798.rnop)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78642798,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,78642798)
	e2:SetTarget(c78642798.eqtg)
	e2:SetOperation(c78642798.eqop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c78642798.eqcon)
	c:RegisterEffect(e3)
end
function c78642798.rntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)>0 end
end
function c78642798.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c78642798.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x1110) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c78642798.rnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleHand(1-tp)
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(27125110)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local chkf=tp
			local mg1=Duel.GetFusionMaterial(tp):Filter(c78642798.filter1,nil,e)
			local res=Duel.IsExistingMatchingCard(c78642798.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
			if not res then
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					local mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					res=Duel.IsExistingMatchingCard(c78642798.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
				end
			end
			if res and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				local chkf=tp
				local mg1=Duel.GetFusionMaterial(tp):Filter(c78642798.filter1,nil,e)
				local sg1=Duel.GetMatchingGroup(c78642798.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
				local mg2=nil
				local sg2=nil
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					sg2=Duel.GetMatchingGroup(c78642798.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
				end
				if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
					local sg=sg1:Clone()
					if sg2 then sg:Merge(sg2) end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=sg:Select(tp,1,1,nil)
					local tc=tg:GetFirst()
					if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
						local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
						tc:SetMaterial(mat1)
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
			end
		end
	end
end
function c78642798.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c78642798.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToChangeControler()
end
function c78642798.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x110) and not c:IsSummonableCard()
end
function c78642798.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c78642798.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78642798.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c78642798.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c78642798.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c78642798.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc1=Duel.GetFirstTarget()
	if tc1:IsRelateToEffect(e) and tc1:IsAbleToChangeControler() then
		local atk=tc1:GetTextAttack()
		if atk<0 then atk=0 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,c78642798.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if sg:GetCount()>0 then
			local tc2=sg:GetFirst()
			if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc2 then
				Duel.Equip(tp,tc1,tc2,false)
				--Gains ATK
				local e1=Effect.CreateEffect(tc1)
				e1:SetType(EFFECT_TYPE_EQUIP)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc1:RegisterEffect(e1)
				--Equip Limit
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_EQUIP_LIMIT)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(c78642798.eqlimit)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetLabelObject(tc2)
				tc1:RegisterEffect(e2)
			end
		end
	end
end
function c78642798.eqlimit(e,c)
	return c==e:GetLabelObject()
end
