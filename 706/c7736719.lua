--エア・サーキュレーター
---@param c Card
function c7736719.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7736719,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c7736719.target)
	e1:SetOperation(c7736719.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7736719,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c7736719.drtg)
	e2:SetOperation(c7736719.drop)
	c:RegisterEffect(e2)
	--临时增加一个被破坏回卡组必发效果来还原被人鱼洗回卡组也能抓牌的旧裁定
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7736719,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCondition(c7736719.drcon)
	e3:SetTarget(c7736719.drtg)
	e3:SetOperation(c7736719.drop)
	c:RegisterEffect(e3)
end
function c7736719.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c7736719.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if g:GetCount()<2 or not Duel.IsPlayerCanDraw(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=g:Select(tp,2,2,nil)
	Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,2,REASON_EFFECT)
end
function c7736719.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c7736719.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c7736719.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
