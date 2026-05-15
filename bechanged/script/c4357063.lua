--
function c4357063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c4357063.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4357063,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c4357063.sptg)
	e2:SetOperation(c4357063.spop)
	c:RegisterEffect(e2)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4357063,5))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c4357063.damcon)
	e3:SetTarget(c4357063.damtg)
	e3:SetOperation(c4357063.damop)
	c:RegisterEffect(e3)
end

function c4357063.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c4357063.tffilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x70) and not Duel.IsExistingMatchingCard(c4357063.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c4357063.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4357063.tffilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(4357063,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,1,nil)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end


function c4357063.costfilter(c,e,tp)
	return c:IsSetCard(0x70) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c4357063.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c4357063.spfilter(c,e,tp)
	return c:IsSetCard(0x70) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4357063.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c4357063.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4357063.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c4357063.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c4357063.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c4357063.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	then
	local res=0
			if tc:GetLevel()==1 then
				res=Duel.SelectOption(tp,aux.Stringid(4357063,2),aux.Stringid(4357063,3))
			else
				res=Duel.SelectOption(tp,aux.Stringid(4357063,2),aux.Stringid(4357063,3),aux.Stringid(4357063,4))
			end
			if res>0 then
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				if res==1 then
					e1:SetValue(1)
				else
					e1:SetValue(-1)
				end
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
	end
end

function c4357063.filter2(c,e,tp)
	return c:IsSetCard(0x70)
end
function c4357063.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c4357063.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4357063.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local dam=Duel.GetMatchingGroupCount(c4357063.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c4357063.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c4357063.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*200
	Duel.Damage(p,d,REASON_EFFECT)
end

