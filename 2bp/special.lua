function aux.PreloadUds()
  local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BP_TWICE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)
end
