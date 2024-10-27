--E・HERO ゴッド・ネオス
function c31111109.initial_effect(c)
	--fusion material
	aux.EnableChangeCode(c,42015635)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c31111109.sprcon)
    e1:SetTarget(c31111109.sprtg)
    e1:SetOperation(c31111109.sprop)
    c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31111109,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c31111109.copycost)
	e2:SetOperation(c31111109.copyop)
	c:RegisterEffect(e2)
	--may not return
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(42015635)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetTarget(c31111109.atktg)
    e4:SetValue(500)
    c:RegisterEffect(e4)
end
function c31111109.atktg(e,c)
    return c:IsCode(89943723) or c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,89943723)
end
function c31111109.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c31111109.cfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil)
    return g:GetCount()>=5
end
function c31111109.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local g=Duel.GetMatchingGroup(c31111109.cfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=g:Select(tp,5,#g,nil)
    if sg then
        sg:KeepAlive()
        e:SetLabelObject(sg)
        return true
    else return false end
end
function c31111109.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
	if g:IsExists(Card.IsFacedown,1,nil) then
		Duel.ConfirmCards(1-tp,g:Filter(Card.IsFacedown,nil))
	end
    Duel.SendtoDeck(g,tp,2,REASON_SPSUMMON+REASON_COST)
    g:DeleteGroup()
end
function c31111109.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() and (c:IsSetCard(0x8) or c:IsSetCard(0x1f) or c:IsSetCard(0x9))
end
function c31111109.filter(c)
    return (c:IsSetCard(0x8) or c:IsSetCard(0x1f) or c:IsSetCard(0x9)) and c:IsType(TYPE_MONSTER) and (not c:IsPublic() or not c:IsLocation(LOCATION_HAND))
end
function c31111109.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31111109.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c31111109.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,99,nil)
	Duel.ConfirmCards(1-tp,g)
	g:KeepAlive()
	e:SetLabelObject(g)
end
function c31111109.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		local code=tc:GetOriginalCode()
		if code~=0 then
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(31111109,1))
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCountLimit(1)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetLabel(cid)
			e2:SetLabelObject(e1)
			e2:SetOperation(c31111109.rstop)
			c:RegisterEffect(e2)
		end
	end
end
function c31111109.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	local atke=e:GetLabelObject()
	if atke then
		atke:SetReset(RESET_EVENT+RESETS_STANDARD)
	end
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	if atke then
		atke:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
