-- ヒーロー・マスク
function c75141056.initial_effect(c)
    local elast = nil
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c75141056.target)
    e1:SetOperation(c75141056.activate)
    e1:SetLabelObject(elast)
    elast = e1
    c:RegisterEffect(e1)
end
function c75141056.tgfilter(c)
    return c:IsFaceup() and
               Duel.IsExistingMatchingCard(c75141056.cfilter, c:GetControler(), LOCATION_DECK, 0, 1, nil, c)
end
function c75141056.cfilter(c, tc)
    return c:IsSetCard(0x3008) and not c:IsCode(tc:GetCode()) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c75141056.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c75141056.tgfilter(chkc)
    end
    if chk == 0 then
        return Duel.IsExistingTarget(c75141056.tgfilter, tp, LOCATION_MZONE, 0, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
    Duel.SelectTarget(tp, c75141056.tgfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
end
function c75141056.activate(e, tp, eg, ep, ev, re, r, rp)
    local elast = nil
    local tc = Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, c75141056.cfilter, tp, LOCATION_DECK, 0, 1, 1, nil, tc)
    if g:GetCount() > 0 then
        local gc = g:GetFirst()
        if Duel.SendtoGrave(gc, REASON_EFFECT) ~= 0 and gc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) and
            tc:IsFaceup() then
            local e1 = Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_CODE)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
            e1:SetValue(gc:GetCode())
            e1:SetLabelObject(elast)
            elast = e1
            tc:RegisterEffect(e1)
            if not tc:IsImmuneToEffect(e) then
                local e_reset = Effect.CreateEffect(e:GetHandler())
                e_reset:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
                e_reset:SetCode(EVENT_PHASE + PHASE_END)
                e_reset:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
                e_reset:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e_reset:SetCountLimit(1)
                e_reset:SetLabelObject(elast)
                e_reset:SetOperation(c75141056.rstop)
                Duel.RegisterEffect(e_reset,tp)
            end
        end
    elseif Duel.IsPlayerCanDiscardDeck(tp, 1) then
        local cg = Duel.GetFieldGroup(tp, LOCATION_DECK, 0)
        Duel.ConfirmCards(1 - tp, cg)
        Duel.ConfirmCards(tp, cg)
        Duel.ShuffleDeck(tp)
    end
end

function c75141056.rstop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local ecur = e:GetLabelObject()
    local tc = ecur:GetHandler()
    if tc:GetLocation() ~= LOCATION_MZONE or tc:GetPosition()&POS_FACEUP == 0 then return end
    local elast = nil
    while ecur do
        elast = ecur
        ecur = ecur:GetLabelObject()
        elast:Reset()
    end
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED, 1 - tp, 1162)
end
