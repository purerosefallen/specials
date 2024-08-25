--村规决斗：一拳超人
--开局时，双方从卡组外将1张【神拳粉碎】（97570038）表侧表示从游戏中除外。
--这张【神拳粉碎】得到以下效果。
--①这个效果每名玩家在决斗中只能使用1次。这张卡被除外的状态下，自己主要阶段1开始时才能发动。这个效果不会被无效化。
--双方猜拳直到有一方败北。败北的玩家必须把自己场上·手卡·墓地的卡全部里侧表示除外。那之后，回合结束。
--细则：
--由于是带有不确定性的效果，因此王谷在场等情况下仍然可以发动并正常处理。
--由于是对玩家效果所以无视抗性。

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
	if CUNGUI.RuleCard[1] and not CUNGUI.RuleCard[1]:IsLocation(LOCATION_REMOVED) then
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
CUNGUI.ForbiddenEffects={}
CUNGUI.ForbiddenEffects[0]={}
CUNGUI.ForbiddenEffects[1]={}

function CUNGUI.RegisterCardRule(tp)
	local c=Duel.CreateToken(tp,97570038)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	--forbid
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(CUNGUI.rulecond)
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
end

function CUNGUI.rulecond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end

function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local p=1-Duel.RockPaperScissors()
	local g=Duel.GetFieldGroup(p,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0)
	Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end











