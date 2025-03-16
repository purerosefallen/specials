--凶邪魔玩具·梦魇玛丽
--デンジャラス・デストーイ・ナイトメアリー
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc3),aux.FilterBoolFunction(Card.IsFusionSetCard,0xa9),2,2,true)
	--特殊召唤规则
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)

	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.value)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(s.tgcon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.discon)
	e3:SetCost(s.discost)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
end
--特殊召唤规则处理--
function s.spfilter0(c)
	return c:IsFusionSetCard(0xc3) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function s.spfilter1(c)
	return c:IsFusionSetCard(0xa9) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function s.fufilter(c)
	return c:IsCode(24094653) and c:IsAbleToRemoveAsCost()
end

function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMatchingGroupCount(s.spfilter0,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND,0,nil)>0
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.GetMatchingGroupCount(s.spfilter1,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND,0,nil)>=2
	and Duel.IsExistingMatchingCard(s.fufilter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g0=Duel.GetMatchingGroup(s.spfilter0,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local fug=Duel.GetMatchingGroup(s.fufilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND,0,nil)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg0=g0:SelectSubGroup(tp,function() return true end ,true,1,1)
	local sg1=g1:SelectSubGroup(tp,function() return true end ,true,2,2)
	local sgfu=fug:SelectSubGroup(tp,function() return true end ,true,1,1)
	if sg1 and sg0 and sgfu then
		sg0:Merge(sg1)
		sg0:Merge(sgfu)
		sg0:KeepAlive()
		e:SetLabelObject(sg0)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_SPSUMMON)
	g:DeleteGroup()
end


function s.atkfilter(c)
	return c:IsRace(RACE_FAIRY+RACE_FIEND)
end
function s.value(e,c)
	local tp=c:GetControler()
	if Duel.GetTurnPlayer()~=tp then return 0 end
	return Duel.GetMatchingGroupCount(s.atkfilter,tp,LOCATION_GRAVE,0,nil)*300
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.bdocon(e,tp,eg,ep,ev,re,r,rp)
end
function s.tgfilter(c)
	return c:IsSetCard(0xc3,0xa9,0xad) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	local lv=bc:GetLevel()
	e:SetLabel(lv)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,lv,lv,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local lv=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,lv,lv,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function s.costfilter(c)
	return c:IsSetCard(0xad) and c:IsAbleToRemoveAsCost()
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and Duel.IsChainDisablable(ev)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
