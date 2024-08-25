--村规决斗：你忍一下 EX
--所有怪兽得到以下效果，这些效果不会被无效化：
--这张卡当作4星使用。
--这张卡的攻击力变成原本的1/100（向上取整）。
--直接攻击成功时，对方失去这张卡原本攻击力2倍的基本分。
CUNGUI = {}
local cgl = Card.GetLevel
Card.GetLevel = function(c) return (not c:IsLocation(LOCATION_HAND+LOCATION_MZONE)) and cgl(c) or 4 end
local cila = Card.IsLevelAbove
Card.IsLevelAbove = function(c,lv) return (not c:IsLocation(LOCATION_HAND+LOCATION_MZONE)) and cila(c) or lv<=4 end
local cilb = Card.IsLevelBelow
Card.IsLevelAbove = function(c,lv) return (not c:IsLocation(LOCATION_HAND+LOCATION_MZONE)) and cilb(c) or lv>=4 end
local cil = Card.IsLevel
Card.IsLevel = function(c,...)
	if not c:IsLocation(LOCATION_HAND+LOCATION_MZONE) then return cil(c,...) end
	for _,lv in ipairs{...} do
		if lv==4 then return true end
	end
	return false
end

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
	if not CUNGUI.init then
		CUNGUI.init = true
		--level
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
		e2:SetTarget(aux.TRUE)
		e2:SetValue(4)
		Duel.RegisterEffect(e2,0)
	end
end

CUNGUI.RegisteredMonsters = Group.CreateGroup()

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(math.floor(c:GetBaseAttack() / 100.0 + 0.5))
	c:RegisterEffect(e1)
	--defense
	e1=e1:Clone()
	e1:SetCode(EFFECT_SET_DEFENSE)
	e1:SetValue(math.floor(c:GetBaseDefense() / 100.0 + 0.5))
	c:RegisterEffect(e1)
	--deal more battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56052205,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetCondition(CUNGUI.condition)
	e2:SetOperation(CUNGUI.operation)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetRange(0xaf)
	e3:SetValue(4)
	c:RegisterEffect(e3)
end
function CUNGUI.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp)
	local lp = Duel.GetLP(1-tp) - e:GetHandler():GetBaseAttack() * 2
	if lp < 0 then lp = 0 end
	Duel.SetLP(1-tp, lp)
end
