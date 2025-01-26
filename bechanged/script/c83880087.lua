--ムーンバリア
function c83880087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_DISABLED)
	e1:SetTarget(c83880087.target)
	e1:SetOperation(c83880087.endop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c83880087.target2)
	e2:SetOperation(c83880087.atkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(c83880087.target3)
	e3:SetOperation(c83880087.spop)
	c:RegisterEffect(e3)
	--remove overlay replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(83880087,3))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c83880087.rcon)
	e4:SetOperation(c83880087.rop)
	c:RegisterEffect(e4)
end
function c83880087.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x107f)
end
function c83880087.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c83880087.endop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,turnp)
end
function c83880087.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c83880087.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c83880087.filter,tp,LOCATION_MZONE,0,1,nil) end
	e:SetCategory(CATEGORY_ATKCHANGE)
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c83880087.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c83880087.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c83880087.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated()
		and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0x107f)
		and e:GetHandler():IsAbleToHandAsCost()
		and ep==e:GetOwnerPlayer() and ev==1
end
function c83880087.rop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c83880087.filter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c83880087.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetLevel())
end
function c83880087.filter2(c,e,tp,mc,lv)
	return c:IsSetCard(0x107f) and c:IsRank(lv) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c83880087.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ect=aux.ExtraDeckSummonCountLimit and Duel.IsPlayerAffectedByEffect(tp,92345028)
		and aux.ExtraDeckSummonCountLimit[tp]
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetFlagEffect(tp,57734012)==0 and loc~=0
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c83880087.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c83880087.spop(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	local ect=aux.ExtraDeckSummonCountLimit and Duel.IsPlayerAffectedByEffect(tp,92345028)
		and aux.ExtraDeckSummonCountLimit[tp]
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c83880087.filter1),tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	if tc1 and Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if not aux.MustMaterialCheck(tc1,tp,EFFECT_MUST_BE_XMATERIAL) then return end
		local no=aux.GetXyzNumber(tc1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c83880087.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc1,tc1:GetLevel())
		local tc2=g2:GetFirst()
		if tc2 then
			Duel.BreakEffect()
			tc2:SetMaterial(g1)
			Duel.Overlay(tc2,g1)
			Duel.SpecialSummon(tc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc2:CompleteProcedure()
		end
	end
end