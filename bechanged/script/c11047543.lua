-- 界念力感知区
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
end

function s.sfilter1(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_TUNER)
		and Duel.IsExistingMatchingCard(s.sfilter2,tp,LOCATION_REMOVED,0,1,c,e,tp,c:GetLevel())
end
function s.sfilter2(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsFaceup() and c:IsRace(RACE_PSYCHO) and not c:IsType(TYPE_TUNER)
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function s.spfilter(c,e,tp,lv)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.thfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsLevelBelow(4) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingTarget(s.sfilter1,tp,LOCATION_REMOVED,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	
	local off=1
	local ops={}
	local opval={}
	
	if b1 then
		ops[off]=aux.Stringid(id,0) -- 同调召唤效果
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,1) -- 检索效果
		opval[off-1]=2
		off=off+1
	end
	
	if off==1 then return end -- 没有可选效果时直接返回
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	
	if opval[op]==1 then
		-- 同调召唤效果
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
		e:SetProperty(0)
		e:SetOperation(s.synchroop)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectTarget(tp,s.sfilter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectTarget(tp,s.sfilter2,tp,LOCATION_REMOVED,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst():GetLevel())
		g1:Merge(g2)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		-- 检索效果
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		e:SetOperation(s.thop)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end

function s.synchroop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()~=2 or Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)~=2 then return end
	
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	local lv=tc1:GetLevel()+tc2:GetLevel()
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end