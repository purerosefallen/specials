--地獄の番熊
---@param c Card
function c75375465.initial_effect(c)
	aux.AddCodeList(c,94585852)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c75375465.indtg)
	e1:SetValue(c75375465.indval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c75375465.negcon)
	e2:SetTarget(c75375465.negtg)
	e2:SetOperation(c75375465.negop)
	c:RegisterEffect(e2)
end
function c75375465.indtg(e,c)
	return c:IsFaceup() and c:IsCode(94585852)
end
function c75375465.indval(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end
function c75375465.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTACK)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
		and atk<c:GetAttack() and Duel.IsChainDisablable(ev)
		and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_FZONE,0,1,nil)
end
function c75375465.sfilter(c,tp)
	return c:IsCode(94585852) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c75375465.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75375465.sfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0) end
end
function c75375465.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c75375465.sfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then 
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	end
end