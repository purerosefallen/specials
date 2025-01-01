--蛇神 格
function c82103466.initial_effect(c)
		--summon with 3 tribute
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(10000010,2))
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
		e1:SetCondition(c82103466.ttcon)
		e1:SetOperation(c82103466.ttop)
		e1:SetValue(SUMMON_TYPE_ADVANCE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LIMIT_SET_PROC)
		e2:SetCondition(c82103466.setcon)
		c:RegisterEffect(e2)
	--c:EnableReviveLimit()
	--connot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82103466,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c82103466.spcon)
	--e1:SetCost(c82103466.spcost)
	e1:SetTarget(c82103466.sptg)
	e1:SetOperation(c82103466.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c82103466.leaveop)
	c:RegisterEffect(e2)
	--LP remain 0
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c82103466.condition)
	e3:SetOperation(c82103466.operation)
	c:RegisterEffect(e3)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c82103466.efilter)
	c:RegisterEffect(e3)
	--attack cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_COST)
	e4:SetCost(c82103466.atcost)
	e4:SetOperation(c82103466.atop)
	c:RegisterEffect(e4)
    --cannot lose
	local ex1=Effect.CreateEffect(c)
	ex1:SetType(EFFECT_TYPE_FIELD)
	ex1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ex1:SetRange(LOCATION_MZONE)
	ex1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
	ex1:SetTargetRange(1,0)
	ex1:SetValue(1)
	c:RegisterEffect(ex1)
	--[[local ex2=Effect.CreateEffect(c)
	ex2:SetType(EFFECT_TYPE_FIELD)
	ex2:SetCode(0x10000000+82103466)
	ex2:SetRange(LOCATION_MZONE)
	ex2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ex2:SetTargetRange(1,0)
	c:RegisterEffect(ex2)
	if not c82103466.lose_check then
		c82103466.lose_check=true
		local fuc_win=Duel.Win
		function Duel.Win(player,reason)
			if Duel.GetFlagEffect(1-player,82103466)~=0 then
				return false
			else
				return fuc_win(player,reason)
			end
		end
	end]]
end
function c82103466.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c82103466.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c82103466.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c82103466.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and ((c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp))
		or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
end
function c82103466.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c82103466.cfilter,1,nil,tp)
end
function c82103466.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c82103466.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c82103466.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
		Duel.BreakEffect()
		Duel.SetLP(tp,0)
	end
end
function c82103466.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_RELAY_SOUL=0x1a
	Duel.Win(1-tp,WIN_REASON_RELAY_SOUL)
end
function c82103466.condition(e,tp)
	return Duel.GetLP(tp)>0
end
function c82103466.operation(e,tp)
	Duel.SetLP(tp,0)
end
function c82103466.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c82103466.atcost(e,c,tp)
	return Duel.IsPlayerCanDiscardDeckAsCost(tp,10)
end
function c82103466.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,10,REASON_COST)
end
