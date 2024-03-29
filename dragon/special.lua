local function __isOriginalRace(c,r)
	local t=c:GetOriginalRace()
	return t&r~=0
end

local function cond(c)
	return __isOriginalRace(c,RACE_DRAGON) and not c:IsCode(65326118,39931513,91810826)
end

function Auxiliary.PreloadUds()
	-- battle
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(function(e,c)
		return not __isOriginalRace(c,RACE_WINDBEAST+RACE_DRAGON)
	end)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(function(e,c)
		return cond(c)
	end)
	Duel.RegisterEffect(e1,0)
	-- effect
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(function(e,te)
		return te:IsActiveType(TYPE_MONSTER) and not __isOriginalRace(te:GetHandler(),RACE_WINDBEAST+RACE_DRAGON)
	end)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(function(e,c)
		return cond(c) and c:IsFaceup()
	end)
	Duel.RegisterEffect(e2,0)
	-- AOJ thing
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e3:SetDescription(aux.Stringid(811734,0))
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local tc=Duel.GetAttacker()
		if tc==c then tc=Duel.GetAttackTarget() end
		if chk==0 then return tc and tc:IsFaceup() and not __isOriginalRace(tc,RACE_WINDBEAST+RACE_DRAGON) end
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetAttacker()
		if tc==c then tc=Duel.GetAttackTarget() end
		if tc:IsRelateToBattle() then Duel.Remove(tc,POS_FACEUP,REASON_RULE) end
	end)
	local ge3=Effect.GlobalEffect()
	ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	ge3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ge3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ge3:SetTarget(function(e,c)
		return cond(c) and c:IsFaceup()
	end)
	ge3:SetLabelObject(e3)
	Duel.RegisterEffect(ge3,0)
end
