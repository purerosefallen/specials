--呪言の鏡
function c46656406.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function (e)
		local tp=e:GetHandlerPlayer()
		return ((e:GetHandler():IsLocation(LOCATION_HAND) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0) or not e:GetHandler():IsLocation(LOCATION_HAND))
	end)
	e1:SetTarget(c46656406.target)
	e1:SetOperation(c46656406.activate)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0)
end
function c46656406.filter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c46656406.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c46656406.filter,1,nil,tp) and Duel.IsPlayerCanDraw(tp,1) end
	local g=eg:Filter(c46656406.filter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c46656406.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsSummonPlayer(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c46656406.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c46656406.filter2,nil,e,tp)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
