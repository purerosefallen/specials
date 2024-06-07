--クリアー・ワールド
function c28065291.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,28065291)
	e2:SetTarget(c28065291.srtg)
	e2:SetOperation(c28065291.srop)
	c:RegisterEffect(e2)
	--adjust
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(c28065291.adjustop)
	c:RegisterEffect(e3)
	--light
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PUBLIC)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e4:SetTarget(c28065291.lighttg)
	c:RegisterEffect(e4)
	--dark
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCondition(c28065291.darkcon1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCondition(c28065291.darkcon2)
	e6:SetTargetRange(0,1)
	c:RegisterEffect(e6)
	--earth
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(28065291,1))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_FZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetCondition(c28065291.descon1)
	e7:SetTarget(c28065291.destg1)
	e7:SetOperation(c28065291.desop1)
	c:RegisterEffect(e7)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(28065291,1))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_FZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetCondition(c28065291.descon2)
	e7:SetTarget(c28065291.destg2)
	e7:SetOperation(c28065291.desop2)
	c:RegisterEffect(e7)
	--water
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(28065291,2))
	e8:SetCategory(CATEGORY_HANDES)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c28065291.hdcon1)
	e8:SetTarget(c28065291.hdtg1)
	e8:SetOperation(c28065291.hdop1)
	c:RegisterEffect(e8)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(28065291,2))
	e8:SetCategory(CATEGORY_HANDES)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c28065291.hdcon2)
	e8:SetTarget(c28065291.hdtg2)
	e8:SetOperation(c28065291.hdop2)
	c:RegisterEffect(e8)
	--fire
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(28065291,3))
	e9:SetCategory(CATEGORY_DAMAGE)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetRange(LOCATION_FZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(c28065291.damcon1)
	e9:SetTarget(c28065291.damtg1)
	e9:SetOperation(c28065291.damop1)
	c:RegisterEffect(e9)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(28065291,3))
	e9:SetCategory(CATEGORY_DAMAGE)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetRange(LOCATION_FZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(c28065291.damcon2)
	e9:SetTarget(c28065291.damtg2)
	e9:SetOperation(c28065291.damop2)
	c:RegisterEffect(e9)
	--wind 
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetCode(EFFECT_CANNOT_ACTIVATE)
	e10:SetRange(LOCATION_FZONE)
	e10:SetTargetRange(1,0)
	e10:SetCondition(c28065291.windcon1)
	e10:SetValue(c28065291.actlimit)
	c:RegisterEffect(e10)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetCode(EFFECT_CANNOT_ACTIVATE)
	e10:SetRange(LOCATION_FZONE)
	e10:SetTargetRange(0,1)
	e10:SetCondition(c28065291.windcon2)
	e10:SetValue(c28065291.actlimit)
	c:RegisterEffect(e10)
	--local e10=Effect.CreateEffect(c)
	--e10:SetType(EFFECT_TYPE_FIELD)
	--e10:SetCode(EFFECT_ACTIVATE_COST)
	--e10:SetRange(LOCATION_FZONE)
	--e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e10:SetTargetRange(1,0)
	--e10:SetTarget(c28065291.actarget)
	--e10:SetCondition(c28065291.windcon1)
	--e10:SetCost(c28065291.costchk)
	--e10:SetOperation(c28065291.costop)
	--c:RegisterEffect(e10)
	--local e11=e10:Clone()
	--e11:SetTargetRange(0,1)
	--e11:SetCondition(c28065291.windcon2)
	--c:RegisterEffect(e11)
end
function c28065291.srfilter(c)
	return (c:IsCode(33900648) or aux.IsCodeListed(c,33900648)) and c:IsAbleToHand()
end
function c28065291.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28065291.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c28065291.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c28065291.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
c28065291[0]=0
c28065291[1]=0
function c28065291.adjustop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
	if Duel.IsPlayerAffectedByEffect(p,100222010) then
		c28065291[p]=ATTRIBUTE_LIGHT+ATTRIBUTE_DARK+ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND 
	else
		local rac=0
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			rac=bit.bor(rac,tc:GetAttribute())
			tc=g:GetNext()
		end
		c28065291[p]=rac
	end 
	end
end
function c28065291.lighttg(e,c)
	return bit.band(c28065291[c:GetControler()],ATTRIBUTE_LIGHT)~=0
		and not Duel.IsPlayerAffectedByEffect(c:GetControler(),97811903)
end
function c28065291.darkcon1(e)
	return bit.band(c28065291[e:GetHandlerPlayer()],ATTRIBUTE_DARK)~=0 and not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),97811903)
end
function c28065291.darkcon2(e)
	return bit.band(c28065291[1-e:GetHandlerPlayer()],ATTRIBUTE_DARK)~=0 and not Duel.IsPlayerAffectedByEffect(1-e:GetHandlerPlayer(),97811903)
end
function c28065291.descon1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(c28065291[e:GetHandlerPlayer()],ATTRIBUTE_EARTH)~=0 and not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),97811903)
end
function c28065291.descon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(c28065291[1-e:GetHandlerPlayer()],ATTRIBUTE_EARTH)~=0 and not Duel.IsPlayerAffectedByEffect(1-e:GetHandlerPlayer(),97811903)
end
function c28065291.desfilter(c)
	return true 
end
function c28065291.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local turnp=tp 
	if chkc then return chkc:IsControler(turnp) and chkc:IsLocation(LOCATION_MZONE) and c28065291.desfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(turnp,c28065291.desfilter,turnp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c28065291.desop1(e,tp,eg,ep,ev,re,r,rp)
	local turnp=tp 
	if bit.band(c28065291[turnp],ATTRIBUTE_EARTH)==0
		or Duel.IsPlayerAffectedByEffect(turnp,97811903) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c28065291.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local turnp=1-tp 
	if chkc then return chkc:IsControler(turnp) and chkc:IsLocation(LOCATION_MZONE) and c28065291.desfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(turnp,c28065291.desfilter,turnp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c28065291.desop2(e,tp,eg,ep,ev,re,r,rp)
	local turnp=1-tp 
	if bit.band(c28065291[turnp],ATTRIBUTE_EARTH)==0
		or Duel.IsPlayerAffectedByEffect(turnp,97811903) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c28065291.hdcon1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(c28065291[tp],ATTRIBUTE_WATER)~=0
end
function c28065291.hdtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c28065291.hdop1(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(c28065291[tp],ATTRIBUTE_WATER)==0
		or Duel.IsPlayerAffectedByEffect(tp,97811903) then return end
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end
function c28065291.hdcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(c28065291[1-tp],ATTRIBUTE_WATER)~=0
end
function c28065291.hdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c28065291.hdop2(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(c28065291[1-tp],ATTRIBUTE_WATER)==0
		or Duel.IsPlayerAffectedByEffect(1-tp,97811903) then return end
	Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end
function c28065291.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(c28065291[tp],ATTRIBUTE_FIRE)~=0
end
function c28065291.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c28065291.damop1(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(c28065291[tp],ATTRIBUTE_FIRE)==0
		or Duel.IsPlayerAffectedByEffect(1-tp,97811903) then return end
	Duel.Damage(tp,1000,REASON_EFFECT)
end
function c28065291.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(c28065291[1-tp],ATTRIBUTE_FIRE)~=0
end
function c28065291.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c28065291.damop2(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(c28065291[1-tp],ATTRIBUTE_FIRE)==0
		or Duel.IsPlayerAffectedByEffect(1-tp,97811903) then return end
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end
function c28065291.windcon1(e)
	return bit.band(c28065291[e:GetHandlerPlayer()],ATTRIBUTE_WIND)~=0
		and not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),97811903)
end
function c28065291.windcon2(e)
	return bit.band(c28065291[1-e:GetHandlerPlayer()],ATTRIBUTE_WIND)~=0
		and not Duel.IsPlayerAffectedByEffect(1-e:GetHandlerPlayer(),97811903)
end
function c28065291.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) 
end

function c28065291.actarget(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_SPELL)
end
function c28065291.costchk(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c28065291.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
