--肉斩骨断
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(s.atkcon1)
	e1:SetOperation(s.atkop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(s.atkcon2)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop2)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	local g=Group.FromCards(a,b)
	if g:IsExists(s.filter,1,nil,tp) and ep==tp then
		Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
	end
end
function s.cfilter(c,tp)
	return c:GetBaseAttack()==0 and c:IsFaceup() and c:IsControler(tp)
end
function s.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	local g=Group.FromCards(a,b)
	return g:IsExists(s.cfilter,1,nil,tp)
end
function s.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	if a:IsControler(tp) then tc=a
	else tc=b end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e1)
	local res=Duel.TossCoin(tp,1)
	local atk=0
	if res==1 then atk=2000
	else atk=1200 end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(atk)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
	tc:RegisterEffect(e2)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,2)
end
function s.filter(c)
	return c:GetFlagEffect(id)>0 and c:IsFaceup() and c:GetAttackableTarget()
end
function s.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
end
function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	if #g<0 then return end
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1400)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local ph=Duel.GetCurrentPhase()
	--if ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL then return end
	Duel.BreakEffect()
	if Duel.GetLP(tp)>2000 then
	local c1,c2,c3,c4=Duel.TossCoin(tp,4)
	ct=c1+c2+c3+c4
	else ct=4 end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(ct*400)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==1 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(tc:GetAttack()*2)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
	local g2=Duel.GetMatchingGroup(s.cfilter1,tp,0,LOCATION_MZONE,nil,tc)
	if #g2>0 then
	   sg2=g2:Select(tp,1,1,nil)
	   tc2=sg2:GetFirst()
	   if tc2 then
		  Duel.CalculateDamage(tc,tc2,true)
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		  e1:SetCountLimit(1)
		  e1:SetOperation(s.desop2)
		  e1:SetReset(RESET_PHASE+PHASE_END)
		  Duel.RegisterEffect(e1,tp)
	   end
	end
end
function s.cfilter1(c,mc)
	return c:IsCanBeBattleTarget(mc)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end