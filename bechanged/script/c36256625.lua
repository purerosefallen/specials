--超级交通机人-巨大钻头
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,44729197,71218746,99861526,false,false)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(s.sprcon)
	e3:SetOperation(s.sprop)
	c:RegisterEffect(e3)
end


-------set
function s.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END) 
	e1:SetCountLimit(1)   
	e1:SetOperation(s.xsetop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
end 
function s.setfilter(c)
	return c:IsSetCard(0x16) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.xsetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)	   
	end
end

-----spsummon

function s.sprfilter1(c,sc)
	return c:IsFusionSetCard(0x16) and c:IsFusionType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function s.sprfilter2(c,tp,sc)
	return c:IsFusionCode(71218746) and c:IsAbleToRemoveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.sprfilter1,tp,LOCATION_HAND,0,1,nil,c)
		and Duel.IsExistingMatchingCard(s.sprfilter2,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,s.sprfilter1,tp,LOCATION_HAND,0,1,1,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,s.sprfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,POS_FACEUP,REASON_COST)
end
