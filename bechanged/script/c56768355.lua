--ヴァイロン・アルファ
function c56768355.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(9888196,3))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(function (e)
		local tp=e:GetHandlerPlayer()
		local g=Duel.GetMatchingGroup(function (tc)
			return tc:IsAbleToRemoveAsCost() and tc:IsFaceupEx() and tc:IsLevelAbove(0) and tc:IsLevelBelow(c:GetLevel()) and tc:IsType(TYPE_MONSTER)
		end,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		return g:IsExists(function (tc)
			local sg=g:Clone()
			sg:RemoveCard(tc)
			sg=sg:Filter(function (tc1) return not tc1:IsType(TYPE_TUNER) end,nil)
			return tc:IsType(TYPE_TUNER) and sg:CheckWithSumEqual(Card.GetLevel,c:GetLevel()-tc:GetLevel(),1,128)
		end,1,nil)
	end)
	e0:SetOperation(function (e,tp)
		local g=Duel.GetMatchingGroup(function (tc)
			return tc:IsAbleToRemoveAsCost() and tc:IsFaceupEx() and tc:IsLevelAbove(0) and tc:IsLevelBelow(c:GetLevel()) and tc:IsType(TYPE_MONSTER)
		end,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=g:FilterSelect(tp,function (tc)
			local sg=g:Clone()
			sg:RemoveCard(tc)
			sg=sg:Filter(function (tc1) return not tc1:IsType(TYPE_TUNER) end,nil)
			return tc:IsType(TYPE_TUNER) and sg:CheckWithSumEqual(Card.GetLevel,c:GetLevel()-tc:GetLevel(),1,128)
		end,1,1,nil)
		g:Sub(tg)
		local lv=c:GetLevel()-tg:GetFirst():GetLevel()
		local ct=g:FilterCount(function (tc)
			return not tc:IsType(TYPE_TUNER)
		end,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:SelectWithSumEqual(tp,Card.GetLevel,lv,1,ct)
		sg:Merge(tg)
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(56768355,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c56768355.eqcon)
	e1:SetTarget(c56768355.eqtg)
	e1:SetOperation(c56768355.eqop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(c56768355.indcon)
	e2:SetValue(c56768355.indval)
	c:RegisterEffect(e2)
end
function c56768355.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c56768355.filter(c,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c56768355.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c56768355.filter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c56768355.filter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c56768355.filter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c56768355.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Equip(tp,tc,c)
	end
end
function c56768355.indcon(e)
	return e:GetHandler():GetEquipCount()>0
end
function c56768355.indval(e,re)
	if not re then return false end
	local ty=re:GetActiveType()
	return bit.band(ty,TYPE_SPELL+TYPE_TRAP)~=0 and bit.band(ty,TYPE_EQUIP)==0
end
