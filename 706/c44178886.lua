--ライトロード・モンク エイリン
function c44178886.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44178886,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetTarget(c44178886.targ)
	e1:SetOperation(c44178886.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetDescription(aux.Stringid(44178886,1))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1000)
	e2:SetCondition(c44178886.discon)
	e2:SetTarget(c44178886.distg)
	e2:SetOperation(c44178886.disop)
	c:RegisterEffect(e2)
	--监听堆墓效果被发动无效时去掉已发动标记
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) -- 设置为连续效果
    e3:SetCode(EVENT_CHAIN_NEGATED) -- 特殊监听链被无效事件
    e3:SetRange(LOCATION_MZONE) -- 此效果以字段上存在为范围
    e3:SetOperation(c44178886.disflagcheck) -- 触发时，调用 negated_check 函数
	e3:SetLabelObject(e2)
    c:RegisterEffect(e3)
end
function c44178886.targ(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and t~=nil and not t:IsAttackPos() and t:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,t,1,0,0)
end


--限制：不能发动“反转效果（Flip）”
function c44178886.aclimit(e,re,tp)
    --re:GetHandler() 是正在尝试发动效果的卡
    --反转效果的类型包含 EFFECT_TYPE_FLIP
    return re:IsActiveType(TYPE_MONSTER) and re:GetCode()==EVENT_FLIP
end
function c44178886.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local t=Duel.GetAttackTarget()
    if not (Duel.GetAttacker()==c and t~=nil and t:IsRelateToBattle() and not t:IsAttackPos() and t:IsAbleToDeck()) then return end

	--仅对守墓侦察者这个特例临时增加一个对方玩家不能在伤害计算前发反转效果的永续效果以还原旧裁定
	if t:GetCode()==24317029 then -- 替换为守墓侦察者的实际卡片代码
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1) --只影响对方玩家
		e1:SetValue(c44178886.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
	end


    c44178886.attach_temp_todeck_flip(e,tp,t)

    Duel.SendtoDeck(t,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c44178886.attach_temp_todeck_flip(e,tp,t)
    if not (t and t.GetFlipEffect) then return end
    local fe=t:GetFlipEffect()
    if not fe then return end

    local te=fe:Clone()
    te:SetCode(EVENT_TO_DECK)

	if t:GetFlagEffect(44178886)~=0 then
        return nil
    end
	t:RegisterFlagEffect(44178886,RESET_EVENT+RESET_CODE,0,1)

    -- 限制：只让“被武僧效果送回卡组”这一次触发
    local oldcon = te.GetCondition and te:GetCondition() or nil
    te:SetCondition(function(e2,tp2,eg,ep,ev,re,r,rp)
        if re~=e then return false end
        if bit.band(r,REASON_EFFECT)==0 then return false end
        -- 保留原本 flip 的条件（如果有）
        if oldcon then return oldcon(e2,tp2,eg,ep,ev,re,r,rp) end
        return true
    end)
	local oldop = te.GetOperation and te:GetOperation() or nil
	te:SetOperation(function(e2,tp2,eg2,ep2,ev2,re2,r2,rp2)
		if oldop then 
			local wrap_reset_op = function(e2,tp2,eg2,ep2,ev2,re2,r2,rp2)
				local op_result = oldop(e2,tp2,eg2,ep2,ev2,re2,r2,rp2) or nil
				te:Reset()  -- 无论如何 reset 掉这个临时 effect，避免它一直挂在卡组里
				t:ResetFlagEffect(44178886)  -- 重置标记，允许未来再次被武僧效果送回卡组时触发
				return op_result
			end
			wrap_reset_op(e2,tp2,eg2,ep2,ev2,re2,r2,rp2) 
		end
	end)

	t:RegisterEffect(te)
end

function c44178886.discon(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local fid = c:GetFieldID()
	return tp==Duel.GetTurnPlayer() and c:GetFlagEffect(fid)==0
end
function c44178886.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
	local c = e:GetHandler()
	local fid = c:GetFieldID()
	c:RegisterFlagEffect(fid,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c44178886.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
end
function c44178886.disflagcheck(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local fid = c:GetFieldID()
	if e:GetLabelObject():GetFieldID() == re:GetFieldID() then
		c:ResetFlagEffect(fid)
	end
end