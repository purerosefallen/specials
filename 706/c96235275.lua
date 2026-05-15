--ライトロード・パラディン ジェイン
---@param c Card
function c96235275.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c96235275.atktg)
	e1:SetCondition(c96235275.condtion)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetDescription(aux.Stringid(96235275,0))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1000)
	e2:SetCondition(c96235275.discon)
	e2:SetTarget(c96235275.distg)
	e2:SetOperation(c96235275.disop)
	c:RegisterEffect(e2)
	--监听堆墓效果被发动无效时去掉已发动标记
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) -- 设置为连续效果
    e3:SetCode(EVENT_CHAIN_NEGATED) -- 特殊监听链被无效事件
    e3:SetRange(LOCATION_MZONE) -- 此效果以字段上存在为范围
    e3:SetOperation(c96235275.disflagcheck) -- 触发时，调用 negated_check 函数
	e3:SetLabelObject(e2)
    c:RegisterEffect(e3)
end
function c96235275.atktg(e,c)
	return c==e:GetHandler()
end
function c96235275.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil
end
function c96235275.discon(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local fid = c:GetFieldID()
	return tp==Duel.GetTurnPlayer() and c:GetFlagEffect(fid)==0
end
function c96235275.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
	local c = e:GetHandler()
	local fid = c:GetFieldID()
	c:RegisterFlagEffect(fid,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c96235275.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end
function c96235275.disflagcheck(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local fid = c:GetFieldID()
	if e:GetLabelObject():GetFieldID() == re:GetFieldID() then
		c:ResetFlagEffect(fid)
	end
end