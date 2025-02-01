--森罗的影孢子 伞菌
local s,id,o=GetID()
function s.initial_effect(c)
	--deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_FLIP)
    e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--be target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,id)
	e3:SetCondition(s.scondition)
	e3:SetTarget(s.starget)
	e3:SetOperation(s.soperation)
	c:RegisterEffect(e3)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>5 then ct=5 end
	local t={}
	for i=1,ct do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	local sg=g:Filter(Card.IsRace,nil,RACE_PLANT)
	if sg:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
	end
	ac=ac-sg:GetCount()
	if ac>0 then
		Duel.SortDecktop(tp,tp,ac)
		for i=1,ac do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
    if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
        Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
    end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_REVEAL)
end
function s.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENCE)~=0 then
        if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local sg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
            Duel.HintSelection(sg)
            Duel.Destroy(sg,REASON_EFFECT)
        end
		
	end
end

function s.scondition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x90) and re:GetHandler()~=e:GetHandler()
end
function s.filter(c)
    return c:IsRace(RACE_PLANT) and c:IsType(TYPE_MONSTER)
end
function s.starget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function s.soperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsFacedown() and c:IsRelateToEffect(e) and Duel.ChangePosition(c,POS_FACEUP)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
        if #g>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            local tc=g:Select(tp,1,1,nil):GetFirst()
                Duel.ShuffleDeck(tp)
                Duel.MoveSequence(tc,SEQ_DECKTOP)
                Duel.ConfirmDecktop(tp,1)
        end
	end
end