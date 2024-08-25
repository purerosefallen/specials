--村规决斗：命运抽卡
--开局时，双方将1张红龙（56789759）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--自己因通常抽卡以外抽卡的场合，如果卡组的数量在要抽的卡的数量以上，改为从卡组选卡加入手卡。
--自己通常抽卡的场合，如果卡组的数量在要抽的卡的数量以上，改为从卡组选卡加入手卡。

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
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
		Duel.SendtoDeck(g,nil,2,REASON_RULE)
		Duel.Draw(0,5,REASON_RULE)
		Duel.Draw(1,5,REASON_RULE)
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
	local c=Duel.CreateToken(tp,56789759)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27564031,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(CUNGUI.condition)
	e2:SetTarget(CUNGUI.target)
	e2:SetOperation(CUNGUI.operation)
	c:RegisterEffect(e2)
end
function CUNGUI.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function CUNGUI.filter(c)
	return c:IsSetCard(0x23) and c:IsAbleToHand()
end
function CUNGUI.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dt=Duel.GetDrawCount(tp)
	if chk==0 then return dt>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=dt end
	aux.DrawReplaceCount=0
	aux.DrawReplaceMax=dt
	e:SetLabel(dt)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	e1:SetValue(0)
	Duel.RegisterEffect(e1,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
local OrigDraw = Duel.Draw
Duel.Draw = function(tp,count,reason)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<count then
		OrigDraw(tp,dt,reason)
		return
	end
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,count,count,nil)
	Duel.SendtoHand(g,tp,REASON_DRAW | reason)
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp)
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount>aux.DrawReplaceMax then return end
	local dt=e:GetLabel()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<dt then
		OrigDraw(tp,dt,REASON_RULE)
		return
	end
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,dt,dt,nil)
	Duel.SendtoHand(g,tp,REASON_DRAW+REASON_RULE)
end