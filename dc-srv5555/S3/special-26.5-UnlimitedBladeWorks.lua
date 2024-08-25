--村规决斗：无限剑制
--开局时，双方将1张执念之剑（98495314）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--主要阶段才能处理这个效果。从卡组外把1张【执念之剑】（98495314）加入手卡。这个效果不会被无效化。
--（没有次数限制）

CUNGUI = {}
CUNGUI.RuleCardCode=3285551

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
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(CUNGUI.rulecond)
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
end

function CUNGUI.rulecond(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetCurrentChain()<1 and Duel.GetTurnPlayer()==tp
end

function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.CreateToken(tp, 98495314)
	Duel.SendtoHand(tc, tp, REASON_EFFECT)
end
