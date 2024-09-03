--E・HERO コスモ・ネオス
function c90050480.initial_effect(c)
	aux.AddCodeList(c,8994372389943723)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,89943723,c90050480.ffilter,3,true,true)
	aux.AddContactFusionProcedure(c,c90050480.cfilter,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,aux.tdcfop(c))
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--return
	aux.EnableNeosReturn(c,c90050480.retop,c90050480.set_category)
	--act limit
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(90050480,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c90050480.limcon)
	e5:SetTarget(c90050480.limtg)
	e5:SetOperation(c90050480.limop)
	c:RegisterEffect(e5)
end
c90050480.material_setcode=0x8
function c90050480.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c90050480.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x1f) and (not sg or not sg:Filter(Card.IsFusionSetCard,nil,0x1f):IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function c90050480.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c90050480.set_category(e,tp,eg,ep,ev,re,r,rp)
	e:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c90050480.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) then
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c90050480.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function c90050480.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c90050480.chainlm)
end
function c90050480.chainlm(e,rp,tp)
	return tp==rp
end
function c90050480.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c90050480.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c90050480.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c90050480.atktg(e,c)
	return c:IsCode(89943723) or c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,89943723)
end