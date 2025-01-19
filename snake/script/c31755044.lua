--十二兽 蛇笞
local m=31755044
local cm=_G["c"..m]
function cm.initial_effect(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31755044,2))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31755044,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetTarget(cm.mattg)
	e3:SetOperation(cm.matop)
	c:RegisterEffect(e3)
	--get effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31755044,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(cm.rmcon)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
	--get effect 2
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_XMATERIAL)
	e6:SetCode(EVENT_DESTROY)
	e6:SetCondition(cm.condition)
	e6:SetOperation(cm.repop)
	c:RegisterEffect(e6)
	--get effect 3
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_XMATERIAL)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(cm.condition)
	e7:SetValue(cm.imval)
	c:RegisterEffect(e7)
end
function cm.imval(e,re)
	return re:GetHandler()~=e:GetHandler() and (re:GetHandler():IsCode(9940036,24299458,29301450) or re:IsActiveType(TYPE_TRAP))
end
function cm.condition(e)
	return e:GetHandler():GetOriginalRace()==RACE_BEASTWARRIOR
end
function cm.condition2(e)
	local c=e:GetHandler()
	return c:GetOriginalRace()==RACE_BEASTWARRIOR and c:IsOriginalCodeRule(48905153)
end
function cm.matfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR) and c:IsType(TYPE_XYZ)
end
function cm.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.matfilter(chkc) end
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingTarget(cm.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsCanOverlay() then
		Duel.Overlay(tc,Group.FromCards(c))
		local token=Duel.CreateToken(tp,48905153)
		Duel.SendtoDeck(token,nil,0,REASON_EFFECT)
	end
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return c:GetOriginalRace()==RACE_BEASTWARRIOR
		and bc and bc:IsStatus(STATUS_OPPO_BATTLE) and bc:IsRelateToBattle()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsControler(1-tp) then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,48905153)
	Duel.SendtoDeck(token,nil,0,REASON_EFFECT)
end
function cm.repfilter(c,tp)
	return c:IsControler(1-tp) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_EFFECT) and c:GetDestination()==LOCATION_GRAVE and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.repop(e,tp,eg)
	local g=eg:Filter(cm.repfilter,nil,tp)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_DESTROY)
end