--邪恶★双子挑战
local s,id,o=GetID()
function c98360333.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,98360333+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(s.negreg)
	e1:SetTarget(c98360333.target)
	e1:SetOperation(c98360333.activate)
	c:RegisterEffect(e1)
	--sset
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
    e2:SetCountLimit(1,id+2)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetCondition(s.thcon2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
    e4:SetCountLimit(1,id+2)
    e4:SetCondition(s.con)
	e4:SetTarget(s.thtg1)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.scon)
	e0:SetDescription(aux.Stringid(id,4))
	c:RegisterEffect(e0)
end
function s.cfilter1(c)
	return  c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2151) and c:IsFaceup()
end
function s.scon(e)
	return Duel.IsExistingMatchingCard(s.cfilter1,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
--or
function s.negreg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_NEGATED)
	e1:SetLabelObject(e)
	e1:SetOperation(s.negcheck)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.negcheck(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local de=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON)
	if rp==tp and de and re==te then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetOperation(s.negevent)
		e1:SetLabelObject(te)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.negevent(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.RaiseEvent(te:GetHandler(),EVENT_CUSTOM+id,te,0,tp,tp,0)
	e:Reset()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return rp==tp and de and dp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler()==re:GetHandler() and e:GetHandler():GetReasonEffect()==de
end
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and c:GetReasonEffect()==nil
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
    end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
        and Duel.GetFlagEffect(tp,id)>0
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
    end

	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if DuelGetFlagEffect(tp,id)>0 then Duel.ResetFlagEffect(tp,id) end
    local sg=Duel.GetMatchingGroup(s.setfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
    if #sg>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
        local ct=sg:Select(tp,1,1,nil)
        Duel.SSet(tp,ct)
    end
end

--
function c98360333.tgfilter(c,e,tp)
	return c:IsSetCard(0x152,0x153) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98360333.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and c98360333.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c98360333.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98360333.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98360333.linkfilter(c)
	return c:IsLinkSummonable(nil)
end
function s.setfilter1(c)
    return c:IsCode(34365442) and c:IsSSetable()
end
function s.setfilter2(c)
    return c:IsCode(27923575) and c:IsSSetable()
end
function c98360333.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetMZoneCount(tp)<1 or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then 
        Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
    end
        local sg=Duel.GetMatchingGroup(s.setfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	    local g=Duel.GetMatchingGroup(c98360333.linkfilter,tp,LOCATION_EXTRA,0,nil)
	    if #sg>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98360333,0)) then
		    Duel.BreakEffect()
		    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		    local ttc=g:Select(tp,1,1,nil):GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_BE_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
			e1:SetCondition(s.effcon)
			e1:SetOperation(s.effop1)
			tc:RegisterEffect(e1,true)
			Duel.LinkSummon(tp,ttc,nil)
	    end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end
function s.effop1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.setfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #sg<=0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local ct=sg:Select(tp,1,1,nil)
	Duel.SSet(tp,ct)
	e:Reset()
end