--サイバー・ツイン・ドラゴン
function c74157028.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,70095154,2,true,true)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c74157028.descon)
	e1:SetTarget(c74157028.destg)
	e1:SetOperation(c74157028.desop)
	c:RegisterEffect(e1)
	--extra att
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
c74157028.material_setcode=0x1093

function c74157028.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c74157028.desfilter(c)
	return c:IsLocation(LOCATION_MZONE) or c:GetSequence()<5
end
function c74157028.mzfilter(c)
	return c:GetSequence()<5
end
function c74157028.ezfilter(c)
	return c:GetSequence()>=5
end
function c74157028.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c74157028.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c74157028.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	local g1=tc:GetColumnGroup()
	local g2=Group.CreateGroup()
	if tc:IsLocation(LOCATION_MZONE) and tc:GetSequence()<5 then
		g2=(Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(c74157028.mzfilter,nil))
	end
	if tc:IsLocation(LOCATION_MZONE) and tc:GetSequence()>=5 then
		g2=(Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(c74157028.ezfilter,nil))
	end
	if tc:IsLocation(LOCATION_SZONE) then
		g2=(Duel.GetFieldGroup(tp,0,LOCATION_SZONE):Filter(c74157028.mzfilter,nil))
	end
	g:Merge(g1)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c74157028.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g1=tc:GetColumnGroup()
		local g2=Group.CreateGroup()
		if tc:IsLocation(LOCATION_MZONE) and tc:GetSequence()<5 then
			g2=(Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(c74157028.mzfilter,nil))
		end
		if tc:IsLocation(LOCATION_MZONE) and tc:GetSequence()>=5 then
			g2=(Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE):Filter(c74157028.ezfilter,nil))
		end
		if tc:IsLocation(LOCATION_SZONE) then
			g2=(Duel.GetFieldGroup(tp,0,LOCATION_SZONE):Filter(c74157028.mzfilter,nil))
		end
		g1:AddCard(tc)
		g1:Merge(g2)
		Duel.Destroy(g1,REASON_EFFECT)
	end
end