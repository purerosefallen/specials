--先史遗产技术
function c90951921.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,90951921+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c90951921.cost)
	e1:SetTarget(c90951921.target)
	e1:SetOperation(c90951921.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(90951921,ACTIVITY_SPSUMMON,c90951921.counterfilter)
end
function c90951921.counterfilter(c)
	return c:IsSetCard(0x70)
end
function c90951921.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(90951921,tp,ACTIVITY_SPSUMMON)==0 end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c90951921.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c90951921.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x70)
end

function c90951921.thfilter(c)
	return c:IsSetCard(0x70) and c:IsAbleToHand()
end
function c90951921.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x70) and c:IsAbleToRemove()
end
function c90951921.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c90951921.costfilter(chkc) end
	local b1=Duel.IsExistingMatchingCard(c90951921.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingTarget(c90951921.costfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDiscardDeck(tp,1)
	if chk==0 then
	return b1 or b2 end

		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(90951921,0),aux.Stringid(90951921,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(90951921,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(90951921,1))+1
		end
		e:SetLabel(op)
		if op==0 then
			e:SetProperty(0)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		else
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectTarget(tp,c90951921.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
		end
end

function c90951921.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c90951921.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	else
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsPlayerCanDiscardDeck(tp,1) then
		Duel.BreakEffect()
		 local c=e:GetHandler()
		 local count=0
		 if tc:GetLevel()>0 then count=tc:GetLevel()
		 elseif tc:GetRank()>0 then count=tc:GetRank()
		 elseif tc:Getlink()>0 then count=tc:Getlink() end
		 local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		 if ct==0 or count==0 then return end
		 if ct>count then ct=count end
		 local t={}
		 for i=1,ct do t[i]=i end
		 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(90951921,2))
		 local ac=Duel.AnnounceNumber(tp,table.unpack(t))
		 local g=Duel.GetDecktopGroup(tp,ac)
		 Duel.ConfirmCards(tp,g)
		 if g:GetCount()>0 and g:FilterCount(Card.IsAbleToHand,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(90951921,3))then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
			g:Sub(sg)
			if sg:GetCount()>0 then
				Duel.DisableShuffleCheck()
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
			end
			if g:GetCount()>0 then
				Duel.DisableShuffleCheck()
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
	end
end

