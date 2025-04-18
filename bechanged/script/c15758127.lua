--北极天熊五倍线充能
function c15758127.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15758127,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,15758127)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c15758127.thcon)
	e2:SetTarget(c15758127.thtg)
	e2:SetOperation(c15758127.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(15758127,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c15758127.spcon)
	e4:SetTarget(c15758127.sptarget)
	e4:SetOperation(c15758127.spop)
	c:RegisterEffect(e4)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15758127,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c15758127.tdcon)
	e3:SetTarget(c15758127.tdtg)
	e3:SetOperation(c15758127.tdop)
	c:RegisterEffect(e3)
end

--1
function c15758127.thfilter(c)
	return c:IsSetCard(0x163) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c15758127.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,e:GetHandler(),1-tp)
	--totestaltertotp
	--aftertestalterto1-tp
end
function c15758127.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15758127.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c15758127.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c15758127.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


--2

function c15758127.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c15758127.rfilter(c,tp)
	return (c:IsFaceup() or c:IsControler(tp)) and c:IsLevelAbove(1) and c:IsSetCard(0x163)
end
function c15758127.mnfilter(c,g,lv)
	return g:IsExists(c15758127.mnfilter2,1,c,c,lv)
end
function c15758127.mnfilter2(c,mc,lv)
	return c:GetLevel()-mc:GetLevel()==lv
end
function c15758127.spfilter(c,e,tp,g)
	return c:IsSetCard(0x163) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function c15758127.spfilter1(c,e,tp,g)
	return c15758127.spfilter(c,e,tp,g) and g:IsExists(c15758127.mnfilter,1,nil,g,c:GetLevel())
end
function c15758127.spfilter2(c,e,tp,lv)
	return c15758127.spfilter(c,e,tp,nil) and c:IsLevel(lv)
end
function c15758127.fselect(g,e,tp)
	return g:GetCount()==2 and Duel.IsExistingMatchingCard(c15758127.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function c15758127.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp,false,REASON_EFFECT):Filter(c15758127.rfilter,nil,tp)
	local b2=g:CheckSubGroup(c15758127.fselect,2,2,e,tp)
	if chk==0 then return b2 end
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c15758127.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local g=Duel.GetReleaseGroup(tp,false,REASON_EFFECT):Filter(c15758127.rfilter,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=g:SelectSubGroup(tp,c15758127.fselect,false,2,2,e,tp)
		if rg and rg:GetCount()==2 then
			local c1=rg:GetFirst()
			local c2=rg:GetNext()
			local lv=c1:GetLevel()-c2:GetLevel()
			if lv<0 then lv=-lv end
			if Duel.Release(rg,REASON_EFFECT)==2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,c15758127.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
				if sg:GetCount()>0 then
					Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
				end
			end
		end
end


--

function c15758127.cfilter(c,tp)
	return c:IsPreviousSetCard(0x163) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousTypeOnField()&TYPE_SYNCHRO~=0 and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end
function c15758127.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c15758127.cfilter,1,nil,tp) 
end
function c15758127.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return #g>7 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,#g-7,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end

--changethis
function c15758127.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	if ct<=7 or #g==0 then return end
	local tct=math.min(ct-7,#g) 
	--tct is num of card to deck 
	local mmm=tct-#g2
	--mmm is minimum count to be sent in grave and on field
	--if mmm>0 then tp must send from other than hand first
	if mmm<0 then mmm=0 end
	 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15758127,3))
	 local sg=g1:Select(tp,mmm,tct,nil)
	 Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	  if #sg<tct then
	  local hand1=tct-#sg
	  local sg1=g2:RandomSelect(tp,hand1,hand1,nil)
	  Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	  end   
end
