--スターライト・ジャンクション
function c1003840.initial_effect(c)
	aux.AddCodeList(c,44508094,50091196,62560742)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1003840,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,1003840)
	e2:SetCost(c1003840.spcost2)
	e2:SetTarget(c1003840.sptg2)
	e2:SetOperation(c1003840.spop2)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,1003841)
	e3:SetCondition(c1003840.thcon)
	e3:SetTarget(c1003840.thtg)
	e3:SetOperation(c1003840.thop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1003840,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,1003842)
	e4:SetCondition(c1003840.spcon)
	e4:SetTarget(c1003840.sptg)
	e4:SetOperation(c1003840.spop)
	c:RegisterEffect(e4)
end
function c1003840.cfilter(c)
	return c:IsFaceup() and (c:IsCode(44508094) or c:IsLevel(10) and c:IsType(TYPE_SYNCHRO))
end
function c1003840.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1003840.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function c1003840.spfilter(c,e,tp)
	return c:IsCode(50091196,62560742) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c1003840.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1003840.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1003840.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1003840.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c1003840.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c1003840.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c1003840.filter1(c)
	return c:IsSetCard(0x27,0x1017,0x43) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1003840.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1003840.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1003840.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1003840.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
	end
end
function c1003840.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return Duel.GetTurnPlayer()~=tp
		and ec:IsPreviousLocation(LOCATION_EXTRA) and ec:IsPreviousControler(tp) and ec:IsType(TYPE_SYNCHRO)
end
function c1003840.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c1003840.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c1003840.cfilter2(c,e,tp,ft)
	local cs=0
	if c:IsSetCard(0x1017,0x27) then cs=1 end
	local lv=c:GetLevel()
	return lv>0 and c:IsType(TYPE_TUNER)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c1003840.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,lv,cs)
end
function c1003840.spfilter2(c,e,tp,lv,cs)
	return (c:IsSetCard(0x1017,0x27) or cs==1 and c:IsType(TYPE_TUNER)) and not c:IsLevel(lv) and c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1003840.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupEx(tp,c1003840.cfilter2,1,REASON_COST,true,nil,e,tp,ft) end
	local g=Duel.SelectReleaseGroupEx(tp,c1003840.cfilter2,1,1,REASON_COST,true,nil,e,tp,ft)
	if g:GetFirst():IsSetCard(0x1017,0x27) then
		e:SetLabel(g:GetFirst():GetLevel(),1)
	else
		e:SetLabel(g:GetFirst():GetLevel(),0)
	end
	Duel.Release(g,REASON_COST)
end
function c1003840.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c1003840.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv,cs=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1003840.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv,cs)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end