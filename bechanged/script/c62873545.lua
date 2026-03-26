--究極竜騎士
function c62873545.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddMaterialCodeList(c,5405694,23995346)
	--material
	aux.AddFusionProcFun2(c,c62873545.matfilter1,c62873545.matfilter2,true)
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62873545,0))
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c62873545.wincon)
	e1:SetOperation(c62873545.winop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c62873545.atkval)
	c:RegisterEffect(e2)
end
function c62873545.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c62873545.atkval(e,c)
	return Duel.GetMatchingGroupCount(c62873545.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c)*500
end
function c62873545.matfilter1(c)
	return c:IsFusionCode(5405694) or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE,tp)
		or c:IsFusionSetCard(0xcf) and c:IsType(TYPE_RITUAL)
end
function c62873545.matfilter2(c)
	return c:IsFusionCode(23995346) or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE,tp)
		or c:IsFusionSetCard(0xdd) and c:IsType(TYPE_FUSION)
end
function c62873545.winfilter(e,c)
	return c:GetOwner()==1-e:GetHandlerPlayer()
		and c:GetPreviousCodeOnField()==99267150
end
function c62873545.wincon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then tc=Duel.GetAttackTarget() end
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c62873545.winfilter(e,tc)
end
function c62873545.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_GUARDIAN_GOD_EXODIA=0xa0
	Duel.Win(tp,WIN_REASON_GUARDIAN_GOD_EXODIA)
end