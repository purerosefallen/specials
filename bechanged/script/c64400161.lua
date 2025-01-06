--飛竜艇－ファンドラ
---@param c Card
function c64400161.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c64400161.indcon)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--indes
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(3,64400161)
	e2:SetCost(c64400161.cost)
	e2:SetTarget(c64400161.target)
	e2:SetOperation(c64400161.operation)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c64400161.drcon)
	e3:SetTarget(c64400161.drtg)
	e3:SetOperation(c64400161.drop)
	c:RegisterEffect(e3)
end
function c64400161.drfilter(c,tp)
	return c:IsSetCard(0x114) and c:IsPreviousLocation(LOCATION_HAND) and c:IsFaceup()
end
function c64400161.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c64400161.drfilter,1,nil,tp)
end
function c64400161.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c64400161.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c64400161.costfilter(c,e,tp)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsSetCard(0x114) and Duel.GetMZoneCount(tp,c)>0
		and (c:IsLevelBelow(4) and Duel.IsExistingMatchingCard(c64400161.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		or (c:IsLevelAbove(5) and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil,true)))
end
function c64400161.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64400161.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c64400161.costfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabel(g:GetFirst():GetPreviousLevelOnField())
end
function c64400161.filter(c,e,tp)
	return c:IsSetCard(0x114) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c64400161.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c64400161.operation(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if lv<=4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c64400161.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if lv>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.GetControl(g:GetFirst(),tp,PHASE_END,1)
		end
	end
end
function c64400161.cfilter(c)
	return c:IsSetCard(114) and c:IsFaceup()
end
function c64400161.indcon(e)
	return Duel.IsExistingMatchingCard(c64400161.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end