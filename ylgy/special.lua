local function grantDecktop(e)
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e3:SetTarget(function(e,c)
		local tp=c:GetControler()
		local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		local g=dg:GetMinGroup(Card.GetSequence)
		return g:GetFirst()==c
	end)
	e3:SetLabelObject(e)
	Duel.RegisterEffect(e3,0)
end

local function gf(c,tp)
  return (c:IsFaceup() or c:IsControler(tp)) and c:IsAbleToGrave()
end

local function sf(c,g)
  return g:IsExists(Card.IsCode,2,c,c:GetCode())
end

function Auxiliary.PreloadUds()
  local e1=Effect.GlobalEffect()
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
  e1:SetRange(LOCATION_DECK)
  e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    if not (Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetCurrentChain()==0) then return false end
    local g=Duel.GetMatchingGroup(gf,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,LOCATION_ONFIELD,nil,tp)
    return g:IsExists(sf,1,nil,g)
  end)
  e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(gf,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,LOCATION_ONFIELD,nil,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tc=g:FilterSelect(tp,sf,1,1,nil,g):GetFirst()
    local g2=g:FilterSelect(tp,Card.IsCode,2,2,tc,tc:GetCode())
    Duel.Hint(HINT_CARD,0,73915052)
    local tg=g2+tc
    local codes={}
    for tc in aux.Next(tg) do
      if tc:IsType(TYPE_MONSTER) then
        table.insert(codes,tc:GetCode())
      end
    end
    Duel.DisableShuffleCheck()
    local needShuffle=tg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK)
    if Duel.SendtoGrave(tg,REASON_RULE)>0 then
      local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
      for oc in aux.Next(og) do
        local e1=Effect.CreateEffect(oc)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        oc:RegisterEffect(e1,true)
      end
      if #codes>0 then
        local e2=Effect.GlobalEffect()
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
        e2:SetReset(RESET_PHASE+PHASE_END)
        e2:SetTargetRange(1,1)
        e2:SetTarget(function(e,c)
          return c:IsCode(table.unpack(codes))
        end)
        Duel.RegisterEffect(e2,tp)
      end
      if needShuffle then
        Duel.ShuffleDeck(tp)
      end
      Duel.BreakEffect()
      Duel.Draw(tp,1,REASON_RULE)
    end
  end)
  e1:SetCountLimit(1,10001)
  grantDecktop(e1)
end
