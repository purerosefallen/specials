--村规决斗：幻神之战
--开局时，双方将1张缚神冢（269012）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--自己结束阶段发动。从卡组外将1张随机5星通常怪兽在自己场上表侧表示放置。
--如果放置的卡是狮子男巫（4392470） 海马兽（47922711） 莫林芬（55784832）
--再给予对方4000点伤害。

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
		math.random = Duel.GetRandomNumber
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
	local c=Duel.CreateToken(tp,269012)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	--forbid
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66666004,4))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
end

CUNGUI.cards={2971090,4035199,4179849,4392470,7562372,10538007,11250655,11714098,12146024,14977074,15023985,16972957,17192817,18246479,19474136,19737320,20624263,26378150,28279543,28546905,29172562,29402771,29616941,30090452,31477025,32012841,32012842,32344688,33178416,33621868,33878931,34690519,35322812,35565537,36904469,38116136,40155554,42418084,42599677,43785278,43793530,44865098,47319141,47922711,48202661,48365709,48766543,49587396,50176820,50407691,51194046,51228280,52584282,54615781,55291359,55784832,55998462,62762898,65518099,66989694,67273917,67284908,67494157,68182934,68339286,69455834,69893315,70345785,73051941,73081602,73911410,74637266,75622825,75850803,76634149,77998771,78060096,78780140,80141480,81386177,81686058,82818645,85326399,85771020,86088138,87511987,90876561,96981563,97612389,98795934}

function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local code=math.random(#CUNGUI.cards)
	local c=Duel.CreateToken(tp,CUNGUI.cards[code])
	if Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true) and (code==4392470 or code==47922711 or code==55784832) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,4000,REASON_EFFECT)
	end
end
