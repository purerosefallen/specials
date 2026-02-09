-- House Rules Duel: Start Protection
-- In this duel, special protections are applied at the start of the duel.
-- For the first turn, if a player’s Deck has fewer than 16 cards:
--   ・That player cannot add cards from their Deck to their hand.
--   ・That player cannot draw cards by card effects (their normal Draw Phase draw is still allowed).
-- For the first 2 turns, effect damage inflicted to either player becomes 0.

StartProtection=StartProtection or {}

------------------------------------------------------------
-- configuration
------------------------------------------------------------
StartProtection.DECK_MIN      = 16
StartProtection.SEARCH_TURNS  = 1
StartProtection.DMG_TURNS     = 2

function Auxiliary.PreloadUds()
	------------------------------------------------------------
	-- Effect damage becomes 0
	-- (applies during Turn 1 and Turn 2 only)
	------------------------------------------------------------
	local e_dmg_0=Effect.GlobalEffect()
	e_dmg_0:SetType(EFFECT_TYPE_FIELD)
	e_dmg_0:SetCode(EFFECT_CHANGE_DAMAGE)
	e_dmg_0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e_dmg_0:SetTargetRange(1,1)
	e_dmg_0:SetValue(StartProtection.damval)
	e_dmg_0:SetReset(RESET_PHASE+PHASE_END,StartProtection.DMG_TURNS)
	Duel.RegisterEffect(e_dmg_0,0)
	local e_dmg=Effect.GlobalEffect()
	e_dmg:SetType(EFFECT_TYPE_FIELD)
	e_dmg:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e_dmg:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e_dmg:SetTargetRange(1,1)
	e_dmg:SetReset(RESET_PHASE+PHASE_END,StartProtection.DMG_TURNS)
	Duel.RegisterEffect(e_dmg,0)

	for tp=0,1 do
		-- no add from Deck to hand if Deck < DECK_MIN
		local e_th=Effect.GlobalEffect()
		e_th:SetType(EFFECT_TYPE_FIELD)
		e_th:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e_th:SetCode(EFFECT_CANNOT_TO_HAND)
		e_th:SetTargetRange(1,0)
		e_th:SetCondition(StartProtection.deck_con)
		e_th:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
		e_th:SetReset(RESET_PHASE+PHASE_END,StartProtection.SEARCH_TURNS)
		Duel.RegisterEffect(e_th,tp)
		-- no draw by card effects if Deck < DECK_MIN
		local e_nd=Effect.GlobalEffect()
		e_nd:SetType(EFFECT_TYPE_FIELD)
		e_nd:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e_nd:SetCode(EFFECT_CANNOT_DRAW)
		e_nd:SetTargetRange(1,0)
		e_nd:SetCondition(StartProtection.deck_con)
		e_nd:SetValue(1)
		e_nd:SetReset(RESET_PHASE+PHASE_END,StartProtection.SEARCH_TURNS)
		Duel.RegisterEffect(e_nd,tp)
	end
end

function StartProtection.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end

function StartProtection.deck_con(e)
	local tp=e:GetOwnerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<StartProtection.DECK_MIN
end
