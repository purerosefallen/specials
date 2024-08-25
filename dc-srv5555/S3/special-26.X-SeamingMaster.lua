--村规决斗：缝合大师
--开局时，双方将1张融合（24094653）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--1回合1次，自己主要阶段才能处理这个效果。
--把手卡中2张以上的怪兽送去墓地。可以把额外卡组中最多1只怪兽送去墓地。
--把1只【三眼小男巫】从卡组外特殊召唤到场上（视为正规召唤）。
--这个效果特殊召唤的【三眼小男巫】得到那些怪兽的全部效果；原本攻击力·防御力是那些怪兽攻防的平均值。
--这些效果和攻防数值即使离场后也会持续。
--另外，额外选的卡是超量怪兽卡的场合，把那些素材作为超量素材叠放。

CUNGUI = {}
CUNGUI.RuleCardCode=24094653

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
		and Duel.IsExistingMatchingCard(Card.IsType, tp, LOCATION_HAND, 0, 2, nil, TYPE_MONSTER)
end
function CUNGUI.ruletg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,1-tp,e:GetHandler():GetCode())
end
function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,2,99,nil,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_EXTRA,0,0,1,nil,TYPE_MONSTER)
	if #g==0 then return end
	g:Merge(g2)
	local atk=0
	local def=0
	for gc in aux.Next(g) do
		atk = atk + gc:GetAttack()
		def = def + (gc:GetDefense() or 0)
	end
	atk = atk / #g
	def = def / #g
	Duel.SendtoGrave(g,REASON_RULE)
	
	local tc=Duel.CreateToken(tp,53539634)
	for c in aux.Next(g) do
		local tce=_G["c"..c:GetOriginalCode()]
		if tce and tce.initial_effect then
			tce.initial_effect(tc)
		end
	end
	if Duel.SpecialSummon(tc, 0, tp, tp, 0, 0, POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
		e1=e1:Clone()
		e1:SetCode(EFFECT_SET_BASE_DEFENSE)
		e1:SetValue(def)
		tc:RegisterEffect(e1)
		
		if #g2>0 and g2:GetFirst():IsType(TYPE_XYZ) then
			--add type
			e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
			e1:SetValue(TYPE_XYZ)
			tc:RegisterEffect(e1)
			Duel.Overlay(tc,g)
		end
		tc:CompleteProcedure()
	end
end

