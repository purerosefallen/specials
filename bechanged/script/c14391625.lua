--维萨斯-僧娑洛
function c14391625.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14391625,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,14391625)
	e1:SetTarget(c14391625.sptg)
	e1:SetOperation(c14391625.spop)
	c:RegisterEffect(e1)
	--quick effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14391625,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,14391625)
	e2:SetCondition(c14391625.spcon)
	e2:SetTarget(c14391625.sptg)
	e2:SetOperation(c14391625.spop)
	c:RegisterEffect(e2)
	--non tuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(c14391625.tnval)
	c:RegisterEffect(e3)
	--kanyiyanjiuhuibaozha
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14391625,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,14391626)
	e3:SetCost(c14391625.tgcost)
	e3:SetTarget(c14391625.tgtg)
	e3:SetOperation(c14391625.tgop)
	c:RegisterEffect(e3)
end


function c14391625.filter1(c)
	return c:IsSetCard(0x198) 
	or c:IsSetCard(0x1a0) 
end
function c14391625.filter2(c)
	return c:IsSetCard(0x190) 
	or c:IsSetCard(0x17a) 
	or c:IsCode(56099748)
	or aux.IsCodeListed(c,56099748)
end


function c14391625.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=2
	and ep==1-tp 
end
function c14391625.retfilter(c,e)
	return c14391625.filter1(c) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
		and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c14391625.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED) and c14391625.retfilter(chkc,e) and Duel.GetFlagEffect(tp,14391625)==0 end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c14391625.retfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,c,e)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:CheckSubGroup(aux.mzctcheck,1,#g,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:SelectSubGroup(tp,aux.mzctcheck,false,1,#g,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.RegisterFlagEffect(tp,14391625,RESET_CHAIN,0,1)
end
function c14391625.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local atk=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA):GetClassCount(Card.GetCode)*400
	if atk>0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c14391625.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end


function c14391625.costfilter(c,ec,e,tp)
	if not c14391625.filter2(c) or not c:IsType(TYPE_MONSTER) or c:IsPublic() then return false end
	local g=Group.FromCards(c,ec)
	return g:IsExists(c14391625.tgspfilter,1,nil,g,e,tp)
end
function c14391625.tgspfilter(c,g,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:IsExists(Card.IsAbleToGrave,1,c)
end
function c14391625.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c14391625.costfilter,tp,LOCATION_HAND,0,1,c,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sc=Duel.SelectMatchingCard(tp,c14391625.costfilter,tp,LOCATION_HAND,0,1,1,c,c,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,sc)
	Duel.ShuffleHand(tp)
	sc:CreateEffectRelation(e)
	e:SetLabelObject(sc)
end
function c14391625.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.GetFlagEffect(tp,14391625)==0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.RegisterFlagEffect(tp,14391625,RESET_CHAIN,0,1)
end
function c14391625.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	local g=Group.FromCards(c,sc)
	local fg=g:Filter(Card.IsRelateToEffect,nil,e)
	if fg:GetCount()~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=fg:FilterSelect(tp,c14391625.tgspfilter,1,1,nil,fg,e,tp)
	if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.SendtoGrave(g-sg,REASON_EFFECT)
	end
end
