--転生炎獣ベイルリンクス
---@param c Card
function c14812471.initial_effect(c)
	aux.AddCodeList(c,1295111)
	--link summon
	aux.AddLinkProcedure(c,c14812471.mfilter,1,1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14812471,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,14812471)
	e1:SetCondition(c14812471.thcon)
	e1:SetTarget(c14812471.thtg)
	e1:SetOperation(c14812471.thop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,14812472)
	e2:SetTarget(c14812471.reptg)
	e2:SetValue(c14812471.repval)
	e2:SetOperation(c14812471.repop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCondition(c14812471.condition)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(c14812471.valcheck)
	e5:SetLabelObject(e4)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e5)
end
function c14812471.mfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkRace(RACE_CYBERSE)
end
function c14812471.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c14812471.thfilter(c,res)
	return (c:IsCode(1295111) or res and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x119)) and c:IsAbleToHand()
end
function c14812471.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=Duel.IsEnvironment(1295111,tp,LOCATION_FZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c14812471.thfilter,tp,LOCATION_DECK,0,1,nil,res) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14812471.thop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.IsEnvironment(1295111,tp,LOCATION_FZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c14812471.thfilter,tp,LOCATION_DECK,0,1,1,nil,res)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c14812471.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x119)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c14812471.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c14812471.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c14812471.repval(e,c)
	return c14812471.repfilter(c,e:GetHandlerPlayer())
end
function c14812471.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c14812471.condition(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c14812471.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,14812471) then
		e:GetLabelObject():SetLabel(1)
		e:GetLabelObject():GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
		e:GetLabelObject():GetLabelObject():SetLabel(0)
	end
end