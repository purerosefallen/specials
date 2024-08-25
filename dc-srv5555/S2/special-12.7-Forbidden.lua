--村规决斗：令行禁止
--开局时，双方从卡组外将1张【禁止令】表侧表示从游戏中除外。
--这张【禁止令】得到以下效果。
--①此类效果1回合只能使用1次，这张卡被除外的状态下才能发动，发动和效果不会被无效化。
--宣言1个【禁止令】以外的卡名，在这场决斗中，对方的那些卡受到禁止令效果影响。
--②此类效果1回合只能使用1次，这张卡被除外的状态下才能发动，发动和效果不会被无效化。
--这张卡撕碎（效果名：卡片破坏），解除自己目前受到的所有因此类①效果的禁止令效果。
--③这张卡不是表侧表示除外状态的场合，这张卡表侧表示除外。这个效果不会被无效化，在卡组·手卡也会适用。

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
		CUNGUI.RegisterForbiddenRule(0)
		CUNGUI.RegisterForbiddenRule(1)
	end
	if CUNGUI.RuleCard[0] and (not CUNGUI.RuleCard[0]:IsLocation(LOCATION_REMOVED) or not CUNGUI.RuleCard[0]:IsFaceup()) then
		Duel.Remove(CUNGUI.RuleCard[0],POS_FACEUP,REASON_RULE)
	end
	if CUNGUI.RuleCard[1] and not CUNGUI.RuleCard[1]:IsLocation(LOCATION_REMOVED) then
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
CUNGUI.ForbiddenEffects={}
CUNGUI.ForbiddenEffects[0]={}
CUNGUI.ForbiddenEffects[1]={}

function CUNGUI.RegisterForbiddenRule(tp)
	local c=Duel.CreateToken(tp,43711255)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	--forbid
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29417188,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,34567890)
	e1:SetProperty(EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetOperation(CUNGUI.forbidop)
	c:RegisterEffect(e1)
	--unforbid
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(276357,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,23456789)
	e2:SetProperty(EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetOperation(CUNGUI.operation2)
	c:RegisterEffect(e2)
end

function CUNGUI.operation2(e,tp,eg,ep,ev,re,r,rp)
	for _,v in pairs(CUNGUI.ForbiddenEffects[tp]) do
		v:Reset()
	end
	CUNGUI.RuleCard[tp]=nil
	Duel.Exile(e:GetHandler(),REASON_RULE)
end

function CUNGUI.forbidop(e,tp,eg,ep,ev,re,r,rp)
	local code=43711255
	while code==43711255 do
		code=Duel.AnnounceCard(tp)
	end
	--forbidden
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_FORBIDDEN)
	e2:SetTargetRange(0x7f,0)
	e2:SetTarget(CUNGUI.bantg)
	e2:SetLabel(code)
	Duel.RegisterEffect(e2,1-tp)
	table.insert(CUNGUI.ForbiddenEffects[1-tp],e2)
end
function CUNGUI.bantg(e,c)
	local code1,code2=c:GetOriginalCodeRule()
	local fcode=e:GetLabel()
	return code1==fcode or code2==fcode
end
