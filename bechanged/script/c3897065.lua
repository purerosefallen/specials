--超级交通机人-隐形合体
function c3897065.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode4(c,61538782,98049038,71218746,984114,true,true)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3897065,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,3897065)
	e1:SetTarget(c3897065.eqtg)
	e1:SetOperation(c3897065.eqop)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3897065,3))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,3897066)
	e4:SetCost(c3897065.thcost)
	e4:SetTarget(c3897065.thtg)
	e4:SetOperation(c3897065.thop)
	c:RegisterEffect(e4)
end


--equip

function c3897065.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP) and not c:IsForbidden()
end
function c3897065.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c3897065.filter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c3897065.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c3897065.filter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,e:GetHandler()) --tp
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c3897065.filter),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())  --1-tp
	local sg=Group.CreateGroup()

	if g1:GetCount()>0 and (g2:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(3897065,1))) and ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
		ft=ft-1
	end
	if ft>0 then 
	 if g2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(3897065,2))) then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		 local sg2=g2:Select(tp,1,1,nil)
		 Duel.HintSelection(sg2)
		 sg:Merge(sg2)
	 end
	end
	local c=e:GetHandler()
	for tc in aux.Next(sg) do
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			Duel.Equip(tp,tc,c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c3897065.eqlimit)
			tc:RegisterEffect(e1)
		end
	end
end
function c3897065.eqlimit(e,c)
	return e:GetOwner()==c
end


--tohand

function c3897065.thfilter(c)
	return (c:IsFaceup() or c:GetEquipTarget()) and c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c3897065.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3897065.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c3897065.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c3897065.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x16) and not c:IsForbidden() and c:IsAbleToHand()
end
function c3897065.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c3897065.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c3897065.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c3897065.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT) end
end

