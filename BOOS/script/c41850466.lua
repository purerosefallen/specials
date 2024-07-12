--ヌメロン・カオス・リチューアル
function c41850466.initial_effect(c)
	aux.AddCodeList(c,79747096,41418852,89477759)
	--Activate/Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c41850466.xyztg)
	e1:SetOperation(c41850466.xyzop)
	c:RegisterEffect(e1)
end
function c41850466.xyzfilter1(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48) and c:IsCanOverlay() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c41850466.xyzfilter2(c)
	return c:IsCode(79747096) and c:IsCanOverlay() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c41850466.xyzfilter3(c,e,tp)
	return c:IsCode(89477759) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c41850466.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c41850466.xyzfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingTarget(c41850466.xyzfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,4,nil)
		and Duel.IsExistingMatchingCard(c41850466.xyzfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg1=Duel.SelectTarget(tp,c41850466.xyzfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg2=Duel.SelectTarget(tp,c41850466.xyzfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,4,4,nil)
	sg1:Merge(sg2)
	local g=sg1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c41850466.mtfilter(c,e)
	return c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c41850466.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c41850466.xyzfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(10000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetValue(1000)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		sc:RegisterEffect(e2)
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local g=tg:Filter(c41850466.mtfilter,nil,e)
		if #g==5 then
			Duel.Overlay(sc,g)
		end
	end
	Duel.SpecialSummonComplete()
end
