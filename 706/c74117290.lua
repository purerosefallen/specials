-- 暗黒界の取引
---@param c Card
function c74117290.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_HANDES + CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c74117290.target)
    e1:SetOperation(c74117290.activate)
    c:RegisterEffect(e1)
end
function c74117290.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsPlayerCanDraw(tp, 1) and Duel.IsPlayerCanDraw(1 - tp, 1)
    end
    Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, PLAYER_ALL, 1)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, PLAYER_ALL, 1)
end
function c74117290.activate(e, tp, eg, ep, ev, re, r, rp)
    local h1 = Duel.Draw(tp, 1, REASON_EFFECT)
    local h2 = Duel.Draw(1 - tp, 1, REASON_EFFECT)
    if h1 > 0 or h2 > 0 then
        Duel.BreakEffect()
    end
    local g1 = Group.CreateGroup()
	local g2 = Group.CreateGroup()
    if h1 > 0 then
        Duel.ShuffleHand(tp)
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
        g1 = Duel.SelectMatchingCard(tp, Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, 1, nil)
    end
    if h2 > 0 then
        Duel.ShuffleHand(1 - tp)
        Duel.Hint(HINT_SELECTMSG, 1 - tp, HINTMSG_DISCARD)
        g2 = Duel.SelectMatchingCard(1 - tp, Card.IsDiscardable, 1 - tp, LOCATION_HAND, 0, 1, 1, nil)
    end
    if g1:GetCount() ~= 0 then
        Duel.SendtoGrave(g1, REASON_EFFECT + REASON_DISCARD)
    end
    if g2:GetCount() ~= 0 then
        Duel.SendtoGrave(g2, REASON_EFFECT + REASON_DISCARD)
    end
end
