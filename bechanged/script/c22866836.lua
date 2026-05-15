--超信地旋回
function c22866836.initial_effect(c)
	--destroy monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22866836,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c22866836.target1)
	e1:SetOperation(c22866836.operation1)
	c:RegisterEffect(e1)
	--destroy s&t
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22866836,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c22866836.target2)
	e2:SetOperation(c22866836.operation2)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22866836,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22866836)
	e3:SetCondition(c22866836.setcon)
	e3:SetTarget(c22866836.settg)
	e3:SetOperation(c22866836.setop)
	c:RegisterEffect(e3)
	--aist
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(22866836,3))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetValue(22866836)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c22866836.condition0)
	e0:SetCost(c22866836.cost0)
	c:RegisterEffect(e0)
end

function c22866836.tgfilter1(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
		and c:IsType(TYPE_XYZ) and c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c22866836.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c22866836.tgfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local pg=Duel.SelectTarget(tp,c22866836.tgfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,pg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function c22866836.operation1(e,tp,eg,ep,ev,re,r,rp)
	local ex1,pg=Duel.GetOperationInfo(0,CATEGORY_POSITION)
	local ex2,dg=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local pc=pg:GetFirst()
	local dc=dg:GetFirst()
	if pc:IsRelateToEffect(e) and dc:IsRelateToEffect(e)
		and pc:IsControler(tp)
		and Duel.ChangePosition(pc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0
		and dc:IsControler(1-tp) then
		Duel.Destroy(dc,REASON_EFFECT)
	end
end
function c22866836.tgfilter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
		and c:IsType(TYPE_XYZ) and c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c22866836.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_SZONE,1,nil)
		and Duel.IsExistingTarget(c22866836.tgfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local pg=Duel.SelectTarget(tp,c22866836.tgfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,nil,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,pg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function c22866836.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ex1,pg=Duel.GetOperationInfo(0,CATEGORY_POSITION)
	local ex2,dg=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local pc=pg:GetFirst()
	local dc=dg:GetFirst()
	if pc:IsRelateToEffect(e) and dc:IsRelateToEffect(e)
		and pc:IsControler(tp)
		and Duel.ChangePosition(pc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0
		and dc:IsControler(1-tp) then
		Duel.Destroy(dc,REASON_EFFECT)
	end
end


function c22866836.setfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) 
	and c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) 
end
function c22866836.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22866836.setfilter,1,nil,tp)
end
function c22866836.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c22866836.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
	Duel.SSet(tp,c)   
	end
end


function c22866836.condition0(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function c22866836.costfilter0(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsReleasable()
end
function c22866836.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22866836.costfilter0,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c22866836.costfilter0,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Release(g,REASON_COST)
	Duel.ShuffleHand(tp)
end
