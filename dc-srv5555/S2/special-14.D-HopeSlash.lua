--村规决斗：希望剑斩

--所有卡得到以下效果：
--这个效果的发动和效果不会被无效化。
--把这张卡从手卡里侧表示除外才能发动。从卡组外将2张有装备效果，
--且能加入手卡的随机「异热同心武器」卡加入手卡。
--这个效果加入手卡的卡，在那个回合不能把此类效果发动（即使发生过位置移动）。
--加入的卡不需要给对方确认。

--所有怪兽得到以下效果：
--这张卡的卡名在场上·墓地也当作【混沌No.39希望皇 霍普雷】使用。这个效果不会被无效化。

CUNGUI = {}
CUNGUI.ZexalWeapons={2648201,6330307,12927849,18865703,29353756,32164201,
32281491,40941889,45082499,76080032,81471108,87008374,95886782}

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end

CUNGUI.RegisteredMonsters = Group.CreateGroup()

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(nil,0,0x7f,0x7f,nil)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66666004,4))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(CUNGUI.cost)
	e1:SetProperty(EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(CUNGUI.operation)
	c:RegisterEffect(e1)
	if c:IsType(TYPE_MONSTER) then
		Auxiliary.AddCodeList(c,56840427)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
		e2:SetValue(56840427)
		c:RegisterEffect(e2)
	end
end
function CUNGUI.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEDOWN,REASON_COST)
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local add=0
	math.random = Duel.GetRandomNumber or math.random
	while add<2 do
		local code=math.random(#CUNGUI.ZexalWeapons)
		local tc=Duel.CreateToken(tp,CUNGUI.ZexalWeapons[code])
		if tc then
			add = add + Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
