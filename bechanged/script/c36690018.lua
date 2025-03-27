--逆転する運命
function c36690018.initial_effect(c)
	aux.AddCodeList(c,73206827)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c36690018.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1154611,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,36690018)
	e2:SetCondition(c36690018.spcon)
	e2:SetTarget(c36690018.sptg)
	e2:SetOperation(c36690018.spop)
	c:RegisterEffect(e2)
end
function c36690018.filter(c,e,tp)
	return c:IsSetCard(0x5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c36690018.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_COIN_NEGATE)
	e2:SetCondition(c36690018.coincon)
	e2:SetOperation(c36690018.coinop)
	Duel.RegisterEffect(e2,tp)
	if Duel.IsEnvironment(73206827,tp,LOCATION_FZONE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c36690018.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(36690018,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c36690018.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c36690018.coincon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetFlagEffect(tp,36690018)==0
end
function c36690018.coinop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,36690018)~=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(36690018,0)) then
		Duel.Hint(HINT_CARD,0,36690018)
		Duel.RegisterFlagEffect(tp,36690018,RESET_PHASE+PHASE_END,0,1)
		Duel.TossCoin(tp,ev)
	end
end
function c36690018.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ex=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	return ex and rp==tp
end
function c36690018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,36690018,0,TYPES_NORMAL_TRAP_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c36690018.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,36690018,0,TYPES_NORMAL_TRAP_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end