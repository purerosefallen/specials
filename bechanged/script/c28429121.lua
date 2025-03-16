--遗式世传的禁断秘术
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_RITUAL) and c:IsLevelAbove(1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local exmg=Group.CreateGroup()
		if Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_HAND,0,1,nil,10) then
			exmg=Duel.GetMatchingGroup(Card.IsHasLevel,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
		end
		mg:Merge(exmg)
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if rc then
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if rc:IsLevel(10) then
			local exmg=Duel.GetMatchingGroup(Card.IsHasLevel,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
			local chkmg=Duel.GetMatchingGroup(nil,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
			
			mg:Merge(exmg)
			Duel.ConfirmCards(1-tp,chkmg)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=mg:SelectWithSumEqual(tp,Card.GetLevel,rc:GetLevel(),1,99,rc)
		if #g>0 then
			rc:SetMaterial(g)
			local sg=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
			Duel.SendtoGrave(sg,REASON_RELEASE+REASON_RITUAL)
			g:Sub(sg)
			Duel.Release(g,REASON_RITUAL)
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			rc:CompleteProcedure()
		end
	end
end
