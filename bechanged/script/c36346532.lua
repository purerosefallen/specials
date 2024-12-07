--バージェストマ・カンブロラスター
---@param c Card
function c36346532.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xd4),2,2)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(36346532,2))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,36346532+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c36346532.spcon)
	e0:SetTarget(c36346532.sptg)
	e0:SetOperation(c36346532.spop)
	c:RegisterEffect(e0)
	--special summon
	local e00=Effect.CreateEffect(c)
	e00:SetDescription(aux.Stringid(36346532,3))
	e00:SetType(EFFECT_TYPE_FIELD)
	e00:SetCode(EFFECT_SPSUMMON_PROC)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetRange(LOCATION_EXTRA)
	e00:SetCountLimit(1,36346532+EFFECT_COUNT_CODE_OATH)
	e00:SetCondition(c36346532.spcon2)
	e00:SetTarget(c36346532.sptg2)
	e00:SetOperation(c36346532.spop2)
	c:RegisterEffect(e00)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c36346532.efilter)
	c:RegisterEffect(e1)
	--to grave/set card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36346532,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,36346532)
	e2:SetTarget(c36346532.settg)
	e2:SetOperation(c36346532.setop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,36346533)
	e3:SetTarget(c36346532.desreptg)
	e3:SetValue(c36346532.desrepval)
	e3:SetOperation(c36346532.desrepop)
	c:RegisterEffect(e3)
end
function c36346532.spfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd4) and c:IsType(TYPE_XYZ) and c:IsAbleToGraveAsCost()
		and Duel.GetMZoneCount(tp,c)>0
end
function c36346532.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c36346532.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c36346532.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c36346532.spfilter,tp,LOCATION_MZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c36346532.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
function c36346532.spfilter2(c,tp)
	return c:IsFacedown() and c:GetType()==TYPE_TRAP and c:IsAbleToGraveAsCost()
		and Duel.GetMZoneCount(tp,c)>0
end
function c36346532.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c36346532.spfilter2,tp,LOCATION_ONFIELD,0,2,nil,tp)
end
function c36346532.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c36346532.spfilter2,tp,LOCATION_ONFIELD,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.TRUE,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c36346532.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
function c36346532.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()
end
function c36346532.cfilter(c,tp)
	return c:GetSequence()<5 and c:IsFacedown() and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c36346532.setfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c36346532.setfilter(c,mc,tp)
	if not (c:IsSetCard(0xd4) and c:IsType(TYPE_TRAP)) then return false end
	if not mc or mc:IsControler(1-tp) then
		return c:IsSSetable()
	else
		return c:IsSSetable(true)
	end
end
function c36346532.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c36346532.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c36346532.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c36346532.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c36346532.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c36346532.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		local sc=g:GetFirst()
		if sc and Duel.SSet(tp,sc)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(36346532,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
		end
	end
end
function c36346532.repfilter(c,tp)
	return c:IsFacedown() and c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c36346532.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c36346532.repfilter,1,c,tp) and c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c36346532.desrepval(e,c)
	return c36346532.repfilter(c,e:GetHandlerPlayer())
end
function c36346532.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
