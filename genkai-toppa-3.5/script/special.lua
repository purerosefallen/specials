CUNGUI = {}
CUNGUI.disabled={}
CUNGUI.RuleCards=Group.CreateGroup()
CUNGUI._IsSetCard=Card.IsSetCard

function Card.IsSetCard(c,...)
    if c:GetFlagEffect(98765432)>0 then return false end
    return CUNGUI._IsSetCard(c, ...)
end

function Card.IsOrigSetCard(c,...)
    return CUNGUI._IsSetCard(c, ...)
end

CUNGUI._Exile = Duel.Exile
function Duel.Exile(targ,reason)
	if aux.GetValueType(targ) == "Card" then
		targ = Group.FromCards(targ)
	end
	local g=Group.CreateGroup()
	for tc in aux.Next(targ) do
		if tc:GetOverlayCount()>0 then
			g:AddCard(tc:GetOverlayGroup())
		end
		g:AddCard(tc)
	end
	return CUNGUI._Exile(g,reason)
end

function CUNGUI.regsplimit(tc,tp)
	local code=tc:GetOriginalCodeRule()
	local race=tc:GetOriginalRace()
	
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(CUNGUI.sylcheckfunc(code,race))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
end

function CUNGUI.sylcheckfunc(code,race)
	return function(e,c,sump,sumtype,sumpos,targetp,se)
		return c:GetOriginalRace()==race and c:GetOriginalCodeRule()~=code
	end
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
	--森罗
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(CUNGUI.efilter)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(CUNGUI.eftgsyl1)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
    e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(aux.TRUE)
	e0:SetRange(LOCATION_HAND)
	c:RegisterEffect(e0)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(CUNGUI.eftgsyl2)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
    --Atk/def
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_REMOVED)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x90))
    e2:SetValue(2000)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
	--spsummon
	e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75425043,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetTarget(CUNGUI.inftsptg)
	e0:SetOperation(CUNGUI.inftspop)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE,0)
	e1:SetTarget(CUNGUI.eftginft)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--to hand
	e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75425043,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
    e0:SetCost(CUNGUI.discost)
	e0:SetTarget(CUNGUI.bdnthtg)
	e0:SetOperation(CUNGUI.bdnthop)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(CUNGUI.eftgbdn2)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--exile
	e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75425043,0))
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetRange(LOCATION_MZONE)
    e0:SetCode(EVENT_RELEASE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCondition(CUNGUI.bdnexcon)
	e0:SetTarget(CUNGUI.bdnextg)
	e0:SetOperation(CUNGUI.bdnexop)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(CUNGUI.eftgbdn2)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
end
function CUNGUI.bdnexcon(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(Duel.GetCurrentChain())
	return Duel.GetCurrentChain()<2
end
function CUNGUI.bdnextg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,87654321)==0 end
	Duel.RegisterFlagEffect(tp,87654321,RESET_CHAIN,0,1)
    e:SetLabel(eg:GetCount())
end
function CUNGUI.bdnexop(e,tp,eg,ep,ev,re,r,rp)
    local i=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,i,nil)
    if #g>0 then
        Duel.Exile(g,REASON_EFFECT)
    end
end
function CUNGUI.bdnthtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(CUNGUI.bdnthfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
            and Duel.IsExistingMatchingCard(CUNGUI.bdnthfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function CUNGUI.bdnthfilter1(c)
    return c:IsSetCard(0x196) and c:IsAbleToHand()
end
function CUNGUI.bdnthfilter2(c)
    return c:IsSetCard(0x197) and c:IsAbleToHand()
end
function CUNGUI.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function CUNGUI.bdnthtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return
        Duel.IsExistingMatchingCard(CUNGUI.bdnthfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
        and Duel.IsExistingMatchingCard(CUNGUI.bdnthfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function CUNGUI.bdnthop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=Duel.SelectMatchingCard(tp,CUNGUI.bdnthfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,CUNGUI.bdnthfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g1>0 then
        Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
    end
    if #g2>0 then
        Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
    end
end
function CUNGUI.inftchtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSetCard(0x127) end
end
function CUNGUI.inftchop(e,tp,eg,ep,ev,re,r,rp)
    local race=Duel.AnnounceRace(tp,1,RACE_ALL)
    local attr=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
    local lv=Duel.AnnounceLevel(tp,1,13)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    for c in aux.Next(g) do
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
        e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(race)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
        e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(attr)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
        c:RegisterFlagEffect(98765432,RESET_EVENT+RESETS_STANDARD+RESET_PHASE,0,1)
    end
end
function CUNGUI.inftspfilter(c,e,tp)
    return c:IsSetCard(0x127) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function CUNGUI.inftsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
            and Duel.IsExistingMatchingCard(CUNGUI.inftspfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
            and Duel.GetMZoneCount(tp)>1
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+e:GetHandler():GetLocation())
end
function CUNGUI.inftspop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,CUNGUI.inftspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    if #g>0 then
		Duel.BreakEffect()
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(CUNGUI.inftsplimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if not CUNGUI.inftreg then
		CUNGUI.inftreg = true
		--reg
		local e4=Effect.CreateEffect(c)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e4:SetOperation(CUNGUI.inftregop)
		Duel.RegisterEffect(e4,tp)
	end
end
function CUNGUI.inftregop(e,tp,eg)
	for tc in aux.Next(eg) do
		local race = tc:GetRace()
		if tc:IsControler(tp) then
			if CUNGUI.inftlimit[tp] ~= race and CUNGUI.inftlimit[tp+2] ~= race then
				if CUNGUI.inftlimit[tp]==0 then
					CUNGUI.inftlimit[tp] = race
				elseif CUNGUI.inftlimit[tp+2] == 0 then
					CUNGUI.inftlimit[tp+2] = race
				else
					Duel.SendtoGrave(tc,REASON_RULE)
				end
			end
		end
	end
end
CUNGUI.inftlimit = {}
CUNGUI.inftlimit[0]=0
CUNGUI.inftlimit[1]=0
CUNGUI.inftlimit[2]=0
CUNGUI.inftlimit[3]=0
function CUNGUI.inftsplimit(e,c)
	local tp=e:GetHandlerPlayer()
	return not ((c:IsRace(CUNGUI.inftlimit[tp]) or CUNGUI.inftlimit[tp]==0)
		or (c:IsRace(CUNGUI.inftlimit[tp+2]) or CUNGUI.inftlimit[tp+2]==0))
end
function CUNGUI.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--森罗
function CUNGUI.eftgsyl1(e,c)
	return c:IsSetCard(0x90) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.eftgsyl2(e,c)
	return c:IsSetCard(0x90) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.eftginft(e,c)
	return c:IsSetCard(0x127) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.eftgbdn(e,c)
	return (c:IsOrigSetCard(0x196) or c:IsOrigSetCard(0x197)) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.eftgbdn2(e,c)
	return c:IsOrigSetCard(0x196) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local card1 = Duel.CreateToken(0,83404468)
	local card2 = Duel.CreateToken(1,83404468)
	CUNGUI.RegisterRuleEffect(card1,0)
	CUNGUI.RegisterRuleEffect(card2,1)
	CUNGUI.RuleCards:AddCard(card1)
	CUNGUI.RuleCards:AddCard(card2)
	Duel.Remove(card1,POS_FACEUP,REASON_RULE)
	Duel.Remove(card2,POS_FACEUP,REASON_RULE)
	e:Reset()
end
