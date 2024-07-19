SP_RULE={}
--如果没有规则卡，填false
SP_RULE.Card=49299410
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = false
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 0

SP_RULE.RuleName="福尔摩斯"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message={"规则卡得到以下效果。","·抽卡阶段发动。对方宣言1~12的任意等级。",
                    "那只怪兽的等级和宣言的等级相同的场合，翻开的卡全部送去墓地。",
                    "不是的场合，那只怪兽特殊召唤，剩下的翻开的卡全部送去墓地。"}

--给规则卡添加效果。只会执行一次。
function SP_RULE.InitRuleCard(c)
	--名推理
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetDescription(aux.Stringid(95503687,1))
	e2:SetCode(EVENT_PHASE+PHASE_DRAW)
	e2:SetRange(LOCATION_REMOVED)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1,98765432)
	e2:SetTarget(SP_RULE.target)
	e2:SetOperation(SP_RULE.operation)
	c:RegisterEffect(e2)
end
function SP_RULE.target(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,63060238) and not Duel.IsPlayerAffectedByEffect(tp,97148796)
		and Duel.IsExistingMatchingCard(Card.IsSummonableCard,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function SP_RULE.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummon(tp) or not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceLevel(1-tp)
	local g=Duel.GetMatchingGroup(Card.IsSummonableCard,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not spcard:IsLevel(lv)
		and spcard:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.DisableShuffleCheck()
		if dcount-seq==1 then Duel.SpecialSummon(spcard,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SpecialSummonStep(spcard,0,tp,tp,false,false,POS_FACEUP)
			Duel.DiscardDeck(tp,dcount-seq-1,REASON_EFFECT)
			Duel.SpecialSummonComplete()
		end
	else
		Duel.DiscardDeck(tp,dcount-seq,REASON_EFFECT+REASON_REVEAL)
	end
end
