--异色眼灵摆读龙
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(s.rtg)
	e0:SetOperation(s.rop)
	c:RegisterEffect(e0)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.damcon1)
	e2:SetOperation(s.damop1)
	c:RegisterEffect(e2)
	--sp_summon effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.regcon)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.damcon2)
	e4:SetOperation(s.damop2)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.discon)
	e5:SetTarget(s.distg)
	e5:SetOperation(s.disop)
	c:RegisterEffect(e5)
end
function s.rfilter(c,e,tp,mg,tc)
	local sg=Duel.GetMatchingGroup(s.exfilter0,tp,LOCATION_EXTRA,0,nil)
	if not tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or not tc:IsLocation(LOCATION_PZONE) then return false end
	mg:RemoveCard(tc)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
	   mg:Merge(sg)
	end
	local lv=tc:GetOriginalLevel()
	aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,"Greater")
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv,tp,tc,lv,"Greater")
	aux.GCheckAdditional=nil
	return res
end
function s.exfilter0(c)
	return c:IsSetCard(0x99) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_PZONE,0,1,nil,e,tp,mg,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.exfilter0,tp,LOCATION_EXTRA,0,nil)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg=Duel.GetRitualMaterial(tp)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		mg:Merge(sg)
	 end

	local tc=e:GetHandler()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lv=tc:GetOriginalLevel()
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,lv,tp,tc,lv,"Greater")
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--
function s.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		if c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
function s.filter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,1-tp)
		and not Duel.IsChainSolving()
end
function s.damop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,1-tp)
		and Duel.IsChainSolving()
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function s.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.damop2(e,tp,eg,ep,ev,re,r,rp)
	local n=e:GetHandler():GetFlagEffect(id)
	e:GetHandler():ResetFlagEffect(id)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(1-tp,n*300,REASON_EFFECT)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_SPELL) and Duel.IsChainDisablable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOriginalType()&TYPE_PENDULUM~=0
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	if e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) then
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	else
		e:SetCategory(CATEGORY_DISABLE)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x99) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
		if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) and c:IsLocation(LOCATION_PZONE) then
			if Duel.NegateEffect(ev) and c:IsSummonType(SUMMON_TYPE_RITUAL)
				and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
				and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
