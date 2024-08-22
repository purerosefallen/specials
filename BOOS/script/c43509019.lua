--トゥーン・ディフェンス
function c43509019.initial_effect(c)
	aux.AddCodeList(c,15259703)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c43509019.activate)
	c:RegisterEffect(e1)
	--change battle target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26973555,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c43509019.discon)
	e3:SetTarget(c43509019.distg)
	e3:SetOperation(c43509019.disop)
	c:RegisterEffect(e3)
end
function c43509019.stfilter(c,tp)
	return c:IsCode(15259703) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c43509019.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43509019.stfilter,tp,LOCATION_DECK,0,nil)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(43509019,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c43509019.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c43509019.discon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(1-tp)
	return Duel.GetAttacker()==a
end
function c43509019.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a,d=Duel.GetBattleMonster(1-tp)
	if chk==0 then return a end
end
function c43509019.disop(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(1-tp)
	if a and a:IsRelateToBattle() then
		Duel.GetControl(a,tp)
	end
end