--虹之古代都市
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to p|s zone
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,4))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_FZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(s.tstg)
	e0:SetOperation(s.tsop)
	c:RegisterEffect(e0)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.desrepcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.discon)
	e3:SetCost(s.discost)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.drcon)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.spcon)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	--damage reduce
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e6:SetCondition(s.rdcon)
	e6:SetOperation(s.rdop)
	c:RegisterEffect(e6) 
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCode(EFFECT_CHANGE_DAMAGE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
    e7:SetCondition(s.rdcon)
	e7:SetValue(s.val)
	c:RegisterEffect(e7)
end
--to sone
function s.tsfilter(c)
	return c:IsSetCard(0x1034) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.penfilter(c)
	return c:IsSetCard(0x34) and c:IsType(TYPE_PENDULUM)  and not c:IsForbidden()
end
function s.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(s.tsfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
    or (Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)))
    end
end
function s.tsop(e,tp,eg,ep,ev,re,r,rp)
    local b1=Duel.IsExistingMatchingCard(s.tsfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=0
    local b2=Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
    if not b1 or not b2 then return false end
    local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,5)},{b2,aux.Stringid(id,6)})
    if op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,s.tsfilter,tp,LOCATION_DECK,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetCode(EFFECT_CHANGE_TYPE)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
            e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
            tc:RegisterEffect(e1)
        end
    end
    if op==2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,s.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
    end
end
--disable
function s.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1034)
end
function s.desrepcon(e)
	return Duel.IsExistingMatchingCard(s.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,1,nil)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_SZONE,0,3,nil,0x1034)
end
function s.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x1034) and c:IsAbleToGraveAsCost()
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_SZONE,0,4,nil)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--draw
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--special
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_SZONE,0,5,nil)
end
function s.filter3(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1034) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ct=Duel.GetMatchingGroupCount(s.filter3,tp,LOCATION_SZONE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.filter3(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter3,tp,LOCATION_SZONE,0,1,nil,e,tp) end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>=ct then ft=ct end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter3,tp,LOCATION_SZONE,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or ft<=0 or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if ft<g:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
--half damage
function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_SZONE,0,2,nil)
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.ChangeBattleDamage(tp,math.floor(ev/2))
	end
end
function s.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		return math.floor(dam/2)
	else return dam end
end