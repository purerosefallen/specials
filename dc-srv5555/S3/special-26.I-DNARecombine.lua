--村规决斗：基因重组
--开局时，双方将1张DNA改造手术（74701381）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--1回合1次，自己·对方回合发动。这个效果的发动和效果不会被无效化，双方不能针对这个效果把效果发动。
--随机选自己场上1张卡返回卡组·额外卡组，
--从双方卡组·额外卡组随机取类型相同的1张卡上场。
--如果特殊召唤的卡是XYZ怪兽，则从卡组外将2张【礼品卡】（39526584）当作叠光素材在那些卡下面叠放。

--细则：主要区域的怪兽->卡组的怪兽，或额外卡组的非表侧灵摆·非连接怪兽
--额外区域的怪兽->额外卡组的怪兽
--永续魔法->永续魔法，永续陷阱->永续陷阱，场地->场地
--里侧离场则里侧特殊召唤/盖放，表侧离场则表侧特殊召唤/表侧放置。
--类型在离场时判定。如离场后发生改变（比如二重或陷阱怪兽、装备怪兽）导致没有合适的卡返场，则不返场。
--表侧表示的装备卡估计会在无意义返场后直接送墓。
--2速的自由时点效果，但如果始终未处理，则在结束阶段必须处理。

CUNGUI = {}
CUNGUI.RuleCardCode=74701381

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end
function CUNGUI.AdjustOperation()
	math.random = Duel.GetRandomNumber or math.random
	if not CUNGUI.RuleCardInit then
		CUNGUI.RuleCardInit = true
		CUNGUI.RegisterCardRule(0)
		CUNGUI.RegisterCardRule(1)
	end
	if not CUNGUI.DrawInit then
		CUNGUI.DrawInit = true
		--Duel.Draw(1,1,REASON_RULE)
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
	local c=Duel.CreateToken(tp,CUNGUI.RuleCardCode)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	--forbid
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66666004,4))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,87654321)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(CUNGUI.rulecond)
	e1:SetTarget(CUNGUI.ruletg)
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCondition(aux.TRUE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function CUNGUI.rulecond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_END or Duel.GetCurrentChain()>0
end
function CUNGUI.ruletg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	if #g==0 then return end
	g=g:RandomSelect(tp,1)
	local c=g:GetFirst()
	local from=LOCATION_DECK
	local to=c:GetLocation()
	local stype=c:GetType()
	local pos=c:GetPosition()
	local seq=c:GetSequence()
	local zone=math.pow(2,seq)
	if c:IsLocation(LOCATION_SZONE) then
		zone=(zone<<8)
	end
	if c:IsType(TYPE_MONSTER) then
		if c:GetSequence()>=5 then
			from=LOCATION_EXTRA
			stype=TYPE_MONSTER
		else
			from=LOCATION_DECK+LOCATION_EXTRA
		end
	end
	Duel.SendtoDeck(c,nil,2,REASON_RULE)
	g=Duel.GetMatchingGroup(function(tc) return tc:IsType(stype) end,tp,from,from,nil)
	if #g==0 then return end
	c=g:GetFirst()
	if stype==TYPE_MONSTER then
		if c:IsType(TYPE_LINK) then pos=POS_FACEUP_ATTACK end
		Duel.SpecialSummonStep(c,0,tp,tp,true,true,pos,zone)
		if c:IsType(TYPE_XYZ) then
			CUNGUI.AddOverlay(c)
		end
		c:CompleteProcedure()
		Duel.SpecialSummonComplete()
	else
		if (pos & POS_FACEUP)>0 then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,pos,true)
		else
			Duel.SSet(tp,c,tp,false)
		end
		Duel.MoveSequence(c,seq)
	end
end
function CUNGUI.AddOverlay(c)
	if not c:IsLocation(LOCATION_MZONE) then return end
	local g=Group.CreateGroup()
	for i=1,2 do
		local tc = Duel.CreateToken(c:GetControler(), 39526584)
		g:AddCard(tc)
	end
	if Duel.SendtoHand(g, c:GetControler(), REASON_RULE)~=2 then return end
	Duel.Overlay(c,g)
end
