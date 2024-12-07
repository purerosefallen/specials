--無限械アイン・ソフ
function c36894320.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(36894320,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c36894320.spcon)
	e3:SetCost(c36894320.cost)
	e3:SetTarget(c36894320.sptg)
	e3:SetOperation(c36894320.spop)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(36894320,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c36894320.cost)
	e4:SetTarget(c36894320.tdtg)
	e4:SetOperation(c36894320.tdop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(36894320,3))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCondition(c36894320.handcon)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(36894320,0))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCondition(c36894320.condition)
	e6:SetOperation(c36894320.activate)
	c:RegisterEffect(e6)
end
function c36894320.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetHandlerPlayer()
end
function c36894320.acfilter(c)
	return c:IsFaceup() and c:IsCode(9409625) and c:IsAbleToGraveAsCost()
end
function c36894320.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36894320.acfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c36894320.acfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c36894320.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c36894320.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	local b1=c36894320.spcon(e,tp,eg,ep,ev,re,r,rp)
		and c36894320.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and c36894320.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c36894320.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and c36894320.tdtg(e,tp,eg,ep,ev,re,r,rp,0)
	local op=-1
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(36894320,0),aux.Stringid(36894320,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(36894320,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(36894320,1))+1
		end
	end
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(0)
		e:SetOperation(c36894320.spop)
		c36894320.cost(e,tp,eg,ep,ev,re,r,rp,1)
		c36894320.sptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==1 then
		e:SetCategory(CATEGORY_TODECK)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c36894320.tdop)
		c36894320.cost(e,tp,eg,ep,ev,re,r,rp,1)
		c36894320.tdtg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c36894320.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(36894320)==0 end
	c:RegisterFlagEffect(36894320,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c36894320.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c36894320.spfilter(c,e,tp)
	return c:IsSetCard(0x4a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c36894320.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c36894320.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c36894320.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c36894320.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c36894320.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c36894320.setfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if chk==0 then return not Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_ONFIELD,0,1,nil,9409625,72883039) and g:GetCount()>0 end
end
function c36894320.setfilter(c)
	return c:IsCode(9409625,72883039) and c:IsSSetable()
end
function c36894320.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c36894320.setfilter),e:GetOwner(),LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,sc)
	end
end
function c36894320.acop(c)
	return c:IsFaceup() and c:IsCode(9409625,72883039)
end
function c36894320.handcon(e,c)
	return Duel.IsExistingMatchingCard(c36894320.acop,e:GetHandler(),LOCATION_ONFIELD,0,1,nil)
end
function c36894320.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c36894320.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end