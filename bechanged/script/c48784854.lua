--光の継承
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
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,48784854+2)
	e4:SetCondition(c48784854.descon)
	e4:SetTarget(c48784854.destg)
	e4:SetOperation(c48784854.desop)
	c:RegisterEffect(e4)
end
function c48784854.typfilter(c,sumtype)
	return c:IsFaceup() and c:GetType()&sumtype>0
end
function c48784854.cfilter(c,tp)
	local sumtype=bit.band(c:GetType(),TYPE_RITUAL|TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ)
	return c:IsFaceup()
		and (c:IsSummonType(SUMMON_TYPE_RITUAL) or c:IsSummonType(SUMMON_TYPE_FUSION)
			or c:IsSummonType(SUMMON_TYPE_SYNCHRO) or c:IsSummonType(SUMMON_TYPE_XYZ))
		and Duel.IsExistingMatchingCard(c48784854.typfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,sumtype)
end
function c48784854.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c48784854.cfilter,1,nil,tp)
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
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c48784854.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c48784854.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c48784854.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c48784854.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tc=Duel.SelectMatchingCard(tp,c48784854.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
	end
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) end
	tc:RegisterFlagEffect(48784854,RESET_EVENT+RESETS_STANDARD,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(c48784854.con)
	e1:SetValue(c48784854.actlimit)
	Duel.RegisterEffect(e1,tp)
end
function c48784854.cfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(48784854)~=0
end
function c48784854.con(e,tp)
	return Duel.IsExistingMatchingCard(c48784854.cfilter,e:GetHandlerPlayer(),LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c48784854.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFlagEffect(48784854)==0
end