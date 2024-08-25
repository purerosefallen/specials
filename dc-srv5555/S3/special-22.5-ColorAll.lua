--村规决斗：层林尽染
--双方的所有卡（包括通常怪兽）得到对方某一张随机卡的效果。
--额外卡组的卡只会得到额外卡组的卡的效果，主卡组的卡只会得到主卡组的卡的效果。
--怪兽只会得到怪兽的效果，场地只会得到场地的效果，
--其他魔法只会得到非场地魔法的效果，陷阱只会得到陷阱的效果。

--开局时，双方将1张千里眼（60391791）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--1回合最多2次，自己主要阶段才能处理这个效果。这个效果的处理不会被无效。
--查看自己场上·手卡·墓地·额外·除外的1张卡复制了哪张卡的效果。

CUNGUI={}

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation2)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.AdjustOperation2()
	if not CUNGUI.INIT2 then
		CUNGUI.INIT2 = true
		CUNGUI.RegisterCardRule(0)
		CUNGUI.RegisterCardRule(1)
	end
	if CUNGUI.RuleCard[0] and (not CUNGUI.RuleCard[0]:IsLocation(LOCATION_REMOVED) or not CUNGUI.RuleCard[0]:IsFaceup()) then
		Duel.Remove(CUNGUI.RuleCard[0],POS_FACEUP,REASON_RULE)
	end
	if CUNGUI.RuleCard[1] and (not CUNGUI.RuleCard[1]:IsLocation(LOCATION_REMOVED) or not CUNGUI.RuleCard[1]:IsFaceup()) then
		Duel.Remove(CUNGUI.RuleCard[1],POS_FACEUP,REASON_RULE)
	end
	if CUNGUI.RuleCard[0] and not CUNGUI.RuleCard[0]:IsFaceup() then
		Duel.ChangePosition(CUNGUI.RuleCard[0],POS_FACEUP)
	end
	if CUNGUI.RuleCard[1] and not CUNGUI.RuleCard[1]:IsFaceup() then
		Duel.ChangePosition(CUNGUI.RuleCard[1],POS_FACEUP)
	end
end

CUNGUI.RuleCard={}

function CUNGUI.RegisterCardRule(tp)
	local c=Duel.CreateToken(tp,60391791)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	--forbid
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66666004,4))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(CUNGUI.rulecond)
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
end

function CUNGUI.rulecond(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetCurrentChain()<1
end

function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g and #g>0 then
		local tc=g:GetFirst()
		Duel.Hint(HINT_CODE,1-tp,CUNGUI.RegCard[tc] or 0)
	end
end

CUNGUI.RegisteredMonsters = Group.CreateGroup()

local CRegisterEffect=Card.RegisterEffect
Card.RegisterEffect = function(c,e,forced)
	if not e:GetDescription() or e:GetDescription()==0 then
		e:SetDescription(aux.Stringid(66666004,4))
	end
	return CRegisterEffect(c,e,forced)
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	if not CUNGUI.INIT then
		CUNGUI.INIT = true
		math.random = Duel.GetRandomNumber
	end
	local g = Duel.GetMatchingGroup(nil,0,0x7f,0x7f,nil)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	local g=Duel.GetMatchingGroup(CUNGUI.filter,c:GetControler(),0,0x7f,nil,c)
	local t={}
	local i=1
	for tc in aux.Next(g) do
		t[i]=tc
		i=i+1
	end
	if #t<1 then return end
	CUNGUI.RegisterCard(c,t[math.random(1,#t)])
end

function CUNGUI.filter(c,oc)
	if not oc:IsExtraDeckMonster() == c:IsExtraDeckMonster() then return false end
	if oc:IsType(TYPE_MONSTER) then return c:IsType(TYPE_MONSTER) end
	if oc:IsType(TYPE_FIELD) then return c:IsType(TYPE_FIELD) end
	if oc:IsType(TYPE_SPELL) then return c:IsType(TYPE_SPELL) end
	if oc:IsType(TYPE_TRAP) then return c:IsType(TYPE_TRAP) end
end

CUNGUI.RegCard={}

function CUNGUI.RegisterCard(c,tc)
	local tce=_G["c"..tc:GetOriginalCode()]
	if tce and tce.initial_effect then
		CUNGUI.RegCard[c]=tc:GetOriginalCode()
		tce.initial_effect(c)
	end
end

function CUNGUI.spfilter(c,e,tp)
	return c:IsCode(e:GetHandler():GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP_ATTACK)
end

function CUNGUI.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(CUNGUI.spfilter,tp,0x33,0,c,e,tp)
	local f=Duel.GetMZoneCount(tp)
	if #g>0 and f>0 then
		local max = #g
		if max > f then max = f end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(g,tp,max,max,nil)
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP_ATTACK)
	end
end