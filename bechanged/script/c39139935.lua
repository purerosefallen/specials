--No.33 先史遗产-超兵器 气能
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
aux.xyz_number[id]=33


function s.cfilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and not c:IsAttack(c:GetBaseAttack())
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_ATKCHANGE)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.filter(c)
	return c:IsFaceup() and not c:IsAttack(c:GetBaseAttack())
end
function s.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x95)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		 if chk==0 then return b1 or b2 end

	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	elseif sel==2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end


function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
		 if sel==1 then
			local c=e:GetHandler()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			if g:GetCount()>0 then
			local tc=g:GetFirst()
			local atk=tc:GetAttack()
			local batk=tc:GetBaseAttack()
			if atk<0 then local atk=0 end
				if batk~=atk then
				local dif=(batk>atk) and (batk-atk) or (atk-batk)
				Duel.Damage(1-tp,dif,REASON_EFFECT)
				end
			 end
		  elseif sel==2 then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			 if g:GetCount()>0 then
			 Duel.SendtoHand(g,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,g)
			 end
		 end
end
  







