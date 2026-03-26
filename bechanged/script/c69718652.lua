--聖霊獣騎 ノチウドラゴ
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon times limit
	c:SetSPSummonOnce(id)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x10b5),aux.FilterBoolFunction(Card.IsFusionSetCard,0x20b5),true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--can not be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.etlimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.chop)
	c:RegisterEffect(e3)
end
function s.etlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKTOP,REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xb5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsExistingTarget(s.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectTarget(tp,s.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function s.sfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb5) and c:IsAbleToRemove()
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetTargetsRelateToChain():GetFirst()
	if not tc then return end
	local ch=Duel.GetCurrentChain()
	local p,te=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT)
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_DECK,0,1,nil)
		and p~=tp and te:IsActiveType(TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ch-1,g)
		Duel.ChangeChainOperation(ch-1,s.repop) 
	end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(1-tp,s.sfilter,tp,0,LOCATION_DECK,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
