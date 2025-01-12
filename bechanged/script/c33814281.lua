--特许权的契约书类
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.limfilter(c,tp)
	local rtype=c:GetType()&(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
	return c:GetSummonPlayer()==1-tp and rtype>0
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,rtype)
end
function s.cfilter(c,rtype)
	return c:IsFaceup() and c:GetType()&rtype>0
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.limfilter,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	local c=e:GetHandler()
	local g=eg:Filter(s.limfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		local rtype=tc:GetType()&(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
		local reset=RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetRange(LOCATION_FZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(reset)
		e1:SetTargetRange(0,1)
		e1:SetLabel(rtype)
		e1:SetTarget(s.sumlimit)
		c:RegisterEffect(e1)
		if (rtype&TYPE_FUSION)>0 and c:GetFlagEffect(id)==0 then
			c:RegisterFlagEffect(id,reset,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
		end
		if (rtype&TYPE_SYNCHRO)>0 and c:GetFlagEffect(id+1)==0 then
			c:RegisterFlagEffect(id+1,reset,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
		end
		if (rtype&TYPE_XYZ)>0 and c:GetFlagEffect(id+2)==0 then
			c:RegisterFlagEffect(id+2,reset,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
		end
		if (rtype&TYPE_LINK)>0 and c:GetFlagEffect(id+3)==0 then
			c:RegisterFlagEffect(id+3,reset,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		end
		tc=g:GetNext()
	end
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(e:GetLabel())
end
function s.thfilter(c)
	return (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) or c:IsLocation(LOCATION_GRAVE))
		and c:IsSetCard(0xaf) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
