--竜星因士－セフィラツバーン
function c96223501.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c96223501.negcon)
	e1:SetOperation(c96223501.negop)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,96223501)
	e3:SetTarget(c96223501.target)
	e3:SetOperation(c96223501.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c96223501.condition)
	c:RegisterEffect(e5)
	c96223501.star_knight_summon_effect=e3
end
function c96223501.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x9c,0xc4) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c96223501.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c96223501.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x9c,0xc4)
end
function c96223501.filter2(c)
	return c:IsFaceup()
end
function c96223501.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c96223501.filter1,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(c96223501.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c96223501.filter1,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c96223501.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c96223501.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c96223501.cdfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x9c) or c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_XYZ))
end
function c96223501.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and Duel.IsExistingMatchingCard(c96223501.cdfilter,tp,LOCATION_MZONE,0,1,nil)
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and c:GetFlagEffect(96223501)==0
end
function c96223501.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(96223501,1)) then
		Duel.Hint(HINT_CARD,0,96223501)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(96223501,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end