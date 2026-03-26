function aux.PreloadUds()
  local e1=Effect.GlobalEffect()
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PREDRAW)
  e1:SetCountLimit(1)
  e1:SetCondition(function() return Duel.GetTurnCount()==2 end)
  e1:SetOperation(function()
    local c=Duel.SelectMatchingCard(1,aux.TRUE,1,LOCATION_DECK,0,1,1,nil):GetFirst()
    if c then
      Duel.Hint(HINT_CARD,0,45809008)
      local already=Duel.GetDecktopGroup(1,1):GetFirst()
      if c==already then return end
      Duel.MoveSequence(c,SEQ_DECKTOP)
    end
  end)
  Duel.RegisterEffect(e1,0)
end
