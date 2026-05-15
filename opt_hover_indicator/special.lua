--[[
OPT (Once Per Turn) UI Hint System
===================================

PURPOSE:
Display "OPT used this turn" hint on all matching card copies when any copy activates a once-per-turn effect.
Effects without a description use placeholder 7 for the client hint text.

HOW IT WORKS:
1. Hijack Effect.SetCountLimit and Effect.SetCost globally
2. When SetCountLimit(1, code) is called, eligible shared OPT codes are stored in internal state
3. When effect is activated, wrap the cost function to register a dedicated hover flag on all matching cards
4. Flag displays as client hint (visual indication) and resets at end of turn

ARCHITECTURE:
- hooked_effects: weak table tracking which effects have been wrapped (auto-GC)
- effect_keys: weak table storing each effect's count-limit code without touching script labels
- flag_keys: maps OPT count-limit codes to dedicated OptUI flag ids
- Effect.SetCountLimit: initiates hooking for count==1 effects
- Effect.SetCost: allows re-hooking if real cost arrives after initial nil cost wrap
- OptUI.AddHook: captures card_id as closure, wraps effect's cost function with MarkUsed callback
- OptUI.MarkUsed: finds all matching card copies by original code and registers effect flag

HOOK ELIGIBILITY:
- `count` must be 1
- `code` must be greater than `EFFECT_COUNT_CODE_SINGLE`
- Effect labels are never used for internal bookkeeping

SCENARIOS SUPPORTED:
1. SetCountLimit(1, code) -> SetCost(real_cost)
   - SetCountLimit: stores code internally, marks hooked, calls AddHook (captures nil cost)
   - SetCost: detects stored code+hooked, applies real cost, re-calls AddHook (re-captures real cost)
   - Result: wrapper has correct real cost before effect activation

2. SetCost(real_cost) -> SetCountLimit(1, code)
   - SetCost: no stored code yet, so no hooking occurs
   - SetCountLimit: code stored, calls AddHook (cost already applied, captures correctly)
   - Result: SetCountLimit initiates hooking with real cost ready

3. SetCountLimit(1, code) only (no SetCost)
   - SetCountLimit: stores code internally, marks hooked, calls AddHook (captures nil cost)
   - SetCost never called
   - Cost check: `orig_cost and ... or true` evaluates to true (always passable)
   - Result: effect can be activated, hint registered correctly

4. SetCountLimit(1, code) -> SetCost(cost1) -> SetCost(cost2)
   - SetCountLimit: hooks with nil, captures nil
   - SetCost(cost1): detects stored code+hooked, applies cost1, re-hooks (captures cost1)
   - SetCost(cost2): detects stored code+hooked, applies cost2, re-hooks (captures cost2)
   - Result: final wrapper uses most recent cost2

FLAG REGISTRATION:
- Card ID: captured at hook time from effect handler's original code (immutable closure)
- Registered on: all cards with matching original code, in any zone, this player's side
- Reset rule: RESET_PHASE + PHASE_END (automatically clears at end of turn)
- Effect type: EFFECT_FLAG_CLIENT_HINT (displays visual hint)
- Description: comes from effect's SetDescription() call, or falls back to 7
- Flag id: uses an OptUI-owned namespace instead of the raw count-limit code
]]

--OPT UI State Management
--Register hints on card copies when effect is used

OptUI = OptUI or {}

--Track which effects have been hooked
local hooked_effects = setmetatable({}, {__mode = "k"})
local effect_keys = setmetatable({}, {__mode = "k"})
local flag_keys = {}
-- Keep OptUI flag ids out of the EFFECT_COUNT_CODE_* high-bit namespace.
local next_flag_key = 0x08000000
local orig_setcountlimit = Effect.SetCountLimit
local orig_setcost = Effect.SetCost

function OptUI.ShouldHookCountCode(code)
	return type(code) == "number" and code > 0 and code ~= EFFECT_COUNT_CODE_SINGLE
end

function OptUI.GetFlagKey(effect_key)
	local flag_key = flag_keys[effect_key]
	if not flag_key then
		flag_key = next_flag_key
		flag_keys[effect_key] = flag_key
		next_flag_key = next_flag_key + 1
	end
	return flag_key
end

--Hijack SetCountLimit to auto-hook OPT effects
function Effect.SetCountLimit(e, count, code, ...)
	orig_setcountlimit(e, count, code, ...)
	if count == 1 and OptUI.ShouldHookCountCode(code) and not hooked_effects[e] then
		effect_keys[e] = code
		hooked_effects[e] = true
		OptUI.AddHook(e, code)
	end
	return e
end

--Hijack SetCost to re-hook with real cost if SetCountLimit hooked with nil first
function Effect.SetCost(e, cost, ...)
	local code = effect_keys[e]
	if code and hooked_effects[e] and cost then
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
	if not desc or desc == 0 then
		desc = 7
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
		if orig_cost then
			orig_cost(e, tp, eg, ep, ev, re, r, rp, 1)
		end
	end
	orig_setcost(effect, new_cost)
end

function OptUI.MarkUsed(effect_key, desc, card_id, tp)
	local flag_key = OptUI.GetFlagKey(effect_key)
	local g = Duel.GetMatchingGroup(function(c) return c:GetOriginalCode() == card_id end, tp, 0xff, 0, nil)
	for tc in aux.Next(g) do
		if tc:GetFlagEffect(flag_key) == 0 then
			tc:RegisterFlagEffect(flag_key, RESET_PHASE + PHASE_END, EFFECT_FLAG_CLIENT_HINT, 1, 0, desc)
		end
	end
end
