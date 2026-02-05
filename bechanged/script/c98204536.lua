--先史遗产惊神殿-三巨石
function c98204536.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98204536,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98204536)
	e2:SetCost(c98204536.sumcost)
	e2:SetCondition(c98204536.sumcon)
	e2:SetTarget(c98204536.sumtg)
	e2:SetOperation(c98204536.sumop)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,98204537)
	e3:SetCondition(c98204536.rcon)
	e3:SetOperation(c98204536.rop)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98204536,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,98204536)
	e4:SetCondition(c98204536.setcon)
	e4:SetTarget(c98204536.settg)
	e4:SetOperation(c98204536.setop)
	c:RegisterEffect(e4)
end
function c98204536.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c98204536.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x70)
end
function c98204536.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c98204536.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98204536.sumfilter(c)
	return c:IsSetCard(0x70) and c:IsSummonable(true,nil)
end
function c98204536.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98204536.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,LOCATION_HAND)
end
function c98204536.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c98204536.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c98204536.rcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and rc:GetOverlayCount()>=ev-1 and (rc:IsSetCard(0x70) or rc:IsSetCard(0x48)) and e:GetHandler():IsAbleToGraveAsCost() and ep==e:GetOwnerPlayer()
end
function c98204536.rop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function c98204536.cfilter2(c)
	return c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack()
end
function c98204536.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98204536.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c98204536.setfilter(c)
	return c:IsSetCard(0x70) and (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP) and c:IsSSetable()
end
function c98204536.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98204536.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c98204536.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c98204536.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end
