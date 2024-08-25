--村规决斗：斗牌传说
--开局时，双方将1张打赌胜负（34236961）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--1回合1次，自己主要阶段才能处理这个效果。这个效果的处理不会被无效。
--宣言【星数·攻击·守备·卡号（关键字）】中的1个，双方各自选1张手卡展示。
--宣言的值较高的一方将选出的卡放回手卡，较低的一方受到1000点伤害，将选出的卡送去墓地。
--平局则双方都放回手卡。
--选择怪兽卡以外的卡时，星数·攻击·守备计为0。

CUNGUI = {}
CUNGUI.RuleCardCode=34236961

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
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
end

function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0) then return end
	local opt = Duel.SelectOption(tp,1322,1323,1324,1325)
	local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local ec=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local ti=tc:GetOriginalCode()
	local ei=ec:GetOriginalCode()
    if opt == 0 then
    	ti=(tc:IsType(TYPE_MONSTER) and tc:GetBaseAttack()) or 0
    	ei=(ec:IsType(TYPE_MONSTER) and ec:GetBaseAttack()) or 0
    elseif opt == 1 then
    	ti=(tc:IsType(TYPE_MONSTER) and tc:GetBaseDefense()) or 0
    	ei=(ec:IsType(TYPE_MONSTER) and ec:GetBaseDefense()) or 0
    elseif opt == 2 then
    	ti=(tc:IsType(TYPE_MONSTER) and tc:GetOriginalLevel()) or 0
    	ei=(ec:IsType(TYPE_MONSTER) and ec:GetOriginalLevel()) or 0
    end
    Duel.ConfirmCards(1-tp,tc)
    Duel.ConfirmCards(tp,ec)
    if ti==ei then return end
    if ti>ei then
    	Duel.SendtoGrave(ec,REASON_EFFECT)
    	Duel.Damage(1-tp,1000,REASON_EFFECT)
    else
    	Duel.SendtoGrave(tc,REASON_EFFECT)
    	Duel.Damage(tp,1000,REASON_EFFECT)
    end
end
