--村规决斗：对等召唤
--开局时，双方将1张暗黑神殿 扎拉拉姆（64230128）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--1回合1次，自己主要阶段才能处理这个效果。
--从双方卡组·额外卡组选2张卡。那之中随机1张在自己场上无视召唤条件特殊召唤，另1张在对方场上无视召唤条件特殊召唤。
--这个特殊召唤当作正规召唤使用。
--如果特殊召唤的卡是XYZ怪兽，则从卡组外将2张【礼品卡】（39526584）当作叠光素材在那些卡下面叠放。

--细则：
--从对方卡组·额外卡组几乎是盲选……额外表侧表示的灵摆卡另说。
--各自决定表示形式（表侧攻击·里侧攻击·表侧守备·里侧守备）。
--如果选择了守备表示，则连接怪兽会召唤失败。

CUNGUI = {}
CUNGUI.RuleCardCode=64230128

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
		CUNGUI.PosCard=Duel.CreateToken(tp, 39526584)
	end
	if not CUNGUI.DrawInit then
		CUNGUI.DrawInit = true
		Duel.Draw(1,1,REASON_RULE)
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
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
end

function CUNGUI.rulecond(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetCurrentChain()<1 and Duel.GetTurnPlayer()==tp
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

function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local g
	local opt = Duel.SelectOption(tp,102,103)
	if opt==0 then
		g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK+LOCATION_EXTRA,0,2,2,nil,TYPE_MONSTER)
	else
		g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_DECK+LOCATION_EXTRA,2,2,nil,TYPE_MONSTER)
	end
	if g and #g==2 then
		local tc=g:RandomSelect(tp,1):GetFirst()
		g:RemoveCard(tc)
		local fc=g:GetFirst()
		local pos = Duel.SelectPosition(tp, CUNGUI.PosCard, POS_FACEDOWN+POS_FACEUP)
		local tcb = Duel.SpecialSummonStep(tc,0,tp,tp,true,true,pos)
		pos = Duel.SelectPosition(1-tp, CUNGUI.PosCard, POS_FACEDOWN+POS_FACEUP)
		local fcb = Duel.SpecialSummonStep(fc,0,tp,1-tp,true,true,pos)
		tc:CompleteProcedure()
		fc:CompleteProcedure()
		if tcb and tc:IsType(TYPE_XYZ) then
			CUNGUI.AddOverlay(tc)
		end
		if fcb and fc:IsType(TYPE_XYZ) then
			CUNGUI.AddOverlay(fc)
		end
		Duel.SpecialSummonComplete()
	end
end
