--アンドロ・スフィンクス
function c15013468.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c15013468.spcon)
	e2:SetOperation(c15013468.spop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15013468,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c15013468.damcon)
	e3:SetTarget(c15013468.damtg)
	e3:SetOperation(c15013468.damop)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(c15013468.atklimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--spsummon or tohand
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,15013468,{EVENT_TO_GRAVE})
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE+CATEGORY_GRAVE_SPSUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(custom_code)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c15013468.stcon)
	e6:SetTarget(c15013468.sttg)
	e6:SetOperation(c15013468.stop)
	c:RegisterEffect(e6)
end
function c15013468.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c15013468.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.CheckLPCost(c:GetControler(),500)
end
function c15013468.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,500)
end
function c15013468.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bit.band(bc:GetBattlePosition(),POS_DEFENSE)~=0
end
function c15013468.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=math.floor(e:GetHandler():GetBattleTarget():GetBaseAttack()/2)
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c15013468.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c15013468.stfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetOwner()==tp and c:IsLocation(LOCATION_GRAVE) and (c:IsAbleToHand() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c15013468.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c15013468.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c15013468.stfilter,nil,e,tp)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g)
end
function c15013468.stop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c15013468.stfilter,nil,e,tp)
	local mg=g:Filter(aux.NecroValleyFilter(Card.IsRelateToChain),nil)
	if #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local og=mg:Select(tp,1,1,nil)
		local tc=og:GetFirst()
		if tc then
			local op=aux.SelectFromOptions(tp,{Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false),1152},{tc:IsAbleToRemove(),1190})
			if op==1 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			elseif op==2 then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
		end
	end
end
