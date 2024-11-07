--トリックスター・デビルフィニウム
function c3792766.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xfb),1)
	c:EnableReviveLimit()
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c3792766.lmlimit)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c3792766.thcon)
	e2:SetTarget(c3792766.thtg)
	e2:SetOperation(c3792766.thop)
	c:RegisterEffect(e2)
end
function c3792766.lmlimit(e)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	local flag = true
	if (ct==1) then
		flag = true
	else
		flag = false
	end
	print(flag)
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK) and flag
end
function c3792766.lkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfb)
end
function c3792766.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroup():IsExists(c3792766.lkfilter,1,nil)
end
function c3792766.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfb) and c:IsAbleToHand()
end
function c3792766.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c3792766.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c3792766.filter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_LINK)	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_LINK)
	local g=Duel.SelectTarget(tp,c3792766.filter,tp,LOCATION_REMOVED,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c3792766.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		if ct>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			e1:SetValue(ct*1000)
			c:RegisterEffect(e1)
		end
	end
end
