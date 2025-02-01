--煉獄の氾爛
---@param c Card
function c34822850.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,34822850)
	e2:SetTarget(c34822850.sptg)
	e2:SetOperation(c34822850.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE,0)
	e3:SetTarget(c34822850.efftg)
	e3:SetCode(34822850)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c34822850.atlimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c34822850.tglimit)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
end
function c34822850.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0)
		and (Duel.IsPlayerCanSpecialSummonMonster(tp,34822851,0xbb,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_FIRE,POS_FACEUP,tp) or Duel.IsPlayerCanSpecialSummonMonster(tp,34822851,0xbb,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_FIRE,POS_FACEUP,1-tp)) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c34822850.spfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER)
end
function c34822850.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local num=Duel.GetMatchingGroupCount(c34822850.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)+1
	if not c:IsRelateToEffect(e) or (ft1<=0 and ft2<=0) or (not Duel.IsPlayerCanSpecialSummonMonster(tp,34822851,0xbb,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_FIRE,POS_FACEUP,tp) and not Duel.IsPlayerCanSpecialSummonMonster(tp,34822851,0xbb,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_FIRE,POS_FACEUP,1-tp)) then return end
	local a=aux.SelectFromOptions(tp,{ft1>0,aux.Stringid(34822850,0)},{ft2>0,aux.Stringid(34822850,1)})
	local t={}
	local i=1
	if a==1 then
		local n1=math.min(ft1,num)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then n1=1 end
		for i=1,n1 do t[i]=i end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(34822850,2))
		local a1=Duel.AnnounceNumber(tp,table.unpack(t))
		for i=1,a1 do
			local token=Duel.CreateToken(tp,34822851)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end	
	else
		local n2=math.min(ft2,num)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then n2=1 end
		for i=1,n2 do t[i]=i end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(34822850,2))
		local a2=Duel.AnnounceNumber(tp,table.unpack(t))
		for i=1,a2 do
			local token=Duel.CreateToken(tp,34822851)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
		end
	end
	Duel.SpecialSummonComplete()
end
function c34822850.efftg(e,c)
	return c:IsSetCard(0xbb)
end
function c34822850.filter(c,lv)
	return c:IsFaceup() and c:IsSetCard(0xbb) and c:GetLevel()>lv
end
function c34822850.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0xbb)
		and (not c:IsHasLevel() or Duel.IsExistingMatchingCard(c34822850.filter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetLevel()))
end
function c34822850.tglimit(e,c)
	return c:IsSetCard(0xbb)
		and Duel.IsExistingMatchingCard(c34822850.filter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetLevel())
end
