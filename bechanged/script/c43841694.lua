--魔導書の奇跡
function c43841694.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43841694+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c43841694.target)
	e1:SetOperation(c43841694.activate)
	c:RegisterEffect(e1)
end
function c43841694.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_GRAVE) and c:IsRace(RACE_SPELLCASTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or c:IsLocation(LOCATION_EXTRA) and c:IsSetCard(0x6e) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c43841694.filter2(c)
	return c:IsFaceupEx() and c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and c:IsCanOverlay()
end
function c43841694.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return 
		and Duel.IsExistingMatchingCard(c43841694.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c43841694.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c43841694.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c43841694.ovfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and c:IsCanOverlay()
end
function c43841694.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=e:GetLabelObject()
	local sg=g:Filter(c43841694.ovfilter,tc,e)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c43841694.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		if sg:GetCount()>0 then
			Duel.Overlay(tc,sg)
		end
	end
end
