--トゥーン・カオス・ソルジャー
function c28711704.initial_effect(c)
	aux.AddCodeList(c,15259703)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,c28711704.uqfilter,LOCATION_MZONE)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c28711704.hspcon)
	e1:SetTarget(c28711704.hsptg)
	e1:SetOperation(c28711704.hspop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c28711704.dircon)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28711704,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c28711704.rmtg)
	e3:SetOperation(c28711704.rmop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(28711704,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,28711704)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c28711704.thcon)
	e4:SetTarget(c28711704.thtg)
	e4:SetOperation(c28711704.thop)
	c:RegisterEffect(e4)
end
function c28711704.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c28711704.uqfilter(c)
	if Duel.IsExistingMatchingCard(c28711704.cfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		return false
	else
		return c:IsType(TYPE_TOON)
	end
end
function c28711704.rfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsLevelAbove(1)
		and c:IsAbleToRemoveAsCost()
end
function c28711704.fselect(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,8)
		and Duel.GetMZoneCount(tp,g)>0
end
function c28711704.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c28711704.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return rg:CheckSubGroup(c28711704.fselect,1,rg:GetCount(),tp)
end
function c28711704.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(c28711704.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=rg:SelectSubGroup(tp,c28711704.fselect,true,1,rg:GetCount(),tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c28711704.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
end
function c28711704.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c28711704.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c28711704.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c28711704.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c28711704.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c28711704.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c28711704.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c28711704.cfilter3(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c28711704.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28711704.cfilter3,tp,LOCATION_ONFIELD,0,1,nil)
end
function c28711704.thfilter(c)
	return c:IsAbleToHand()
end
function c28711704.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28711704.thfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_REMOVED)
end
function c28711704.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c28711704.thfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1,true)
	end
end