--[[
OPT (Once Per Turn) UI Hint System
===================================

PURPOSE:
Display "OPT used this turn" hint on all matching card copies when any copy activates a once-per-turn effect.

HOW IT WORKS:
1. Hijack Effect.SetCountLimit and Effect.SetCost globally
2. When SetCountLimit(1, code) is called, mark for hooking and store 'code' as label
3. When effect is activated, wrap the cost function to register flag on all matching cards
4. Flag displays as client hint (visual indication) and resets at end of turn

ARCHITECTURE:
- hooked_effects: weak table tracking which effects have been wrapped (auto-GC)
- Effect.SetCountLimit: initiates hooking for count==1 effects
- Effect.SetCost: allows re-hooking if real cost arrives after initial nil cost wrap
- OptUI.AddHook: captures card_id as closure, wraps effect's cost function with MarkUsed callback
- OptUI.MarkUsed: finds all matching card copies by original code and registers effect flag

SCENARIOS SUPPORTED:
1. SetCountLimit(1,code) → SetCost(real_cost)
   - SetCountLimit: Sets label=code, marks hooked, calls AddHook (captures nil cost)
   - SetCost: Detects label+hooked, applies real cost, re-calls AddHook (re-captures real cost)
   - Result: Wrapper has correct real cost before effect activation

2. SetCost(real_cost) → SetCountLimit(1,code)
   - SetCost: label=0, no hooking occurs
   - SetCountLimit: label set, calls AddHook (cost already applied, captures correctly)
   - Result: SetCountLimit initiates hooking with real cost ready

3. SetCountLimit(1,code) only (no SetCost)
   - SetCountLimit: Sets label=code, marks hooked, calls AddHook (captures nil cost)
   - SetCost never called
   - Cost check: `orig_cost and ... or true` evaluates to true (always passable)
   - Result: Effect can be activated, hint registered correctly

4. SetCountLimit(1,code) → SetCost(cost1) → SetCost(cost2)
   - SetCountLimit: Hooks with nil, captures nil
   - SetCost(cost1): Detects hooked, applies cost1, re-hooks (captures cost1)
   - SetCost(cost2): Detects hooked, applies cost2, re-hooks (captures cost2)
   - Result: Final wrapper uses most recent cost2

FLAG REGISTRATION:
- Card ID: captured at hook time from effect handler's original code (immutable closure)
- Registered on: all cards with matching original code, in any zone, this player's side
- Reset rule: RESET_PHASE + PHASE_END (automatically clears at end of turn)
- Effect type: EFFECT_FLAG_CLIENT_HINT (displays visual hint)
- Description: comes from effect's SetDescription() call
]]

--OPT UI State Management
--Register hints on card copies when effect is used

OptUI = OptUI or {}

--Track which effects have been hooked
local hooked_effects = setmetatable({}, {__mode = "k"})
local orig_setcountlimit = Effect.SetCountLimit
local orig_setcost = Effect.SetCost

--Hijack SetCountLimit to auto-hook OPT effects
function Effect.SetCountLimit(e, count, code, ...)
	orig_setcountlimit(e, count, code, ...)
	if count == 1 and code and not hooked_effects[e] then
		e:SetLabel(code)
		hooked_effects[e] = true
		OptUI.AddHook(e, code)
	end
	return e
end

--Hijack SetCost to re-hook with real cost if SetCountLimit hooked with nil first
function Effect.SetCost(e, cost, ...)
	local code = e:GetLabel()
	if code ~= 0 and hooked_effects[e] and cost then
		orig_setcost(e, cost, ...)
		OptUI.AddHook(e, code)
	else
		orig_setcost(e, cost, ...)
	end
	return e
end

function OptUI.AddHook(effect, effect_key, desc)
	if not desc then
		desc = effect:GetDescription()
	end
	local orig_cost = effect:GetCost()
	local function new_cost(e, tp, eg, ep, ev, re, r, rp, chk)
		if chk == 0 then
			if orig_cost then
				return orig_cost(e, tp, eg, ep, ev, re, r, rp, 0)
			else
				return true
			end
		end
		local card_id = e:GetHandler():GetOriginalCode()
		OptUI.MarkUsed(effect_key, desc, card_id, tp)
		if orig_cost then orig_cost(e, tp, eg, ep, ev, re, r, rp, 1) end
	end
	orig_setcost(effect, new_cost)
end

function OptUI.MarkUsed(effect_key, desc, card_id, tp)
	local g = Duel.GetMatchingGroup(function(c) return c:GetOriginalCode() == card_id end, tp, 0xff, 0, nil)
	for tc in aux.Next(g) do
		if tc:GetFlagEffect(effect_key) == 0 then
			tc:RegisterFlagEffect(effect_key, RESET_PHASE + PHASE_END, EFFECT_FLAG_CLIENT_HINT, 1, 0, desc)
		end
	end
end
