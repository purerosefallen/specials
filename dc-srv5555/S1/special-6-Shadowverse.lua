--村规决斗：暗影之诗
--初始基本分为20。所有【失去基本分】【改变基本分】【支付基本分】的动作，需要和改变的实际生命值按1/400处理（改变基本分向上取整，支付基本分向下取整）。
--所有【恢复生命】效果变为1/400（向上取整），所有伤害变为原来的1/400（向上取整）。
--导致基本分超过20的处理只会把基本分变为20。
--所有怪兽在出场的回合不能攻击，所有怪兽不会被战斗破坏，所有怪兽可以直接攻击。
--怪兽与怪兽战斗的场合，双方受到的战斗伤害变为0，守备力下降对方怪兽的攻击力数值。伤害计算后，守备力为0的怪兽被破坏（当作战斗破坏）。
--第4回合后，所有怪兽得到以下效果。
--这个类型的效果1回合只能使用1次。这只怪兽的攻击力/守备力提高800点，【出场的回合不能攻击】的效果当作【出场的回合不能直接攻击】使用。
--这个效果在决斗中先攻者只能使用2次，后攻者只能使用3次。
--第一回合有1费，第二回合有2费，以此类推，最多为10。自己的回合开始时回复费用。
--通常召唤次数不限。通常召唤成功时，那个攻击力与守备力之和每有1000就要支付1费。费用不足的场合，每缺少1费支付1点生命代替，且那个回合不能再把怪兽通常召唤。
--陷阱/魔法的效果发动时要支付1费。没有费用的场合，自己不能把魔法·陷阱的效果发动。
--先攻抽1张，后攻第1回合抽2张。
--手卡上限是9张。任何时刻手卡超过9张时，新加入的那些卡直接送去墓地（有多张同时加入，则直到剩下9张为止随机送去墓地）。
CUNGUI = {}
function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end

CUNGUI.SVCosts = {}
CUNGUI.SVCosts[0]=0
CUNGUI.SVCosts[1]=0

local OrigSetLP=Duel.SetLP
local OrigRecover=Duel.Recover
local OrigCheckLPCost=Duel.CheckLPCost
local OrigPayLPCost=Duel.PayLPCost--CheckLPCost PayLPCost

--REWRITES

function CUNGUI.NewSetLP(p,lp)
	lp=math.ceil(lp/400)
	if lp > 20 then lp = 20 end
	OrigSetLP(p,lp)
end

function CUNGUI.NewRecover(player,value,reason,...)
	value=math.ceil(value/400)
	if Duel.GetLP(player)+value > 20 then value = 20 - Duel.GetLP(player) end
	if value == 0 then
		Duel.RaiseEvent(nil,EVENT_RECOVER,nil,reason,player,player,0)
	else
		OrigRecover(player,value,reason,...)
	end
end

function CUNGUI.NewCheckLPCost(player,cost)
	cost = math.floor(cost/400)
	return OrigCheckLPCost(player,cost)
end

function CUNGUI.NewPayLPCost(player,cost)
	cost = math.floor(cost/400)
	return OrigPayLPCost(player,cost)
end

--REWRITES END

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterRuleEffects)
	g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil,TYPE_SPELL+TYPE_TRAP)
	g:ForEach(CUNGUI.RegisterSpellTrapRuleEffects)

	Duel.SetLP(0,20)
	Duel.SetLP(1,20)
	Duel.SetLP=CUNGUI.NewSetLP
	Duel.Recover=CUNGUI.NewRecover
	Duel.CheckLPCost=CUNGUI.NewCheckLPCost
	Duel.PayLPCost=CUNGUI.NewPayLPCost
	
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(CUNGUI.ChangeDamage)
	Duel.RegisterEffect(e1,0)
	--Recover SVCost
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCountLimit(1)
	e2:SetOperation(CUNGUI.RecoverSVCost)
	Duel.RegisterEffect(e2,0)
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(CUNGUI.DecreaseCostWhenUsingSpellOrTrap)
	Duel.RegisterEffect(e3,0)
	--cannot activate
	local e4=Effect.GlobalEffect()
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(1,1)
	e4:SetValue(CUNGUI.LimitSpellAndTrapWhenNoCost)
	Duel.RegisterEffect(e4,0)
	--Remove Summon Limit
	local e5=Effect.GlobalEffect()
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetValue(100)
	Duel.RegisterEffect(e5,0)
	local e6=Effect.GlobalEffect()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_MSET)
	e6:SetOperation(CUNGUI.MonsterUseCostMSet)
	Duel.RegisterEffect(e6,0)
	local e7=Effect.GlobalEffect()
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_HAND_LIMIT)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,1)
	e7:SetValue(9)
	Duel.RegisterEffect(e7,0)
	local e8=Effect.GlobalEffect()
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_TO_HAND)
	e8:SetOperation(CUNGUI.AdjustHand)
	Duel.RegisterEffect(e8,0)
	-- one more draw
	local e9=Effect.GlobalEffect()
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e9:SetCode(EVENT_ADJUST)
	e9:SetCountLimit(1)
	e9:SetOperation(function(ee)
		if Duel.GetTurnCount()==1 then
			Duel.Draw(0,1,REASON_RULE)
		elseif Duel.GetTurnCount()==2 then
			Duel.Draw(1,1,REASON_RULE)
			ee:Reset()
		end
	end)
	Duel.RegisterEffect(e9,0)
	e:Reset()
end

function CUNGUI.AdjustHand(e,tp,eg,ep,ev,re,r,rp)
	tp = eg:GetFirst():GetControler()
	local hand = Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #hand < 10 then return end
	if #hand - #eg < 10 then
		if #hand - #eg < 9 then
			local g2=eg:RandomSelect(tp,9-(#hand-#eg))
			eg:Sub(g2)
		end
	else
		hand:Sub(eg)
		local g2=hand:RandomSelect(tp,#hand-9)
		eg:Merge(g2)
	end
	Duel.SendtoGrave(eg,REASON_RULE+REASON_ADJUST)
end

function CUNGUI.LimitSpellAndTrapWhenNoCost(e,re,tp)
	local rc=re:GetHandler()
	return CUNGUI.SVCosts[rc:GetControler()]<1 and not rc:IsType(TYPE_MONSTER)
end

function CUNGUI.DecreaseCostWhenUsingSpellOrTrap(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) then return end
	local p = re:GetOwner():GetControler()
	CUNGUI.SVCosts[p] = CUNGUI.SVCosts[p] - 1
	Duel.Hint(p,HINT_NUMBER,CUNGUI.SVCosts[p])
	Duel.Hint(1-p,HINT_NUMBER,CUNGUI.SVCosts[p])
end

function CUNGUI.RecoverSVCost(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetTurnCount()
	local svcost=math.ceil(tc/2)
	if svcost > 10 then svcost = 10 end
	CUNGUI.SVCosts[Duel.GetTurnPlayer()]=svcost
	Duel.Hint(tp,HINT_NUMBER,svcost)
	Duel.Hint(1-tp,HINT_NUMBER,svcost)
end

function CUNGUI.ChangeDamage(e,re,val,r,rp,rc)
	return math.ceil(val/400)
end

function CUNGUI.RegisterMonsterRuleEffects(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--damage val
	local e2=e1:Clone()
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(CUNGUI.DamageValCondition)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(CUNGUI.BattleDestroy)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(CUNGUI.AttackLimit)
	c:RegisterEffect(e4)
	local ex4=e4:Clone()
	ex4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(ex4)
	--evolution
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(18563744,0))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetProperty(EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,98765432)
	e5:SetTarget(CUNGUI.EvolutionTarget)
	e5:SetOperation(CUNGUI.Evolution)
	c:RegisterEffect(e5)
	--use cost
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetOperation(CUNGUI.MonsterUseCost)
	c:RegisterEffect(e6)
	--sum limit
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_SUMMON)
	e7:SetCondition(CUNGUI.SummonLimit)
	c:RegisterEffect(e7)
	local ex7=e7:Clone()
	ex7:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(ex7)
	--direct attack
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e8)
end

function CUNGUI.RegisterSpellTrapRuleEffects(c)
end

function CUNGUI.SummonLimit(e)
	return CUNGUI.SVCosts[e:GetHandler():GetControler()]<1
end

function CUNGUI.MonsterUseCost(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetTextAttack()
	if atk < 0 then atk = 0 end
	local def=c:GetTextDefense()
	if def < 0 then def = 0 end
	local needCost = math.floor((atk+def)/1000)
	if CUNGUI.SVCosts[rp]>=needCost then
		CUNGUI.SVCosts[rp] = CUNGUI.SVCosts[rp] - needCost
		Duel.Hint(rp,HINT_NUMBER,CUNGUI.SVCosts[rp])
		Duel.Hint(1-rp,HINT_NUMBER,CUNGUI.SVCosts[rp])
	else
		needCost = needCost - CUNGUI.SVCosts[rp]
		if needCost > Duel.GetLP(rp) then needCost = Duel.GetLP(rp) end
		CUNGUI.SVCosts[rp] = 0
		OrigPayLPCost(rp,needCost)
		Duel.Hint(rp,HINT_NUMBER,0)
		Duel.Hint(1-rp,HINT_NUMBER,0)
	end
end

function CUNGUI.MonsterUseCostMSet(e,tp,eg,ep,ev,re,r,rp)
	if not eg or #eg==0 then return end
	local c=eg:GetFirst()
	local atk=c:GetTextAttack()
	if atk < 0 then atk = 0 end
	local def=c:GetTextDefense()
	if def < 0 then def = 0 end
	local needCost = math.floor((atk+def)/1000)
	if CUNGUI.SVCosts[rp]>=needCost then
		CUNGUI.SVCosts[rp] = CUNGUI.SVCosts[rp] - needCost
		Duel.Hint(rp,HINT_NUMBER,CUNGUI.SVCosts[rp])
		Duel.Hint(1-rp,HINT_NUMBER,CUNGUI.SVCosts[rp])
	else
		needCost = needCost - CUNGUI.SVCosts[rp]
		if needCost > Duel.GetLP(rp) then needCost = Duel.GetLP(rp) end
		CUNGUI.SVCosts[rp] = 0
		OrigPayLPCost(rp,needCost)
		Duel.Hint(rp,HINT_NUMBER,0)
		Duel.Hint(1-rp,HINT_NUMBER,0)
	end
end

CUNGUI.SVEvolutionPoints = {}
CUNGUI.SVEvolutionPoints[0]=2
CUNGUI.SVEvolutionPoints[1]=3

function CUNGUI.EvolutionTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(98765432)==0
		and Duel.GetTurnCount()>3
		and CUNGUI.SVEvolutionPoints[tp]>0 end
	Duel.SetChainLimit(aux.FALSE)
end

function CUNGUI.Evolution(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(98765432,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
	CUNGUI.SVEvolutionPoints[tp] = CUNGUI.SVEvolutionPoints[tp] - 1
	CUNGUI.AddAttack(c,800)
	CUNGUI.AddDefense(c,800)
	if CUNGUI.AttackLimitEffects[c] and CUNGUI.AttackLimitEffects[c]:GetLabel()==Duel.GetTurnCount() then
		CUNGUI.AttackLimitEffects[c]:Reset()
		CUNGUI.AttackLimitEffects[c]=false
		--cannot direct attack
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	Duel.Hint(tp,HINT_NUMBER,CUNGUI.SVEvolutionPoints[tp])
	Duel.Hint(1-tp,HINT_NUMBER,CUNGUI.SVEvolutionPoints[tp])
end

CUNGUI.AttackLimitEffects={}

function CUNGUI.AttackLimit(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetLabel(Duel.GetTurnCount())
	c:RegisterEffect(e1)
	CUNGUI.AttackLimitEffects[c]=e1
end

function CUNGUI.DamageValCondition(e)
	return e:GetHandler():GetBattleTarget()~=nil
end

function CUNGUI.AddDefense(c,num)
	if num==0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(num)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

function CUNGUI.AddAttack(c,num)
	if num==0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(num)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

function CUNGUI.BattleDestroy(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=c:GetBattleTarget()
	if d and Duel.GetAttacker()~=c then return end
	if d then
		CUNGUI.AddDefense(c,-d:GetAttack())
		CUNGUI.AddDefense(d,-c:GetAttack())
	end
	if d and c:GetDefense()<1 then
		Duel.Destroy(c,REASON_BATTLE+REASON_RULE)
	end
	if d and d:GetDefense()<1 then
		Duel.Destroy(d,REASON_BATTLE+REASON_RULE)
	end
end
