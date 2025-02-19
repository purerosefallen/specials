--钻头机人
function c71218746.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71218746,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71218746)
	e1:SetCost(c71218746.spcost1)
	e1:SetTarget(c71218746.sptg1)
	e1:SetOperation(c71218746.spop1)
	c:RegisterEffect(e1)
	----th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71218746,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,71218747)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(c71218746.thcost)
	e2:SetTarget(c71218746.thtg)
	e2:SetOperation(c71218746.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(71218746,ACTIVITY_SPSUMMON,c71218746.counterfilter)
	
	-------Des
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(71218746,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetCountLimit(1,71218748)
	e4:SetTarget(c71218746.destg)
	e4:SetOperation(c71218746.desop)
	c:RegisterEffect(e4)
	end


function c71218746.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_FUSION)
end

-------1

function c71218746.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION) and c:IsAbleToExtraAsCost()
end
function c71218746.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71218746.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c71218746.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c71218746.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71218746.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
---------2

function c71218746.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71218746,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c71218746.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c71218746.splimit(e,c)
	return not c:IsSetCard(0x16)
end
function c71218746.filter(c)
	return c:IsSetCard(0x16) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c71218746.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71218746.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71218746.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71218746.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

----------4
function c71218746.tgfilter(c)
	return c:IsDefensePos()
end
function c71218746.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71218746.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup( c71218746.tgfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c71218746.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp, c71218746.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT) end
end


