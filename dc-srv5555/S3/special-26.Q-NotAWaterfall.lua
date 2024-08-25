--村规决斗：细水长流
--开局时，双方从卡组选1张魔法·陷阱卡，从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果：
--1回合1次，自己·对方回合才能发动。
--这个效果的发动和效果不能被无效化。
--处理这张卡原本发动时的效果（无需Cost）。

CUNGUI = {}
CUNGUI.RuleCard={}

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
		local fc=Duel.SelectMatchingCard(0,Card.IsType,0,LOCATION_DECK,0,1,1,nil,TYPE_SPELL+TYPE_TRAP):GetFirst()
		local sc=Duel.SelectMatchingCard(1,Card.IsType,1,LOCATION_DECK,0,1,1,nil,TYPE_SPELL+TYPE_TRAP):GetFirst()
		CUNGUI.RegisterCardRule(0,fc)
		CUNGUI.RegisterCardRule(1,sc)
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


function CUNGUI.RegisterCardRule(tp,c)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	--forbid
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66666004,4))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.targ)
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
end

function CUNGUI.targ(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=e:GetHandler():GetActivateEffect()
	if not te then return false end
	local target = te:GetTarget()
	if target then return target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	return true
end

function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetHandler():GetActivateEffect()
	if not te then return end
	local operation = te:GetOperation()
	if operation then return operation(e,tp,eg,ep,ev,re,r,rp) end
end
