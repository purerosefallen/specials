--村规决斗：限界突破III
--开局时，按卡组种类在墓地放置一些指定卡片。
--仅当卡组在41张以下，且主卡组·额外卡组中该字段的卡是23张以上的场合生效：
--闪刀：火球*10+效果遮蒙者*5
--海晶少女：海晶少女波动*5
--炎兽：转生炎兽的咆哮*5
--成功加入的场合，再把1张【千里眼】从卡组外放置于除外的卡中。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--可以随时处理这个效果。
--依次查看自己卡组最上方的卡、对方卡组最上方的卡、对方场上的所有卡、对方手卡、对方额外卡组。

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

function CUNGUI.CreateCards(tp,code,num)
	for _=1,num do
		local card = Duel.CreateToken(tp, code)
		Duel.SendtoGrave(card,REASON_RULE)
	end
end

function CUNGUI.RegisterCardRule(tp)

	local g=Duel.GetFieldGroup(tp, LOCATION_DECK+LOCATION_HAND, 0)
	local g2=Duel.GetFieldGroup(tp, LOCATION_EXTRA, 0)
	--闪刀：0x115
	--海晶：0x12b
	--炎兽：0x119

	--大于41张的卡组直接返回
	if #g>41 then return end
	local i115=0
	local i12b=0
	local i119=0

	for tc in aux.Next(g) do
		if tc:IsSetCard(0x115) then i115 = i115 + 1 end
		if tc:IsSetCard(0x12b) then i12b = i12b + 1 end
		if tc:IsSetCard(0x119) then i119 = i119 + 1 end
	end

	for tc in aux.Next(g2) do
		if tc:IsSetCard(0x115) then i115 = i115 + 1 end
		if tc:IsSetCard(0x12b) then i12b = i12b + 1 end
		if tc:IsSetCard(0x119) then i119 = i119 + 1 end
	end

	local b115 = i115 > 22
	local b12b = i12b > 22
	local b119 = i119 > 22

	if b115 then
		CUNGUI.CreateCards(tp, 46130346, 10)
		CUNGUI.CreateCards(tp, 97268402, 5)
	end
	if b12b then
		CUNGUI.CreateCards(tp, 52945066, 5)
	end
	if b119 then
		CUNGUI.CreateCards(tp, 51339637, 5)
	end

	if not (b115 or b12b or b119) then return end

	local c=Duel.CreateToken(tp,60391791)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c


	--show cards
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34694160,0)) --确认卡组
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(CUNGUI.rulecond)
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
	--show cards 2
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21088856,0)) --确认额外卡组
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(CUNGUI.rulecond)
	e1:SetOperation(CUNGUI.ruleop2)
	c:RegisterEffect(e1)
	--show cards 3
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4857085,0)) --确认手牌
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(CUNGUI.rulecond)
	e1:SetOperation(CUNGUI.ruleop3)
	c:RegisterEffect(e1)
	--show cards 4
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(57409948,0)) --确认盖卡
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(CUNGUI.rulecond)
	e1:SetOperation(CUNGUI.ruleop4)
	c:RegisterEffect(e1)
end

function CUNGUI.rulecond(e,tp)
	return e:GetHandler():IsControler(tp)
end

function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp, 1)
	if g and #g>0 then
		Duel.ConfirmCards(tp, g)
	end

	g=Duel.GetDecktopGroup(1-tp, 1)
	if g and #g>0 then
		Duel.ConfirmCards(tp, g)
	end
end
function CUNGUI.ruleop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp, 0, LOCATION_EXTRA)
	if g and #g>0 then
		Duel.ConfirmCards(tp, g)
	end
end
function CUNGUI.ruleop3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp, 0, LOCATION_HAND)
	if g and #g>0 then
		Duel.ConfirmCards(tp, g)
	end
end
function CUNGUI.ruleop4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp, 0, LOCATION_ONFIELD)
	if g and #g>0 then
		Duel.ConfirmCards(tp, g)
	end
end