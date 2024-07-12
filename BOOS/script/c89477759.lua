--CNo.1000 夢幻虚神ヌメロニアス
function c89477759.initial_effect(c)
	--Xyz Summon
	aux.AddXyzProcedure(c,nil,12,5,c89477759.ovfilter,aux.Stringid(89477759,4),2,c89477759.xyzop)
	c:EnableReviveLimit()
	--Destroy 1 other monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(89477759,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c89477759.descost1)
	e1:SetTarget(c89477759.destg1)
	e1:SetOperation(c89477759.desop1)
	c:RegisterEffect(e1)
	--Destroy all/Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_GRAVE_SPSUMMON)
	e2:SetDescription(aux.Stringid(89477759,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c89477759.destg2)
	e2:SetOperation(c89477759.desop2)
	c:RegisterEffect(e2)
	--Xyz Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(89477759,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c89477759.spcon)
	e3:SetTarget(c89477759.sptg)
	e3:SetOperation(c89477759.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c89477759.desreptg)
	e4:SetOperation(c89477759.desrepop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetCondition(c89477759.atkcon)
	e5:SetValue(10000)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c89477759.indes)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetTarget(c89477759.disable)
	e7:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,LOCATION_MZONE)
	e8:SetTarget(c89477759.tglimit)
	c:RegisterEffect(e8)
end
aux.xyz_number[89477759]=1000
function c89477759.ovfilter(c)
	return c:IsFaceup() and c:IsCode(79747096)
end
function c89477759.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,79747096)>0 end
end
function c89477759.descost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c89477759.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c89477759.spfilter(c,e,tp,sp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,sp) and Duel.GetLocationCountFromEx(sp,tp,nil,c)>0
end
function c89477759.desop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,aux.ExceptThisCard(e))
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.Destroy(tc,REASON_EFFECT)
		local g=Duel.GetFieldGroup(tc:GetControler(),LOCATION_EXTRA,0)
		Duel.ConfirmCards(tp,g)
		local g2=g:Filter(c89477759.spfilter,nil,e,tp,tc:GetControler())
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g2:Select(tp,1,1,nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tc:GetControler(),true,false,POS_FACEUP)
		end
		Duel.ShuffleExtra(tc:GetControler())
		
	end
end
function c89477759.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c89477759.spfilter2(c,e,tp,id)
	return c:GetTurnID()==id and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c89477759.desop2(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	if Duel.Destroy(dg,REASON_EFFECT)>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c89477759.spfilter2),tp,0,LOCATION_GRAVE,nil,e,tp,Duel.GetTurnCount())
		if ft<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		if ft>0 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(89477759,3)) then
			Duel.BreakEffect()
			local g=nil
			if tg:GetCount()>ft then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				g=tg:Select(tp,ft,ft,nil)
			else
				g=tg
			end
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			end
		end
	end
end
function c89477759.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousOverlayCountOnField()>0 and c:IsPreviousLocation(LOCATION_MZONE)
		and rp==1-tp and c:IsReason(REASON_EFFECT) and c:IsReason(REASON_DESTROY) and c:IsPreviousControler(tp)
end
function c89477759.spfilter(c,e,tp)
	return c:IsCode(15862758) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c89477759.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c89477759.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and e:GetHandler():IsCanOverlay() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c89477759.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c89477759.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(100000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end
function c89477759.repfilter(c,e)
	return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c89477759.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c89477759.repfilter,tp,LOCATION_MZONE,0,1,c,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c89477759.repfilter,tp,LOCATION_MZONE,0,1,1,c,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c89477759.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function c89477759.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DAMAGE_CAL
end
function c89477759.indes(e,c)
	return not c:IsSetCard(0x48)
end
function c89477759.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) and c:IsType(TYPE_XYZ)
end
function c89477759.tglimit(e,c)
	return c:IsType(TYPE_XYZ)
end