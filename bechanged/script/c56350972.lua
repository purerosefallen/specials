--龙姬神 萨菲拉
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--effect
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.regcon2)
    e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.regfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK)
end
function s.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.regfilter,1,nil)
end
function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,2) and Duel.GetFlagEffect(tp,id+1)==0
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 and Duel.GetFlagEffect(tp,id+2)==0
	local b3=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,id+3)==0
	if chk==0 then return b1 or b2 or b3 end
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
        Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,2)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,tp,1)
	elseif sel==2 then
        Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
	else
        Duel.RegisterFlagEffect(tp,id+3,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	elseif sel==2 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g:GetCount()==0 then return end
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
