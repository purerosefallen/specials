--村规决斗：激斗陀螺
--在战斗阶段以外，双方进行的任何行动，都会让全场表侧表示怪兽的表示形式改变。
--全场的怪兽能以守备表示进行攻击宣言（仍用攻击力进行计算）。
--这个效果不会被无效化。

CUNGUI={}

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
	--adjust
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetCountLimit(1)
	e3:SetOperation(CUNGUI.AdjustOperation2)
	Duel.RegisterEffect(e3,0)
end
function CUNGUI.AdjustOperation(e)
	if Duel.GetCurrentPhase() > PHASE_MAIN1 and Duel.GetCurrentPhase() < PHASE_MAIN2 then return end
	local g=Duel.GetFieldGroup(0,LOCATION_MZONE,LOCATION_MZONE)
	for tc in aux.Next(g) do
		if tc:IsFaceup() then
			if tc:IsPosition(POS_FACEUP_ATTACK) then
				Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
			else
				Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
			end
		end
	end
end
CUNGUI.RegisteredMonsters = Group.CreateGroup()

function CUNGUI.AdjustOperation2(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(Card.IsType,0,0x7f,0x7f,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	c:RegisterEffect(e2)
end
