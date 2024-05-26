--A・O・J ディサイシブ・アームズ
function c9888196.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(9888196,3))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
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
			return tc:IsType(TYPE_TUNER) and sg:CheckWithSumEqual(Card.GetLevel,c:GetLevel()-tc:GetLevel(),2,128)
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
			return tc:IsType(TYPE_TUNER) and sg:CheckWithSumEqual(Card.GetLevel,c:GetLevel()-tc:GetLevel(),2,128)
		end,1,1,nil)
		g:Sub(tg)
		local lv=c:GetLevel()-tg:GetFirst():GetLevel()
		local ct=g:FilterCount(function (tc)
			return not tc:IsType(TYPE_TUNER)
		end,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:SelectWithSumEqual(tp,Card.GetLevel,lv,2,ct)
		sg:Merge(tg)
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end)
	c:RegisterEffect(e0)
	--destroy1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9888196,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9888196.con)
	e1:SetTarget(c9888196.destg1)
	e1:SetOperation(c9888196.desop1)
	c:RegisterEffect(e1)
	--destroy2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9888196,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9888196.con)
	e2:SetCost(c9888196.descost2)
	e2:SetTarget(c9888196.destg2)
	e2:SetOperation(c9888196.desop2)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9888196,2))
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9888196.con)
	e3:SetCost(c9888196.hdcost)
	e3:SetTarget(c9888196.hdtg)
	e3:SetOperation(c9888196.hdop)
	c:RegisterEffect(e3)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e6=e7:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e4=e7:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e7:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e5)
end
function c9888196.confilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c9888196.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9888196.confilter,tp,0,LOCATION_MZONE,1,nil)
end
function c9888196.filter1(c)
	return c:IsFacedown()
end
function c9888196.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c9888196.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9888196.filter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9888196.filter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9888196.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c9888196.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9888196.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9888196.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9888196.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c9888196.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9888196.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9888196.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c9888196.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9888196.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_HAND)
end
function c9888196.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	local sg=g:Filter(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)
	if sg:GetCount()>0 then
		local atk=0
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local tc=sg:GetFirst()
		while tc do
			local tatk=tc:GetAttack()
			if tatk<0 then tatk=0 end
			atk=atk+tatk
			tc=sg:GetNext()
		end
		Duel.BreakEffect()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end
