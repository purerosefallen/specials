--竜騎士ブラック・マジシャン・ガール
function c43892408.initial_effect(c)
	aux.AddCodeList(c,1784686)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,38033121,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),1,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c43892408.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43892408,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c43892408.cost)
	e2:SetTarget(c43892408.target)
	e2:SetOperation(c43892408.activate)
	c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76263644,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCountLimit(1)
	e3:SetTarget(c43892408.eqtg)
	e3:SetOperation(c43892408.spop)
	c:RegisterEffect(e3)
end
function c43892408.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsCode(1784686)
end
function c43892408.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c43892408.filter(c)
	return c:IsFaceup()
end
function c43892408.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c43892408.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c43892408.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c43892408.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c43892408.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c43892408.eqfilter(c,tp)
	local b1=c:IsType(TYPE_MONSTER) and (c:IsControler(tp) or c:IsAbleToChangeControler()) and c:IsRace(RACE_DRAGON) and not c:IsForbidden()
	local b2=c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden() 
	return b1 or b2
end
function c43892408.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c43892408.eqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	local g=Duel.GetFieldGroup(tp, LOCATION_GRAVE, LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c43892408.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c43892408.eqfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c43892408.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c43892408.eqlimit(e,c)
	return c==e:GetLabelObject()
end
