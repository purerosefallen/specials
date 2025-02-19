--蒸汽机人
function c44729197.initial_effect(c)
	-----atkchange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44729197,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c44729197.condtion)
	e1:SetValue(c44729197.val)
	c:RegisterEffect(e1)
	-----spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44729197,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,44729197+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c44729197.spcon)
	c:RegisterEffect(e2)
	------th
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(44729197,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,44729199)
	e3:SetTarget(c44729197.thtg)
	e3:SetOperation(c44729197.thop)
	c:RegisterEffect(e3)
	end


-----------1
function c44729197.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL
end
function c44729197.val(e,c)
	if Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil then return 1800
	elseif e:GetHandler()==Duel.GetAttackTarget() then return -1800
	else return 0 end
end

------------2

function c44729197.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x16) and not c:IsAttribute(ATTRIBUTE_WIND)
end
function c44729197.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44729197.spfilter,tp,LOCATION_MZONE,nil,1,nil)
end


------------3

function c44729197.filter(c)
	return c:IsCode(23299957) and c:IsAbleToHand()
end
function c44729197.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44729197.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c44729197.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c44729197.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
