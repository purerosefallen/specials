--ライトロード・サモナー ルミナス
---@param c Card
function c95503687.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95503687,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c95503687.spcost)
	e1:SetTarget(c95503687.sptg)
	e1:SetOperation(c95503687.spop)
	c:RegisterEffect(e1)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetDescription(aux.Stringid(95503687,1))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1000)
	e2:SetCondition(c95503687.discon)
	e2:SetTarget(c95503687.distg)
	e2:SetOperation(c95503687.disop)
	c:RegisterEffect(e2)
	--监听堆墓效果被发动无效时去掉已发动标记
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) -- 设置为连续效果
    e3:SetCode(EVENT_CHAIN_NEGATED) -- 特殊监听链被无效事件
    e3:SetRange(LOCATION_MZONE) -- 此效果以字段上存在为范围
    e3:SetOperation(c95503687.disflagcheck) -- 触发时，调用 negated_check 函数
	e3:SetLabelObject(e2)
    c:RegisterEffect(e3)
end
function c95503687.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c95503687.filter(c,e,tp)
	return c:IsSetCard(0x38) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95503687.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c95503687.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c95503687.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95503687.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95503687.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c95503687.discon(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local fid = c:GetFieldID()
	return tp==Duel.GetTurnPlayer() and c:GetFlagEffect(fid)==0
end
function c95503687.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
	local c = e:GetHandler()
	local fid = c:GetFieldID()
	c:RegisterFlagEffect(fid,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c95503687.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
end
function c95503687.disflagcheck(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local fid = c:GetFieldID()
	if e:GetLabelObject():GetFieldID() == re:GetFieldID() then
		c:ResetFlagEffect(fid)
	end
end