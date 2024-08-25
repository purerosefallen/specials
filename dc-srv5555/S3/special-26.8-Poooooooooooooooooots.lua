--村规决斗：万象之壶
--开局时，双方将1张强欲之壶（55144522）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--1回合1次，自己主要阶段才能处理这个效果。选自己任意数量的手卡（至少1）返回卡组，
--从卡组外把（返回数量*2）张名字中带有【壶】的随机卡加入手卡。
--这个效果的处理不会被无效。

CUNGUI = {}
CUNGUI.RuleCardCode=55144522
CUNGUI.CreateCards={3549275,3900605,4896788,22123627,24137081,33508719,33784505,
34124316,35261759,40736921,49238328,50045299,51790181,55144522,55567161,55763552,
64014615,67169062,67248304,70278545,73414375,76515293,78706415,79106360,81171949,
81492226,84211599,86801871,87614611,91501248,96598015,98645731,98672567,99284890}

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
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(CUNGUI.rulecond)
	e1:SetTarget(CUNGUI.ruletg)
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
end

function CUNGUI.rulecond(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetCurrentChain()<1 and Duel.GetTurnPlayer()==tp
end
function CUNGUI.ruletg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,nil)>0 end
	Duel.Hint(HINT_CARD,1-tp,e:GetHandler():GetCode())
end
function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,99,nil)
	local ct=Duel.SendtoDeck(g,nil,2,REASON_RULE)*2
	local g=Group.CreateGroup()
	for _=1,ct do
		local code=CUNGUI.CreateCards[math.random(1,#CUNGUI.CreateCards)]
		g:AddCard(Duel.CreateToken(tp,code))
	end
	Duel.SendtoHand(g,nil,REASON_RULE)
end
