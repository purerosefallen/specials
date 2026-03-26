--スター・ブラスト
---@param c Card
function c67196946.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c67196946.cost)
	e1:SetTarget(c67196946.tg)
	e1:SetOperation(c67196946.op)
	c:RegisterEffect(e1)
end
function c67196946.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500,true) end
	local lp=Duel.GetLP(tp)
	local g=Duel.GetMatchingGroup(Card.IsLevelAbove,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,2)
	local tg=g:GetMaxGroup(Card.GetLevel)
	local maxlv=math.min(tg:GetFirst():GetLevel(),255)
	local t={}
	local l=1
	while l<maxlv and l*500<=lp do
		t[l]=l*500
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67196946,0))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,announce,true)
	e:SetLabel(announce/500)
end
function c67196946.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLevelAbove,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,2) end
end
function c67196946.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsLevelAbove,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,ct+1)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67196946,1))
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc:IsLocation(LOCATION_MZONE) then
			Duel.HintSelection(sg)
		end
		Duel.ConfirmCards(1-tp,sg)
		if tc:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(tp) end
        local elast = nil
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		e1:SetValue(-ct)
        e1:SetLabelObject(elast)
		elast=e1
		tc:RegisterEffect(e1)
		if not tc:IsImmuneToEffect(e) then
			local e_reset=Effect.CreateEffect(e:GetHandler())
			e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e_reset:SetCode(EVENT_PHASE+PHASE_END)
			e_reset:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
			e_reset:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e_reset:SetCountLimit(1)
			e_reset:SetLabelObject(elast)
			e_reset:SetRange(LOCATION_MZONE+LOCATION_HAND)
			e_reset:SetOperation(c67196946.rstop)
			Duel.RegisterEffect(e_reset,tp)
		end
	end
end
function c67196946.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local ecur = e:GetLabelObject()
	local tc = ecur:GetHandler()
	if tc:GetLocation() ~= LOCATION_MZONE or tc:GetPosition()&POS_FACEUP == 0 then return end
	local elast = nil
	while ecur do
		elast = ecur
		ecur = ecur:GetLabelObject()
		elast:Reset()
	end
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,1-tp,1162)
end