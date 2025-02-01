--森罗的仙树 凤凰木
local s,id,o=GetID()
function s.initial_effect(c)
	--deck check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--sort decktop
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.sdcon)
	e2:SetOperation(s.sdop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsRace(RACE_PLANT) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
	end
end
function s.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_REVEAL)
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	local ac=1
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		if ct==2 then ac=Duel.AnnounceNumber(tp,1,2)
		else ac=Duel.AnnounceNumber(tp,1,2,3) end
	end
	Duel.SortDecktop(tp,tp,ac)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.GetFlagEffect(tp,id)==0 and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsRace(RACE_PLANT) then
		Duel.DisableShuffleCheck()
		if Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)~=0 and c:IsLocation(LOCATION_HAND) and c:IsRelateToEffect(e) then
            Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
            Duel.RegisterFlagEffect(tp,id,RESET_PHASE+TIMING_END_PHASE,0,1)
			Duel.Draw(tp,1,REASON_EFFECT)
        end
	else
		Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
	end
end