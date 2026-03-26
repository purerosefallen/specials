--インフェルニティ・デストロイヤー
function c98954375.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98954375,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCondition(c98954375.damcon)
	e1:SetTarget(c98954375.damtg)
	e1:SetOperation(c98954375.damop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MONSTER_SSET)
	e2:SetValue(TYPE_SPELL)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(c98954375.spcon)
	e3:SetTarget(c98954375.sptg)
	e3:SetOperation(c98954375.spop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c98954375.setcon)
	e4:SetTarget(c98954375.settg)
	e4:SetOperation(c98954375.setop)
	c:RegisterEffect(e4)
end
function c98954375.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEDOWN)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c98954375.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	if e:GetHandler():IsLocation(0x10) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function c98954375.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL)
		c:RegisterEffect(e1)
	end
end
function c98954375.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and e:GetHandler():IsFacedown()
end
function c98954375.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c98954375.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98954375.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttacker()
	if d==c then d=Duel.GetAttackTarget() end
	return c:IsRelateToBattle()
		and d:IsLocation(LOCATION_GRAVE) and d:IsReason(REASON_BATTLE) and d:IsType(TYPE_MONSTER)
end
function c98954375.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1600)
end
function c98954375.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
