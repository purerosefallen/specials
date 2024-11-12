--死眼の伝霊－プシュコポンポス
function c83116692.initial_effect(c)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83116692,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,83116692)
	e1:SetTarget(c83116692.rmtg)
	e1:SetOperation(c83116692.rmop)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(83116692,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,83116693)
	e3:SetCondition(c83116692.spcon)
	e3:SetTarget(c83116692.sptg)
	e3:SetOperation(c83116692.spop)
	c:RegisterEffect(e3)
	--handle the e3
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_REMOVE)
	e4:SetOperation(c83116692.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetTarget(c83116692.syntg)
	e5:SetValue(1)
	e5:SetOperation(c83116692.synop)
	c:RegisterEffect(e5)
end
function c83116692.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c83116692.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c83116692.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c83116692.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mc=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)
	local sc=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_SPELL+TYPE_TRAP)
	if mc>sc then
		if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c83116692.rmfilter),tp,0,LOCATION_GRAVE,nil)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
				local sg=g:Select(1-tp,1,1,nil)
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
	elseif mc<sc then
		if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(c83116692.tgfilter,tp,0,LOCATION_MZONE,nil)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local sg=g:Select(1-tp,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end
function c83116692.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(83116692,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
end
function c83116692.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetTurnID()~=Duel.GetTurnCount() and c:GetFlagEffect(83116692)>0
end
function c83116692.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c83116692.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c83116692.synfilter(c,syncard,tuner,f)
	return c:IsFaceupEx() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function c83116692.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=c83116692.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(c83116692.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function c83116692.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1
		and aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL)
end
function c83116692.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(c83116692.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(c83116692.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	return mg:IsExists(c83116692.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c83116692.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(c83116692.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(c83116692.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	for i=1,maxc do
		local cg=mg:Filter(c83116692.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c83116692.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e1,true)
		end
	end
	Duel.SetSynchroMaterial(g)
end