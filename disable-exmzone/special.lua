function aux.PreloadUds()
local e1=Effect.GlobalEffect()
e1:SetType(EFFECT_TYPE_FIELD)
e1:SetCode(EFFECT_DISABLE_FIELD)
e1:SetValue(0x600060)
Duel.RegisterEffect(e1,0)
end
