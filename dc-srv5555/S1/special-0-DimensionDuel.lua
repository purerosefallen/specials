--村规决斗：次元暗面
--怪兽的原本攻防变为卡片密码末位*500
function Auxiliary.PreloadUds()
    --Duel Start
    local e1=Effect.GlobalEffect()
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
    e1:SetOperation(function(e)
        local g=Duel.GetMatchingGroup(Card.IsType,0,0xff,0xff,nil,TYPE_MONSTER)
        local card=g:GetFirst()
        while card do
            --base attack
            local e1=Effect.CreateEffect(card)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_BASE_ATTACK)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_IGNORE_IMMUNE)
            e1:SetRange(0xff)
            e1:SetValue(card:GetOriginalCode() % 10 * 500)
            card:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_SET_BASE_DEFENSE)
            card:RegisterEffect(e2)
            card=g:GetNext()
        end
        e:Reset()
    end)
    Duel.RegisterEffect(e1,0)
end