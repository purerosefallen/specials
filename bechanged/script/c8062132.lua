--毒蛇神ヴェノミナーガ
---@param c Card
function c8062132.initial_effect(c)
	c:EnableCounterPermit(0x11)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c8062132.splimit)
	c:RegisterEffect(e1)
	--special summon1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c8062132.spcon)
	e2:SetTarget(c8062132.sptg)
	e2:SetOperation(c8062132.spop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c8062132.atkval)
	c:RegisterEffect(e3)
	--special summon2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(8062132,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetCountLimit(1,8062132)
	e4:SetCondition(c8062132.condition)
	e4:SetCost(c8062132.cost)
	e4:SetTarget(c8062132.target)
	e4:SetOperation(c8062132.operation)
	c:RegisterEffect(e4)
	--unaffectable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c8062132.efilter)
	c:RegisterEffect(e6)
	--counter
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(8062132,1))
	e7:SetCategory(CATEGORY_COUNTER)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_DAMAGE)
	e7:SetCondition(c8062132.ctcon)
	e7:SetOperation(c8062132.ctop)
	c:RegisterEffect(e7)
	--win
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_ADJUST)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetOperation(c8062132.winop)
	c:RegisterEffect(e8)
end
function c8062132.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsCode(16067089) or sc==e:GetHandler()
end
function c8062132.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON)
	return rg:CheckSubGroup(aux.mzctcheckrel,3,3,tp,REASON_SPSUMMON)
end
function c8062132.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,aux.mzctcheckrel,true,3,3,tp,REASON_SPSUMMON)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c8062132.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c8062132.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c8062132.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_GRAVE,0,nil,RACE_REPTILE)*500
end
function c8062132.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c8062132.cfilter(c)
	return c:IsRace(RACE_REPTILE) and c:IsAbleToGraveAsCost()
end
function c8062132.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8062132.cfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c8062132.cfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c8062132.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c8062132.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c8062132.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c8062132.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x11,1)
end
function c8062132.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_VENNOMINAGA = 0x12
	local c=e:GetHandler()
	if c:GetCounter(0x11)==3 then
		Duel.Win(tp,WIN_REASON_VENNOMINAGA)
	end
end
