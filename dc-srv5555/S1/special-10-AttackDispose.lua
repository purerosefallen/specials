--村规决斗：进攻部署
--所有怪兽得到以下效果：
--这张卡进行攻击的伤害计算时才能发动。这个效果的发动和效果不会被无效化。
--从卡组选1只与这张卡种族或属性相同的怪兽里侧攻击表示特殊召唤。

--细则：
--自己卡组没有条件合适的怪兽的场合，即使对方能选，也不能发动。
--任意一方场上没有空位则不能发动。
--因为是伤判所以不会攻击卷回。
--里侧攻击表示的调整参见旧版暗之拜访。
CUNGUI = {}

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
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetDescription(aux.Stringid(41546,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(CUNGUI.condition)
	e1:SetTarget(CUNGUI.target)
	e1:SetOperation(CUNGUI.activate)
	c:RegisterEffect(e1)
end

function CUNGUI.condition(e,tp)
	return Duel.GetAttacker() == e:GetHandler()
end

function CUNGUI.filter(c,e,tp)
	local tc = e:GetHandler()
	return (c:IsRace(tc:GetRace()) or c:IsAttribute(tc:GetAttribute())) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function CUNGUI.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function CUNGUI.activate(e,tp,eg,ep,ev,re,r,rp)
	local success = false
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,CUNGUI.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then success = Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_ATTACK) end
	end
end
