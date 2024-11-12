--魔導天士 トールモンド
function c29146185.initial_effect(c)
	--ss success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29146185,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c29146185.retcon)
	e1:SetTarget(c29146185.rettg)
	e1:SetOperation(c29146185.retop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29146185,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_CUSTOM+29146185)
	e2:SetCost(c29146185.descost)
	e2:SetTarget(c29146185.destg)
	e2:SetOperation(c29146185.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29146185,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCost(c29146185.cpcost)
	e3:SetTarget(c29146185.cptg)
	e3:SetOperation(c29146185.cpop)
	c:RegisterEffect(e3)
end
function c29146185.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ,race=c:GetSpecialSummonInfo(SUMMON_INFO_TYPE,SUMMON_INFO_RACE)
	return (typ&TYPE_MONSTER~=0 and race&RACE_SPELLCASTER~=0) or (typ&TYPE_SPELL~=0)
end
function c29146185.filter(c)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c29146185.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c29146185.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29146185.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c29146185.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c29146185.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+29146185,re,r,rp,0,0)
		end
	end
end
function c29146185.cffilter(c)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function c29146185.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c29146185.cffilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:SelectSubGroup(tp,aux.dncheck,false,4,4)
	Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
end
function c29146185.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c29146185.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(g,REASON_EFFECT)
end
function c29146185.cpfilter(c)
	return (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsSetCard(0x106e) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c29146185.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c29146185.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c29146185.cpfilter,tp,LOCATION_HAND,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c29146185.cpfilter,tp,LOCATION_HAND,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c29146185.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end