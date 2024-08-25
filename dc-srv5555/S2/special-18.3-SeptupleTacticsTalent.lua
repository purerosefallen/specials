--村规决斗：七战之才
--开局时，双方将1张胜利龙（44910027）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--1回合1次，对方这个回合发动过怪兽·魔法·陷阱卡效果的场合，自己主要阶段才能处理这个效果。这个效果的处理不会被无效化。
--从卡组外选【鹰身女郎的羽毛扫】【雷击】【心变】【爱恶作剧的双子恶魔】【强欲之壶】【天使的施舍】【遗言状】中的任意1张加入手卡。

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
function CUNGUI.AdjustOperation()
	if not CUNGUI.INIT then
		CUNGUI.INIT = true
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
	local c=Duel.CreateToken(tp,44910027)
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
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(66666004,ACTIVITY_CHAIN,aux.FALSE)
end
function CUNGUI.rulecond(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetCurrentChain()<1
		and Duel.GetCustomActivityCount(66666004,1-tp,ACTIVITY_CHAIN)~=0
end

function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local list = {18144506,12580477,4031928,44763025,55144522,79571449,85602018}
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local code=Duel.AnnounceCard(tp,18144506,OPCODE_ISCODE,12580477,OPCODE_ISCODE,OPCODE_OR,4031928,
		OPCODE_ISCODE,OPCODE_OR,44763025,OPCODE_ISCODE,OPCODE_OR,55144522,OPCODE_ISCODE,OPCODE_OR,79571449,OPCODE_ISCODE,OPCODE_OR,85602018,OPCODE_ISCODE,OPCODE_OR)
	local tc=Duel.CreateToken(tp,code)
	Duel.SendtoHand(tc,nil,REASON_RULE)
end
