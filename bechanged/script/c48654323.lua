--凶导的白圣骸
local s,id,o=GetID()
function c48654323.initial_effect(c)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(48654323,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c48654323.atkcon)
	e1:SetTarget(c48654323.atktg)
	e1:SetOperation(c48654323.atkop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c48654323.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(48654323,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,48654323)
	e3:SetCondition(c48654323.tgcon)
	e3:SetTarget(c48654323.tgtg)
	e3:SetOperation(c48654323.tgop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,4))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
    e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,id+o)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
function s.filter(c)
    return c:IsCode(60921537) and c:IsAbleToHand()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        Duel.BreakEffect()
        local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
        if #sg>0 then
            Duel.SendtoHand(sg,tp,REASON_EFFECT)
        end
	end
end

function c48654323.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c48654323.atktgfilter1(c,tp)
	return c:IsFaceup() and Duel.IsExistingTarget(c48654323.atktgfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c48654323.atktgfilter2(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c48654323.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c48654323.atktgfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c48654323.atktgfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c48654323.atktgfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g)
end
function c48654323.atkfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c48654323.atkupfilter(c,g)
	return g:FilterCount(c48654323.atktgfilter2,c)>0
end
function c48654323.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c48654323.atkfilter,nil,e)
	if #g==2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48654323,2))
		local hc=g:FilterSelect(tp,c48654323.atkupfilter,1,1,nil,g):GetFirst()
		if not hc then return end
		local tc=g:Filter(aux.TRUE,hc):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(tc:GetAttack())
		hc:RegisterEffect(e1)
	end
end
function c48654323.indtg(e,c)
	return c:IsSetCard(0x145) and c:IsLevelAbove(8)
end
function c48654323.tgfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsPreviousControler(1-tp)
end
function c48654323.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c48654323.tgfilter,1,nil,tp)
end
function c48654323.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c48654323.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #g==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
	Duel.SendtoGrave(tg,REASON_EFFECT)
	Duel.ShuffleExtra(1-tp)
end
