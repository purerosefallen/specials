--トゥーン・キングダム
function c43175858.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43175858.target)
	e1:SetOperation(c43175858.activate)
	c:RegisterEffect(e1)
	--change code
	aux.EnableChangeCode(c,15259703,LOCATION_FZONE)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOON))
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c43175858.reptg)
	e4:SetValue(c43175858.repval)
	c:RegisterEffect(e4)
end
function c43175858.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==3 end
end
function c43175858.thfilter(c)
	return c:IsSetCard(0x62) and c:IsAbleToHand()
end
function c43175858.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,3) then
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(c43175858.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43175858,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c43175858.thfilter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
			end
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REVEAL)
		end
	end
end
function c43175858.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsType(TYPE_TOON) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c43175858.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=eg:Filter(c43175858.repfilter,nil,tp)
	if chk==0 then return cg:GetCount()>0 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.SendtoHand(cg,nil,REASON_EFFECT)
		return true
	else return false end
end
function c43175858.repval(e,c)
	return c43175858.repfilter(c,e:GetHandlerPlayer())
end