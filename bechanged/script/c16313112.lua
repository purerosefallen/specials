--転生炎獣エメラルド・イーグル
---@param c Card
function c16313112.initial_effect(c)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16313112,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c16313112.descon)
	e1:SetTarget(c16313112.destg)
	e1:SetOperation(c16313112.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c16313112.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--eff gain
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCondition(c16313112.descon2)
	e3:SetTarget(c16313112.destg2)
	e3:SetOperation(c16313112.desop2)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,16313112)
	e4:SetCost(c16313112.scost)
	e4:SetTarget(c16313112.stg)
	e4:SetOperation(c16313112.sop)
	c:RegisterEffect(e4)
end
function c16313112.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c16313112.filter1(c)
	return c:IsCode(38784726) and c:IsAbleToHand()
end
function c16313112.filter2(c)
	return c:IsSetCard(0x119) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function c16313112.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16313112.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c16313112.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c16313112.sop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c16313112.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c16313112.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16313112.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c16313112.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c16313112.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c16313112.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSummonType,tp,0,LOCATION_MZONE,1,nil,SUMMON_TYPE_SPECIAL) end
	local g=Duel.GetMatchingGroup(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c16313112.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
	Duel.Destroy(g,REASON_EFFECT)
end
function c16313112.valfilter(c,tp)
	return c:IsCode(16313112) and c:IsControler(tp)
end
function c16313112.valcheck(e,c)
	local g=c:GetMaterial()
	local tp=c:GetControler()
	if g:IsExists(c16313112.valfilter,1,nil,tp) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c16313112.descon2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d==e:GetHandler() then d=Duel.GetAttacker() end
	e:SetLabelObject(d)
	return d~=nil
end
function c16313112.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local d=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d:GetBaseAttack())
end
function c16313112.desop2(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabelObject()
	local dam=d:GetBaseAttack()
	if d:IsRelateToBattle() and Duel.Destroy(d,REASON_EFFECT)~=0 and dam>0 then
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
