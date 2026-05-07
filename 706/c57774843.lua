--裁きの龍
---@param c Card
function c57774843.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(57774843,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c57774843.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(57774843,1))
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c57774843.cost)
	e2:SetTarget(c57774843.target)
	e2:SetOperation(c57774843.operation)
	c:RegisterEffect(e2)
	--discard deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetDescription(aux.Stringid(57774843,2))
	e3:SetCountLimit(1000)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c57774843.condition2)
	e3:SetTarget(c57774843.target2)
	e3:SetOperation(c57774843.operation2)
	c:RegisterEffect(e3)
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e4)
	--监听堆墓效果被发动无效时去掉已发动标记
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) -- 设置为连续效果
    e5:SetCode(EVENT_CHAIN_NEGATED) -- 特殊监听链被无效事件
    e5:SetRange(LOCATION_MZONE) -- 此效果以字段上存在为范围
    e5:SetOperation(c57774843.disflagcheck) -- 触发时，调用 negated_check 函数
	e5:SetLabelObject(e4)
    c:RegisterEffect(e5)
end
function c57774843.spfilter(c)
	return c:IsSetCard(0x38) and c:IsType(TYPE_MONSTER)
end
function c57774843.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c57774843.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>3
end
function c57774843.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c57774843.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c57774843.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end
function c57774843.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local fid = c:GetFieldID()
	return tp==Duel.GetTurnPlayer() and c:GetFlagEffect(fid)==0
end
function c57774843.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,4)
	local c = e:GetHandler()
	local fid = c:GetFieldID()
	c:RegisterFlagEffect(fid,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c57774843.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,4,REASON_EFFECT)
end
function c57774843.disflagcheck(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local fid = c:GetFieldID()
	if e:GetLabelObject():GetFieldID() == re:GetFieldID() then
		c:ResetFlagEffect(fid)
	end
end