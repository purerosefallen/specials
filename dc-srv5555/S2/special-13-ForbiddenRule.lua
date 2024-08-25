--村规决斗：禁忌法则
--所有卡得到以下效果：
--这个效果的发动和效果不会被无效化。
--把这张卡从手卡里侧表示除外才能发动。从卡组外将1张随机禁卡加入手卡或额外卡组。
--这个效果加入手卡的卡，在那个回合不能把此类效果发动（即使发生过位置移动）。
--细则：
--采用2022年4月禁卡表。
--加入的卡不需要给对方确认。
CUNGUI = {}
CUNGUI.forbidden={91869203,20663556,44910027,51858306,7563579,17330916,34945480,90411554,8903700,
11384280,17412721,50588353,34124316,2563463,88071625,61665245,52653092,48905153,85115440,59537380,
86148577,88581108,21377582,27381364,94677445,16923472,15341821,37818794,92731385,79875176,75732622,
22593417,39064822,3679218,54719828,58820923,26400609,71525232,78706415,93369354,23558733,9929398,
70369116,31178212,63101919,34206604,4423206,14702066,96782886,90809975,83152482,34086406,85243784,
73356503,57421866,41482598,44763025,17375316,19613556,74191942,42829885,45986603,55144522,23557835,
31423101,57953380,54447022,60682203,69243953,79571449,70828912,42703248,76375976,34906152,46411259,
85602018,27174286,5851097,93016201,61740673,3280747,64697231,80604091,32723153,17178486,28566710}

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
end
function CUNGUI.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c, POS_FACEDOWN,REASON_COST)
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local add=0
	math.random = Duel.GetRandomNumber or math.random
	while add==0 do
		local code=math.random(#CUNGUI.forbidden)
		local tc=Duel.CreateToken(tp,CUNGUI.forbidden[code])
		if tc then
			add = Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
