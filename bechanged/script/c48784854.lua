--光の継承
local s,id,o=GetID()
function c48784854.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(48784854,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,48784854)
	e2:SetCondition(c48784854.drcon)
	e2:SetTarget(c48784854.drtg)
	e2:SetOperation(c48784854.drop)
	c:RegisterEffect(e2)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(48784854,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,48784854+1)
	e3:SetTarget(c48784854.sumtg)
	e3:SetOperation(c48784854.sumop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(48784854,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,48784854+2)
	e4:SetCondition(c48784854.descon)
	e4:SetTarget(c48784854.destg)
	e4:SetOperation(c48784854.desop)
	c:RegisterEffect(e4)
	--draw 2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(48784854,0))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,48784857)
	e5:SetCondition(c48784854.drcon1)
	e5:SetTarget(c48784854.drtg)
	e5:SetOperation(c48784854.drop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(48784854,0))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,48784857)
	e6:SetCondition(c48784854.drcon2)
	e6:SetTarget(c48784854.drtg)
	e6:SetOperation(c48784854.drop)
	c:RegisterEffect(e6)
end
function c48784854.typfilter(c,sumtype)
	return c:IsFaceup() and c:GetType()&sumtype>0
end
function c48784854.cfilter(c,tp)
	local sumtype=bit.band(c:GetType(),TYPE_RITUAL|TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ)
	return c:IsFaceup()
		and (c:IsSummonType(SUMMON_TYPE_RITUAL) or c:IsSummonType(SUMMON_TYPE_FUSION)
			or c:IsSummonType(SUMMON_TYPE_SYNCHRO) or c:IsSummonType(SUMMON_TYPE_XYZ) )
		and Duel.IsExistingMatchingCard(c48784854.typfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,sumtype)
end
function c48784854.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c48784854.cfilter,1,nil,tp)
end
function c48784854.cfilter1(c)
	return c:IsFaceup() and (c:IsSummonType(SUMMON_TYPE_PENDULUM) or c:IsSummonType(SUMMON_TYPE_LINK))
end
function c48784854.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c48784854.cfilter1,1,nil)
end
function c48784854.cfilter2(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c48784854.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c48784854.cfilter2,1,nil)
end
function c48784854.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c48784854.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c48784854.sumfilter(c)
	return c:IsSetCard(0xf9) and c:IsSummonable(true,nil,1)
end
function c48784854.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c48784854.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c48784854.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c48784854.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end
function c48784854.filter(c,tp)
	return (c:IsCode(13035077))
		and not c:IsForbidden() and c:CheckUniqueOnField(tp) and  c:GetActivateEffect():IsActivatable(tp,true,true) and c:IsType(TYPE_FIELD)
end
function c48784854.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c48784854.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c48784854.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c48784854.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	local g=Duel.SelectMatchingCard(tp,c48784854.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.ResetFlagEffect(tp,15248873)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
		Duel.ResetFlagEffect(tp,15248873)
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		    if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			local act=Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	    tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCondition(s.con)
		e1:SetValue(s.actlimit)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SSET)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetCondition(s.con)
		e2:SetTarget(s.setlimit)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.ccfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(id)~=0
end
function s.con(e)
	return Duel.IsExistingMatchingCard(s.ccfilter,0,LOCATION_FZONE,0,1,nil)
end
function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFlagEffect(id)==0
end
function s.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD) and c:GetFlagEffect(id)==0
end