--PSY骨架回路
local s,id,o=GetID()
function c575512.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(575512,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c575512.sccon)
	e2:SetTarget(c575512.sctg)
	e2:SetOperation(c575512.scop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(575512,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c575512.atkcon)
    e3:SetTarget(s.atktg)
	e3:SetOperation(c575512.atkop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CVAL_CHECK)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.rmcon)
	e4:SetTarget(s.rmtg)
	e4:SetOperation(s.rmop)
	c:RegisterEffect(e4)
end
--to hand
function s.filter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsControler(tp) and c:IsSetCard(0xc1)
end
function s.mgfilter(c,tp,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync
		and c:IsAbleToHand()
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp) and Duel.IsExistingMatchingCard(s.mgfilter,tp,LOCATION_GRAVE,0,1,nil,tp,eg:GetFirst()) 
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetCard(eg:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,2,tp,LOCATION_GRAVE)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	if mg:GetCount()==mg:FilterCount(aux.NecroValleyFilter(s.mgfilter),nil,tp,tc) then
		Duel.SendtoHand(mg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,mg)
	end
end
--
function c575512.scfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc1) and c:IsControler(tp)
end
function c575512.sccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c575512.scfilter,1,nil,tp)
end
function c575512.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetSynchroMaterial(tp):Filter(Card.IsSetCard,nil,0xc1)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c575512.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetSynchroMaterial(tp):Filter(Card.IsSetCard,nil,0xc1)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
function c575512.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	e:SetLabelObject(tc)
	return tc and tc:IsControler(tp) and tc:IsSetCard(0xc1) and tc:IsRelateToBattle() and Duel.GetAttackTarget()~=nil
end
function s.atkfilter(c)
	return c:IsSetCard(0xc1) and ((c:GetAttack()>0 and c:IsDiscardable() and c:IsLocation(LOCATION_HAND)) or (c:IsAbleToHand() and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)))
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
        Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE+CATEGORY_GRAVE_ACTION,nil,1,0,0)
end
function c575512.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.atkfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    local ttc=g:GetFirst()
    if ttc then
        if ttc:IsLocation(LOCATION_HAND) then
            Duel.SendtoGrave(ttc,REASON_EFFECT+REASON_DISCARD)
        elseif ttc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)  then
            Duel.SendtoHand(ttc,nil,REASON_EFFECT)
        end
        if ttc:IsType(TYPE_MONSTER) and ttc:GetAttack()>0 then
            if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(tp) then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(ttc:GetAttack())
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                tc:RegisterEffect(e1)
            end
        end
    end
end
