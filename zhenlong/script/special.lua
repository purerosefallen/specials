--[[
开局时，双方把1张【蛇毒沼泽（54306223）】从卡组外放置到除外的卡中。
决斗中，这张【蛇毒沼泽】不在表侧除外状态的场合立刻表侧表示除外。
这张【蛇毒沼泽】得到以下效果外文本，在这张卡被除外的状态下持续生效。

·自己场上4星以下的【异虫】怪兽得到以下效果。
-这个卡名的这个效果1回合只能使用1次，自己·对方回合可以发动。从卡组·墓地·除外的卡中选1只5星以上的【异虫】怪兽特殊召唤。
-这个卡名的这个效果1回合只能使用1次，自己·对方回合可以发动。选场上1只怪兽变为里侧守备表示，或选场上1张表侧表示的魔法·陷阱卡送去墓地。成功送去墓地的场合，自己抽1张。
-只要这张卡在怪兽区域存在，自己不是融合·连接怪兽不能从额外卡组特殊召唤。

·自己场上5星以上的【异虫】怪兽得到以下效果。
-这个卡名的这个效果1回合只能使用1次，自己·对方回合可以发动。从卡组·墓地·除外的卡中选1只4星以下的【异虫】怪兽特殊召唤。
-这个卡名的这个效果1回合只能使用1次，自己·对方回合可以发动。选场上1张里侧表示的怪兽变为表侧守备表示或表侧攻击表示，或选场上1张里侧表示的魔法·陷阱卡送去墓地。成功送去墓地的场合，自己抽1张。
-只要这张卡在怪兽区域存在，自己不是融合·连接怪兽不能从额外卡组特殊召唤。

·自己手卡的【蛇毒】怪兽得到以下效果。
这个效果的发动和效果不会被无效化，多个此类效果1回合只能使用1次。
把这张卡从手卡丢弃才能发动。从卡组外把3张【毒蛇神 维诺米娜迦】加入卡组最下方，把1张【蛇神降临】盖放到魔法·陷阱区域，这个效果盖放的卡可以在这个回合发动。
这个效果的发动后，自己在这场决斗中不是【毒蛇神 维诺米娜迦】【毒蛇王 维诺米隆】【蛇毒】怪兽不能把场上的怪兽效果发动。

·自己手卡的【外星人】怪兽得到以下效果。
-这张卡可以把对方场上1张【外星人】以外的卡加入自己手卡（额外怪兽加入额外卡组），在对方场上特殊召唤。这个效果特殊召唤成功的场合，这张卡上放置1个A指示物。使用了这个召唤方式的回合，自己不能通常召唤。
-这张卡可以把场上1个【A指示物】去除，自己抽1张，在自己场上特殊召唤。

·自己手卡·墓地的【爬虫妖】怪兽得到以下效果。
-自己场上没有从额外卡组特殊召唤的怪兽存在的场合才能发动。这张卡从手卡·墓地特殊召唤，从卡组把1张【爬虫妖】卡加入手卡。这个效果的发动后，自己在这场决斗中不是同调·连接怪兽不能从额外卡组特殊召唤。

·自己墓地的【溟界】怪兽得到以下效果。
-对方把怪兽召唤·特殊召唤的场合才能发动。那张卡送去墓地。
那之后，把这只怪兽和那只怪兽从墓地特殊召唤到各自场上，自己从自己卡组抽1张，或从对方卡组抽3张。这个效果的发动后，自己在这场决斗中不是超量·连接怪兽不能从额外卡组特殊召唤。

·自己手卡的【溟界】怪兽得到以下效果。
-对方把效果发动时，把手卡的这张卡丢弃才能发动。对方必须把卡组最上方的2张卡加入这张卡控制者的手卡，或者让那个发动无效。
这个效果的发动后，自己直到结束阶段不能从手卡把【溟界】以外的怪兽效果发动。
]]--
CUNGUI = {}
CUNGUI.disabled={}
CUNGUI.RuleCards=Group.CreateGroup()

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
	--adjust
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation2)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.AdjustOperation2(e,tp,eg,ep,ev,re,r,rp)
	if (CUNGUI.RuleCards:Filter(Card.IsLocation,nil,LOCATION_REMOVED):GetCount()~=2) then
		Duel.Remove(CUNGUI.RuleCards,POS_FACEUP,REASON_RULE)
	end
end

CUNGUI.Used={}

function CUNGUI.useoncecondition(e,tp,eg,ep,ev,re,r,rp)
    return CUNGUI.Used[e:GetHandler():GetOriginalCode()] == nil
        or CUNGUI.Used[e:GetHandler():GetOriginalCode()][e:GetLabel()] == nil
        or CUNGUI.Used[e:GetHandler():GetOriginalCode()][e:GetLabel()] < Duel.GetTurnCount()
end

function CUNGUI.RegisterRuleEffect(c,tp)
	--异虫-spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(21639276,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_MZONE)
	e0:SetHintTiming(0,TIMING_END_PHASE)
    e0:SetCondition(CUNGUI.useoncecondition)
    e0:SetLabel(1)
	e0:SetTarget(CUNGUI.wormtg)
	e0:SetOperation(CUNGUI.wormop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(CUNGUI.eftgworm)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
    --异虫-card
	e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(3117804,0))
	e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_POSITION)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_MZONE)
    e0:SetCondition(CUNGUI.useoncecondition)
    e0:SetLabel(2)
	e0:SetTarget(CUNGUI.wormtg2)
	e0:SetOperation(CUNGUI.wormop2)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(CUNGUI.eftgworm)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
    --异虫-limit
	e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(CUNGUI.wormsplimit)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(CUNGUI.eftgworm)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
    --蛇毒
	e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(28985331,0))
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetRange(LOCATION_HAND)
	e0:SetType(EFFECT_TYPE_IGNITION)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCost(CUNGUI.venomcost)
	e0:SetTarget(CUNGUI.venomtarget)
	e0:SetOperation(CUNGUI.venomop)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(CUNGUI.eftgvenom)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
    --外星人-opposp
	e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetDescription(103)
	e0:SetRange(LOCATION_HAND)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e0:SetTargetRange(POS_FACEUP,1)
	e0:SetCondition(CUNGUI.alienspcon)
	e0:SetOperation(CUNGUI.alienspop)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(CUNGUI.eftgalien)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--外星人-selfsp
	e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetDescription(102)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(CUNGUI.alienspcon2)
	e0:SetOperation(CUNGUI.alienspop2)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(CUNGUI.eftgalien)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
    --爬虫妖
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(52846880,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCondition(CUNGUI.reptcond)
	e0:SetTarget(CUNGUI.repttg)
	e0:SetOperation(CUNGUI.reptop)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE,0)
	e1:SetTarget(CUNGUI.eftgrept)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
    --溟界-summon
	e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(39041550,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCondition(CUNGUI.obspcon)
	e0:SetTarget(CUNGUI.obsptg)
	e0:SetOperation(CUNGUI.obspop)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_GRAVE,0)
	e1:SetTarget(CUNGUI.eftgob)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
    
    --溟界-spsummon
	e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(39041550,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCondition(CUNGUI.obspcon)
	e0:SetTarget(CUNGUI.obsptg)
	e0:SetOperation(CUNGUI.obspop)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_GRAVE,0)
	e1:SetTarget(CUNGUI.eftgob)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
    --溟界-uneffect
	e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_HAND)
    e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCondition(CUNGUI.obdiscon)
	e0:SetCost(CUNGUI.obdiscost)
	e0:SetTarget(CUNGUI.obdistg)
	e0:SetOperation(CUNGUI.obdisop)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(CUNGUI.eftgob)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
end
function CUNGUI.alienspcon2(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(c:GetControler(),1,1,0x100e,1,REASON_COST)
end
function CUNGUI.alienspop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,1,0x100e,1,REASON_COST)
	Duel.Draw(tp,1,REASON_COST)
end
function CUNGUI.obdiscon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function CUNGUI.obdiscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function CUNGUI.obfiltera(e,ev)
    return not e:GetHandler():IsStatus(STATUS_DISABLED)
		or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		or not Duel.IsChainNegatable(ev)
end
function CUNGUI.obfilterb(tp)
    local g=Duel.GetDecktopGroup(1-tp,2)
    if not g or #g<2 then return false end
    return g:GetFirst():IsAbleToHand()
end
function CUNGUI.obdistg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return CUNGUI.obfiltera(re,ev) or CUNGUI.obfilterb(tp) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(CUNGUI.obaclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function CUNGUI.obaclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsLocation(LOCATION_HAND) and not rc:IsSetCard(0x161)
end
function CUNGUI.obdisop(e,tp,eg,ep,ev,re,r,rp)
    local b1=CUNGUI.obfiltera(re,ev)
    local b2=CUNGUI.obfilterb(tp)
    local op=-1
    if b1 and not b2 then
        op=0
    elseif b2 and not b1 then
        op=1
	elseif not b2 and not b1 then
		return
    end
    if op==-1 then
        op=Duel.SelectOption(1-tp,aux.Stringid(1249315,0),aux.Stringid(18847598,0))
    end
    if op==0 then
		local p=e:GetHandler():GetControler()
        local g=Duel.GetDecktopGroup(1-p,2)
        Duel.SendtoHand(g,tp,REASON_RULE)
    else
	    Duel.NegateActivation(ev)
    end
end
function CUNGUI.obsumfilter(c,tp)
	return c:IsControler(1-tp)
end
function CUNGUI.obsumfilter2(c,tp)
	return c:IsRelateToChain()
end
function CUNGUI.obspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(CUNGUI.obsumfilter,1,nil,tp)
end
function CUNGUI.obsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetMZoneCount(tp)>0
        and Duel.IsPlayerCanDraw(tp,1) end
    local g=eg:Filter(CUNGUI.obsumfilter,nil,tp)
	for c in aux.Next(g) do
		c:CreateEffectRelation(e)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local e0=Effect.GlobalEffect()
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e0:SetTargetRange(1,0)
	e0:SetTarget(CUNGUI.obsplimit)
    Duel.RegisterEffect(e0,tp)
end
function CUNGUI.obspop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(CUNGUI.obsumfilter,nil,tp)
	g=g:Filter(Card.IsRelateToEffect,nil,e)
    if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) and #g>0 then return end
		Duel.SpecialSummonStep(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
		if Duel.SpecialSummonComplete()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,555)
			local op = Duel.SelectOption(tp,102,103)
			if op==0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			else
				local g=Duel.GetDecktopGroup(1-tp,math.min(3,Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)))
				Duel.SendtoHand(g,tp,REASON_EFFECT+REASON_DRAW)
				if #g < 3 then
					Duel.Draw(1-tp,1,REASON_EFFECT)
				end
			end
		end
    end
end
function CUNGUI.reptcond(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(Card.IsSummonLocation,tp,LOCATION_MZONE,0,1,nil,LOCATION_EXTRA)
end
function CUNGUI.reptdeckfilter(c)
    return c:IsSetCard(0x3c) and c:IsAbleToHand()
end
function CUNGUI.repttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingMatchingCard(CUNGUI.reptdeckfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local e0=Effect.GlobalEffect()
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e0:SetTargetRange(1,0)
	e0:SetTarget(CUNGUI.reptsplimit)
    Duel.RegisterEffect(e0,tp)
end
function CUNGUI.reptop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,CUNGUI.reptdeckfilter,tp,LOCATION_DECK,0,1,1,nil)
        if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function CUNGUI.venomcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function CUNGUI.alienspfilter(c,tp)
	return (c:IsAbleToHandAsCost() or c:IsAbleToExtraAsCost()) and Duel.GetMZoneCount(1-tp,c,tp)>0
		and not c:IsSetCard(0xc)
end
function CUNGUI.alienspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(CUNGUI.alienspfilter,tp,0,LOCATION_MZONE,1,nil,tp)
        and Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
function CUNGUI.alienspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,CUNGUI.alienspfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	if #g>0 then Duel.SendtoHand(g,tp,REASON_COST) end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetOperation(CUNGUI.aliencounter)
	c:RegisterEffect(e3)
end
function CUNGUI.aliencounter(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x100e,1)
    e:Reset()
end
function CUNGUI.venomtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(CUNGUI.venomlimit)
	Duel.RegisterEffect(e1,tp)
end
function CUNGUI.venomlimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsLocation(LOCATION_MZONE)
        and not rc:IsCode(8062132,72677437) and not rc:IsSetCard(0x50)
end
function CUNGUI.venomop(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
    for i=1,3 do
        g:AddCard(Duel.CreateToken(tp,8062132))
    end
    if Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_RULE)>0 then
        local c=Duel.CreateToken(tp,16067089)
        Duel.SSet(tp,c)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(3160805,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
    end
end
function CUNGUI.wormsplimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_LINK+TYPE_FUSION)
end
function CUNGUI.reptsplimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_LINK+TYPE_SYNCHRO)
end
function CUNGUI.obsplimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_LINK+TYPE_XYZ)
end
function CUNGUI.wormfilter(c,e,tp)
    local b = c:IsLevelBelow(4)
    if e:GetHandler():IsLevelBelow(4) then
        b = c:IsLevelAbove(5)
    end
	return c:IsSetCard(0x3e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_DECK) or c:IsFaceup()) and b
end
function CUNGUI.wormtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(CUNGUI.wormfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
    if CUNGUI.Used[e:GetHandler():GetOriginalCode()] == nil then CUNGUI.Used[e:GetHandler():GetOriginalCode()]={} end
    CUNGUI.Used[e:GetHandler():GetOriginalCode()][e:GetLabel()]=Duel.GetTurnCount()
end
function CUNGUI.wormop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(CUNGUI.wormfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function CUNGUI.wormfilter2a(c)
    return c:IsFacedown() and c:IsLocation(LOCATION_MZONE) and c:IsCanChangePosition()
end
function CUNGUI.wormfilter2b(c)
    return c:IsFacedown() and c:IsLocation(LOCATION_SZONE) and c:IsAbleToGrave()
end
function CUNGUI.wormfilter2c(c)
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsCanChangePosition()
end
function CUNGUI.wormfilter2d(c)
    return c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:IsAbleToGrave()
end
function CUNGUI.wormfilter2(c,oc)
    if oc:IsLevelAbove(5) then
        return CUNGUI.wormfilter2a(c) or CUNGUI.wormfilter2b(c)
    end
    return CUNGUI.wormfilter2c(c) or CUNGUI.wormfilter2d(c)
end
function CUNGUI.wormtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.wormfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e:GetHandler()) end
    if CUNGUI.Used[e:GetHandler():GetOriginalCode()] == nil then CUNGUI.Used[e:GetHandler():GetOriginalCode()]={} end
    CUNGUI.Used[e:GetHandler():GetOriginalCode()][e:GetLabel()]=Duel.GetTurnCount()
end
function CUNGUI.wormop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,CUNGUI.wormfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,c)
    if #g>0 then
        local tc=g:GetFirst()
        if c:IsLevelAbove(5) then
            if tc:IsLocation(LOCATION_MZONE) then
                local pos = Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
                Duel.ChangePosition(tc,pos)
            else
                Duel.SendtoGrave(tc,REASON_EFFECT)
            end
        else
            if tc:IsLocation(LOCATION_MZONE) then
                Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
            else
                Duel.SendtoGrave(tc,REASON_EFFECT)
            end
        end
    end
end
function CUNGUI.eftgworm(e,c)
	return c:IsSetCard(0x3e) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.eftgvenom(e,c)
	return c:IsSetCard(0x50) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.eftgalien(e,c)
	return c:IsSetCard(0xc) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.eftgrept(e,c)
	return c:IsSetCard(0x3c) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.eftgob(e,c)
	return c:IsSetCard(0x161) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local card1 = Duel.CreateToken(0,54306223)
	local card2 = Duel.CreateToken(1,54306223)
	CUNGUI.RegisterRuleEffect(card1,0)
	CUNGUI.RegisterRuleEffect(card2,1)
	CUNGUI.RuleCards:AddCard(card1)
	CUNGUI.RuleCards:AddCard(card2)
	Duel.Remove(card1,POS_FACEUP,REASON_RULE)
	Duel.Remove(card2,POS_FACEUP,REASON_RULE)
	e:Reset()
end