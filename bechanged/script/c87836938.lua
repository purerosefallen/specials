--ヴァイロン・ヴァンガード
---@param c Card
function c87836938.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87836938,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c87836938.drcon)
	e1:SetTarget(c87836938.drtg)
	e1:SetOperation(c87836938.drop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c87836938.spcon)
	e2:SetTarget(c87836938.sptg)
	e2:SetOperation(c87836938.spop)
	c:RegisterEffect(e2)
end
function c87836938.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():GetCount()>0
end
function c87836938.spfilter(c,e,tp)
	return c:IsCode(87836938) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c87836938.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c87836938.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c87836938.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c87836938.spfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c87836938.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local et=c:GetEquipCount()
	if et>0 and c:IsPreviousLocation(LOCATION_ONFIELD) then
		e:SetLabel(et)
		return true
	else return false end
end
function c87836938.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,e:GetLabel()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c87836938.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
