--二重曝光
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.lvtg)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
	--name
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,81881840)
	e3:SetTarget(s.nametg)
	e3:SetOperation(s.nameop)
	c:RegisterEffect(e3)
end
function s.lvfilter(c,e)
	return c:IsFaceup() and c:IsLevelBelow(6) and c:IsCanBeEffectTarget(e)
end
function s.fselect(g)
	return g:GetClassCount(Card.GetCode)==1
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.lvfilter,tp,LOCATION_MZONE,0,nil,e)
	if chkc then return false end
	if chk==0 then return g:CheckSubGroup(s.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=g:SelectSubGroup(tp,s.fselect,false,2,2)
	Duel.SetTargetCard(sg)
end
function s.tgfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.tgfilter,nil,e)
	if g:GetCount()<=0 then return end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.namefilter(c,code)
	return c:IsFaceup() and not c:IsCode(code)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe5)
		and Duel.IsExistingMatchingCard(s.namefilter,0,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetCode())
end
function s.nametg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.nameop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local code=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
		local g=Duel.SelectMatchingCard(tp,s.namefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc,code)
		local sc=g:GetFirst()
		if sc then
			Duel.HintSelection(g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(tc:GetCode())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
		end
	end
end

function s.thfilter(c)
	return c:IsSetCard(0xe5) and c:IsAbleToHand()
end
function s.sfilter(c,code)
    return c:IsType(TYPE_MONSTER) and c:IsCode(code) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		if sg and sg:IsType(TYPE_MONSTER) then
            local cg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.sfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,sg:GetCode())
            if #cg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
                Duel.BreakEffect()
                Duel.SendtoHand(cg,tp,REASON_EFFECT)
                cg:AddCard(sg)
                Duel.ConfirmCards(1-tp,cg)
            end
        else
            Duel.ConfirmCards(1-tp,sg)
        end
	end
end