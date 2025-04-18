--蒸汽旋翼机人
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,18325492,44729197,1,true,true) 
	--fusioncon  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(s.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--copy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e4:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_CHAIN_END+TIMING_END_PHASE)
	e4:SetCondition(s.condition)
	e4:SetCountLimit(1,id)
	e4:SetCost(s.cost)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
	end

----fusioncon
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end

----0zhenronghe
function s.mfilter(c,sc)
	return c:IsFusionSetCard(0x16) and c:IsFusionType(TYPE_MONSTER)and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function s.mfilter2(c,sc)
	return c:IsFusionSetCard(0x16) and c:IsFusionType(TYPE_MONSTER)and not c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function s.fselect(g)
	return g:IsExists(aux.NecroValleyFilter(s.mfilter2),1,nil)
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.mfilter),tp,LOCATION_GRAVE+LOCATION_MZONE,0,2,nil,c) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.mfilter2),tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,c)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.mfilter),tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,c)
	if chk==0 then return g:CheckSubGroup(s.fselect,2,2,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=g:SelectSubGroup(tp,s.fselect,false,2,2,c)
	c:SetMaterial(g1)
	Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_COST)
end

----indes
function s.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x16)
end
function s.indcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return ct==Duel.GetMatchingGroupCount(s.indfilter,tp,LOCATION_MZONE,0,nil)
end

----counter
function s.cfilter(c)
	return c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_MZONE,0,nil)==0
end
function s.filter(c)
	return (c:GetType()==TYPE_TRAP or c:GetType()==TYPE_TRAP+TYPE_COUNTER) and c:IsSetCard(0x16) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
	
