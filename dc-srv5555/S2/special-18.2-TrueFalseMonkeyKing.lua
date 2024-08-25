--村规决斗：真假猴王
--开局时，双方将1张高尚仪式术（36350300）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--1回合1次，自己主要阶段才能处理这个效果。这个效果的处理不会被无效化。
--从卡组外将1张有任意卡名记述的随机仪式魔法卡加入手卡，那些记述的卡名各2张从卡组外加入手卡。

CUNGUI = {}
CUNGUI.RandomCard = {7986397,8198712,8955148,9236985,9786492,9845733,11398951,14094090,14735698,16494704,17888577,18803791,20071842,21082832,22398665,23459650,23965037,27383110,28429121,30392583,31002402,31066283,32828635,33031674,34767865,34834619,36350300,37626500,38784726,39399168,39996157,41182875,41426869,43417563,43694075,44221928,45410988,45948430,46052429,46159582,47435107,51124303,52913738,54539105,55761792,58827995,59820352,60234913,60365591,60369732,60921537,62835876,69035382,72446038,73055622,76792184,76806714,77454922,78577570,79306385,80566312,80811661,81756897,81933259,85327820,86758915,94377247,94666032,96420087,97211663}

function Auxiliary.PreloadUds()
	math.random = Duel.GetRandomNumber
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
	local c=Duel.CreateToken(tp,36350300)
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
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetCurrentChain()<1
end

function CUNGUI.CheckCard(c)
	return c.card_code_list ~= nil
end

function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local rand = math.random(#CUNGUI.RandomCard)
	local code = CUNGUI.RandomCard[rand]
	local card = Duel.CreateToken(tp,code)
	while not CUNGUI.CheckCard(card) do
		table.remove(CUNGUI.RandomCard,rand)
		rand = math.random(#CUNGUI.RandomCard)
		code = CUNGUI.RandomCard[rand]
		card = Duel.CreateToken(tp,code)
	end
	Duel.SendtoHand(card,nil,REASON_RULE)
	for lcode,_ in pairs(card.card_code_list) do
		local tc=Duel.CreateToken(tp,lcode)
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		tc=Duel.CreateToken(tp,lcode)
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end

