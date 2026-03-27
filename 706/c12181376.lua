--トライアングル・X・スパーク
---@param c Card
function c12181376.initial_effect(c)
	aux.AddCodeList(c,12206212)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12181376.target)
	e1:SetOperation(c12181376.activate)
	c:RegisterEffect(e1)
end
function c12181376.filter(c)
	return c:IsFaceup() and c:IsCode(12206212)
end
function c12181376.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12181376.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c12181376.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12181376.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local fid=c:GetFieldID()
	local elast = nil
	local count = 0
	while tc do
		if not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(2700)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetLabelObject(elast or g)
			elast = e1
			e1:SetLabel(count)
			count = count + 1
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(12181376,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		tc=g:GetNext()
	end
	--cannot activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c12181376.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(elast)
	elast = e1
	Duel.RegisterEffect(e1,tp)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_SZONE)
	e2:SetTarget(c12181376.distg)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(elast)
	elast = e2
	Duel.RegisterEffect(e2,tp)
	--disable trap monster
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c12181376.distg)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetLabelObject(elast)
	elast = e3
	Duel.RegisterEffect(e3,tp)

	if g:GetCount()>0 then
		g:KeepAlive()
	end

	local e_reset=Effect.CreateEffect(e:GetHandler())
	e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e_reset:SetCode(EVENT_PHASE+PHASE_END)
	e_reset:SetReset(RESET_PHASE+PHASE_END)
	e_reset:SetCountLimit(1)
	e_reset:SetLabel(fid)
	e_reset:SetLabelObject(elast)
	e_reset:SetOperation(c12181376.rstop)
	Duel.RegisterEffect(e_reset,tp)

end
function c12181376.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function c12181376.distg(e,c)
	return c:IsType(TYPE_TRAP)
end



function c12181376.desfilter(c,fid)
	return c:GetFlagEffectLabel(12181376)==fid
end

function c12181376.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e3 = e:GetLabelObject()
	local e2 = e3:GetLabelObject()
	local e1 = e2:GetLabelObject()
	local sg = e1:GetLabelObject()
	if sg ~= nil then
		while sg:GetLabel() ~= 0 do
			sg = sg:GetLabelObject()
		end
		sg = sg:GetLabelObject()
		local dg=sg:Filter(c12181376.desfilter,nil,e:GetLabel())
		sg:DeleteGroup()
		if dg:GetCount()>0 then
			local ecur = e1:GetLabelObject()
			local elast = nil
			while ecur:GetLabel() ~= 0 do
				elast = ecur
				ecur = ecur:GetLabelObject()
				elast:Reset()
			end
			ecur:Reset()
		end
	end
	e3:Reset()
	e2:Reset()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,1162)
end