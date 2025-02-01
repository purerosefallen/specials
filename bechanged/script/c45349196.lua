--悪魔竜ブラック・デーモンズ・ドラゴン
---@param c Card
function c45349196.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c45349196.mfilter1,c45349196.mfilter2,true)
	c:EnableReviveLimit()
	--aclimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c45349196.accon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,45349196)
	e2:SetCost(c45349196.cpcost)
	e2:SetTarget(c45349196.cptg)
	e2:SetOperation(c45349196.cpop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c45349196.damtg)
	e3:SetOperation(c45349196.damop)
	c:RegisterEffect(e3)
end
c45349196.material_setcode=0x3b
function c45349196.mfilter1(c)
	return c:IsFusionSetCard(0x3b) or c:IsFusionSetCard(0x45) and c:IsLevel(6)
end
function c45349196.mfilter2(c)
	return c:IsRace(RACE_DRAGON+RACE_FIEND)
end
function c45349196.accon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c45349196.cpfilter(c)
	return c:IsCode(6172122) and c:CheckActivateEffect(true,true,false)~=nil
end
function c45349196.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c45349196.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c45349196.cpfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
	end
	e:SetLabel(0)
	local g=Duel.GetMatchingGroup(c45349196.cpfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rg=g:Select(tp,1,1,nil)
	if rg:GetCount()>0 then
		local hg=rg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		local dg=rg:Filter(aux.AND(Card.IsFacedown,Card.IsLocation),nil,LOCATION_ONFIELD)
		local og=rg-hg-dg
		Duel.ConfirmCards(1-tp,hg+dg)
		Duel.HintSelection(og)
		if hg:GetCount()>=1 then
			Duel.ShuffleHand(tp)
		end
	end
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c45349196.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end

function c45349196.filter(c)
	return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c45349196.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c45349196.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c45349196.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c45349196.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	local atk=g:GetFirst():GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c45349196.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
