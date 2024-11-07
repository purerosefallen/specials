--バイス・バーサーカー
function c43014054.initial_effect(c)
	--damage & atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43014054,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(c43014054.damcon)
	e1:SetTarget(c43014054.damtg)
	e1:SetOperation(c43014054.damop)
	c:RegisterEffect(e1)
	aux.CreateMaterialReasonCardRelation(c,e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(c43014054.matval)
	c:RegisterEffect(e2)
end
function c43014054.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c43014054.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rc=e:GetHandler():GetReasonCard()
	if rc:IsRelateToEffect(e) and rc:IsFaceup() then
		Duel.SetTargetCard(rc)
	end
	Duel.SetTargetPlayer(rp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,rp,2000)
end
function c43014054.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local rc=Duel.GetFirstTarget()
	if rc and rc:IsFaceup() and rc:IsRelateToChain() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(2000)
		rc:RegisterEffect(e1)
	end
end
function c43014054.matval(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(8) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON)
end