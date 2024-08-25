--村规决斗：天地创造
--开局时，双方将3张【贤者之石-萨巴希尔】（80831721）从卡组外表侧表示除外。
--这场决斗中这些卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这些卡得到以下效果。
--这个效果的发动和效果不会被无效化。
--宣言1个【贤者之石-萨巴希尔】以外的卡名才能发动。
--这张卡撕碎，那个卡名的卡从卡组外加入手卡·额外卡组。
--这场决斗中，因这个效果加入的卡造成的效果伤害变为0。
--（即使发生过位置移动，也视为同一张卡）

CUNGUI = {}
local OrigAnnounceCard = Duel.AnnounceCard
Duel.AnnounceCard = function(...)
	local id=80831721
	while id==80831721 do
		id=OrigAnnounceCard(...)
	end
	return id
end

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
	for i=0,1 do
		if CUNGUI.RuleCard[i] then Duel.Remove(CUNGUI.RuleCard[i],POS_FACEUP,REASON_RULE) end
	end
end

CUNGUI.RuleCard={}
CUNGUI.RuleCard[0]=Group.CreateGroup()
CUNGUI.RuleCard[1]=Group.CreateGroup()
CUNGUI.CreatedCard={}

function CUNGUI.RegisterCardRule(tp)
	for i=1,3 do
		local c=Duel.CreateToken(tp,80831721)
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
		CUNGUI.RuleCard[tp]:AddCard(c)
		--forbid
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(66666004,4))
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetTarget(CUNGUI.ruletg)
		e1:SetOperation(CUNGUI.ruleop)
		c:RegisterEffect(e1)
		e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetValue(CUNGUI.damval)
		Duel.RegisterEffect(e1,0)
	end
end

function CUNGUI.ruletg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(Duel.AnnounceCard(tp))
end

function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.CreateToken(tp,e:GetLabel())
	CUNGUI.RuleCard[tp]:RemoveCard(e:GetHandler())
	CUNGUI.CreatedCard[c]=true
	Duel.Exile(e:GetHandler(),REASON_RULE)
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end

function CUNGUI.damval(e,re,val,r,rp,rc)
	if not re then return val end
	local c=re:GetHandler()
	if (r & REASON_EFFECT)~=0 and c and CUNGUI.CreatedCard[c] then return 0
	else return val end
end
