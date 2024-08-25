--村规决斗：娱乐决斗
--开局时，双方的基本分变为100。这场决斗中，双方受到的伤害变为0，失去·改变基本分的动作不进行。
--这场决斗中，在第7个回合之前，即使基本分为0也不会决斗败北；
--在第7个回合开始后，基本分较少的一方会开始受到伤害。
--进行某些动作时，基本分作出相应变更。

--怪兽的攻击宣言：同一回合的攻击次数越多，那次攻击的加分越多：+1 +2 +4 +8 +16 +32 +32 +32……
--召唤怪兽：同一回合的召唤次数越多加分越多：+1 +3 +9 +9 +9……
--特殊召唤：同一回合的特殊召唤次数，增益递减：+3 +2 +1 +0 -1 -2 -3 -4……
--即将造成效果伤害：每次+1，每有200点额外+1。
--即将回复生命：那个效果回复的生命值变为原来的百分之一，向上取整。
--支付和失去生命：生命值不变化。
--自己场上的卡数量增加：增加数量越多，加分越多：+0 +2 +4 +8 +16 +32 +32 +32……
--对方场上的卡数量减少：减少数量越多，加分越多：+0 +1 +2 +4 +8 +16 +32 +32 +32……

--决斗开始时，每位玩家将1张【笑容世界】从卡组外从游戏中除外，这张卡在收到观战者的打赏/指指点点的场合才能发动，其发动和效果不能被无效化。
--观战者可以在主要阶段宣言对回合玩家进行打赏（+10基本分）。每位观战者在1场决斗中只能对1名决斗者打赏，每场决斗中每位观众的打赏只能进行1次。
--观战者可以在主要阶段宣言对回合玩家进行指指点点（-10基本分）。每位观战者在1场决斗中只能对1名决斗者指指点点，每场决斗中每位观众的指指点点只能进行1次。

Duel.CheckLPCost = function(player,cost) return true end
Duel.PayLPCost = function(player,cost) end

local OrigDuelSetLP = Duel.SetLP
Duel.SetLP = function(player,lp) end

local RuleRecover = function(tp,lp)
	OrigDuelSetLP(tp,Duel.GetLP(tp)+lp)
end

local OrigDuelRecover = Duel.Recover
Duel.Recover = function(player,value,reason,is_step)
	value = math.ceil(value / 100)
	RuleRecover(player,value)
end

local OrigDuelDamage = Duel.Damage
Duel.Damage = function(player,value,reason,is_step)
	if value>0 then
		value=1+math.floor(value/200)
		RuleRecover(1-player,value)
	end
end

CUNGUI = {}
CUNGUI.RuleCard = {}

function CUNGUI.CreateSmileWorld(tp)
	local c=Duel.CreateToken(tp,2099841)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	--add
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(545781,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetOperation(CUNGUI.smileop)
	c:RegisterEffect(e1)
	--minus
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(545781,1))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetOperation(CUNGUI.smileop2)
	c:RegisterEffect(e1)
end

function CUNGUI.smileop(e,tp,eg,ep,ev,re,r,rp)
	RuleRecover(tp,10)
end

function CUNGUI.smileop2(e,tp,eg,ep,ev,re,r,rp)
	RuleRecover(tp,-10)
end

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AdjustOperationOncePerTurn)
	Duel.RegisterEffect(e1,0)
	--adjust
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(CUNGUI.val)
	Duel.RegisterEffect(e1,0)
	e1=e1:Clone()
	Duel.RegisterEffect(e1,1)
end
function CUNGUI.val(e,re,val,r,rp,rc)
	if Duel.GetTurnCount()<7 then
		return 0
	end
	local tp = e:GetHandlerPlayer()
	if Duel.GetLP(tp)<Duel.GetLP(1-tp) then
		return val
	end
	return 0
end
CUNGUI.FieldCount={}
CUNGUI.FieldCount[0]=0
CUNGUI.FieldCount[1]=0
CUNGUI.SummonCount={}
CUNGUI.SummonCount[0]=0
CUNGUI.SummonCount[1]=0
CUNGUI.SPSummonCount={}
CUNGUI.SPSummonCount[0]=0
CUNGUI.SPSummonCount[1]=0
CUNGUI.AttackCount={}
CUNGUI.AttackCount[0]=0
CUNGUI.AttackCount[1]=0

function CUNGUI.AdjustOperationOncePerTurn(e,tp,eg,ep,ev,re,r,rp)
	CUNGUI.SummonCount[0]=0
	CUNGUI.SummonCount[1]=0
	CUNGUI.SPSummonCount[0]=0
	CUNGUI.SPSummonCount[1]=0
	CUNGUI.AttackCount[0]=0
	CUNGUI.AttackCount[1]=0
end

function CUNGUI.cond()
	return Duel.GetTurnCount()<7
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	if not CUNGUI.Init then
		CUNGUI.Init = true
		for i=0,1 do
			CUNGUI.CreateSmileWorld(i)
		end
		local e0 = Effect.GlobalEffect()
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
		e0:SetTargetRange(1,1)
		e0:SetCondition(CUNGUI.cond)
		Duel.RegisterEffect(e0,0)
		OrigDuelSetLP(0,100)
		OrigDuelSetLP(1,100)
	end
	for i=0,1 do
		if CUNGUI.RuleCard[tp] and not (CUNGUI.RuleCard[tp]:IsLocation(LOCATION_REMOVED)) then
			Duel.Remove(CUNGUI.RuleCard[tp],POS_FACEUP,REASON_RULE)
		end
		local scount = Duel.GetActivityCount(i,ACTIVITY_NORMALSUMMON)
		if scount > CUNGUI.SummonCount[i] then
			CUNGUI.SummonCount[i]=scount
			local lp=3^(scount-1)
			if lp > 9 then lp = 9 end
			RuleRecover(i,lp)
		end
		local spcount = Duel.GetActivityCount(i,ACTIVITY_SPSUMMON)
		if spcount > CUNGUI.SPSummonCount[i] then
			CUNGUI.SPSummonCount[i]=spcount
			local lp=4-spcount
			RuleRecover(i,lp)
		end
		local atkcount = Duel.GetActivityCount(i,ACTIVITY_ATTACK)
		if atkcount > CUNGUI.AttackCount[i] then
			CUNGUI.AttackCount[i]=atkcount
			local lp=2^(atkcount-1)
			if lp > 32 then lp = 32 end
			RuleRecover(i,lp)
		end
		local fcount = Duel.GetFieldGroupCount(i,LOCATION_ONFIELD,0)
		if fcount < CUNGUI.FieldCount[i] then
			local diff=CUNGUI.FieldCount[i]-fcount
			CUNGUI.FieldCount[i]=fcount
			if diff > 1 then
				local lp=2^(diff-2)
				if lp > 32 then lp = 32 end
				RuleRecover(1-i,lp)
			end
		elseif fcount > CUNGUI.FieldCount[i] then
			local diff=fcount-CUNGUI.FieldCount[i]
			CUNGUI.FieldCount[i]=fcount
			if diff > 1 then
				local lp=2^(diff-1)
				if lp > 32 then lp = 32 end
				RuleRecover(i,lp)
			end
		end
	end
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3431737,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(CUNGUI.cost)
	e1:SetProperty(EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(CUNGUI.operation)
	c:RegisterEffect(e1)
end
function CUNGUI.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c, POS_FACEDOWN,REASON_COST)
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=math.random(#CUNGUI.forbidden)
	local tc=Duel.CreateToken(tp,code)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
