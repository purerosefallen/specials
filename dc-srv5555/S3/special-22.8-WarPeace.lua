--村规决斗：战争和平
--开局时，双方将1张灰篮撞击（2759860）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--这张卡的①②效果1回合只能有1次使用其中任意1个。
--①：1回合1次，自己主要阶段才能处理这个效果。选自己场上和对方场上1张卡破坏。
--②：1回合1次，自己结束阶段才能处理这个效果。从卡组选1张卡加入手卡。
--这些效果的处理不会被无效，且不受【不能加入手卡】类效果的影响。

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
	local c=Duel.CreateToken(tp,2759860)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	--forbid
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66666004,4))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66666666)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(CUNGUI.rulecond)
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
	--get
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66666004,4))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1,66666666)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
end

function CUNGUI.rulecond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()<1 and
		(((Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
			and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)*Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)>0)
			or (Duel.GetCurrentPhase()==PHASE_END and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0))
end

function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_END then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_RULE)
	else
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
		local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		g:Merge(g2)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

