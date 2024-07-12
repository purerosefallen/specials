--ドン・サウザンドの玉座
function c93238626.initial_effect(c)
	c:SetUniqueOnField(1,0,93238626)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(93238626,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c93238626.rectg)
	e2:SetOperation(c93238626.recop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(93238626,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCondition(c93238626.spcon)
	e3:SetTarget(c93238626.sptg)
	e3:SetOperation(c93238626.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c93238626.condition)
	e4:SetTarget(c93238626.target)
	e4:SetOperation(c93238626.activate)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c93238626.regop)
	c:RegisterEffect(e5)
end
function c93238626.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local rem=g:GetSum(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rem)
end
function c93238626.recop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local rem=g:GetSum(Card.GetAttack)
	Duel.Recover(p,rem,REASON_EFFECT)
end
function c93238626.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0x48) and not at:IsSetCard(0x1048)
end
function c93238626.filter(c,e,tp,mc,no)
	return aux.GetXyzNumber(c)==no and c:IsSetCard(0x1048) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c93238626.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local at=Duel.GetAttackTarget()
		local no=aux.GetXyzNumber(at)
		return no and aux.MustMaterialCheck(at,tp,EFFECT_MUST_BE_XMATERIAL)
			and Duel.IsExistingMatchingCard(c93238626.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,at,no)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c93238626.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateAttack() then return end
	local tc=Duel.GetAttackTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	local no=aux.GetXyzNumber(tc)
	if tc:IsFacedown() or not tc:IsRelateToBattle() or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or not no then return end
	if not Duel.IsExistingMatchingCard(c93238626.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,at,no) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c93238626.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,no)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c93238626.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c93238626.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c93238626.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c93238626.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,93238626)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local rem=g:GetSum(Card.GetAttack)
	Duel.Recover(tp,rem,REASON_EFFECT)
end