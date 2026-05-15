--先史遗产 太阳独石碑
function c93543806.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93543806,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c93543806.lvcost)
	e1:SetTarget(c93543806.lvtg)
	e1:SetOperation(c93543806.lvop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(93543806,ACTIVITY_SPSUMMON,c93543806.counterfilter)
	--sp proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e2:SetCountLimit(1,93543806+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c93543806.spcon)
	e2:SetTarget(c93543806.sptg)
	e2:SetOperation(c93543806.spop)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)
end


function c93543806.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(93543806,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c93543806.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c93543806.lvfilter(c,lv)
	return c:IsFaceup() and c:IsSetCard(0x70) and not c:IsLevel(lv)
	and c:IsLevelAbove(1)
end
function c93543806.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c93543806.lvfilter(chkc,lv) end
	if chk==0 then return lv>0 and Duel.IsExistingTarget(c93543806.lvfilter,tp,LOCATION_MZONE,0,1,c,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c93543806.lvfilter,tp,LOCATION_MZONE,0,1,1,c,lv)
end
function c93543806.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e)
		and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsLevel(c:GetLevel()) then
		local g=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(93543806,2))
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		g:RemoveCard(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(tc:GetLevel())
		g:GetFirst():RegisterEffect(e1)
	end
end

function c93543806.cfilter(c,tp)
	return c:IsSetCard(0x70) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0
end
function c93543806.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c93543806.cfilter,tp,LOCATION_ONFIELD,0,1,c,tp,Card.IsReleasable)
end
function c93543806.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c93543806.cfilter,tp,LOCATION_ONFIELD,0,c,tp,Card.IsReleasable)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c93543806.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c93543806.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end


function c93543806.counterfilter(c)
	return c:IsSetCard(0x70)
end
function c93543806.splimit(e,c)
	return not c:IsSetCard(0x70)
end