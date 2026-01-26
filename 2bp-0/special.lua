-- Permanent effect: All monsters gain +1000 ATK during battle phase

MONSTERATKBOOST = {}

function Auxiliary.PreloadUds()
    -- Global field effect to boost all monsters' ATK during battle phase
    local e1 = Effect.GlobalEffect()
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetValue(1000)
    e1:SetCondition(MONSTERATKBOOST.Condition)
    Duel.RegisterEffect(e1,0)

    local e2 = Effect.GlobalEffect()
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetValue(1000)
    e2:SetCondition(MONSTERATKBOOST.Condition)
    Duel.RegisterEffect(e2,1)
end

function MONSTERATKBOOST.Condition(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer() and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
