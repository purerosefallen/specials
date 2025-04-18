--転生炎獣の聖域
function c1295111.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1295111)
	e1:SetOperation(c1295111.activate)
	c:RegisterEffect(e1)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1295111,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,1295112)
	e2:SetCondition(c1295111.linkcon)
	e2:SetOperation(c1295111.linkop)
	e2:SetValue(SUMMON_TYPE_LINK)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c1295111.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1295111,1))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCountLimit(1,1295113)
	e4:SetCondition(c1295111.atkcon)
	e4:SetTarget(c1295111.atktg)
	e4:SetOperation(c1295111.atkop)
	c:RegisterEffect(e4)
end
function c1295111.thfilter(c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1295111.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1295111.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1295111,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c1295111.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c1295111.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLocation(LOCATION_EXTRA)
end
function c1295111.lmfilter(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsLinkCode(lc:GetCode()) and c:IsLinkType(TYPE_LINK)
		and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL)
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function c1295111.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c1295111.lmfilter,tp,LOCATION_MZONE,0,1,nil,c,tp,og,lmat)
end
function c1295111.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,c1295111.lmfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_LINK)
end
function c1295111.mattg(e,c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_LINK)
end
function c1295111.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsControler(1-tp) then a=Duel.GetAttackTarget() end
	return a
end
function c1295111.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c1295111.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and not c:IsAttack(0)
end
function c1295111.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1295111.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1295111.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1295111.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local rec=g:GetFirst():GetBaseAttack()
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c1295111.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local lp=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.Recover(tp,lp,REASON_EFFECT)
	end
end
