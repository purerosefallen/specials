--サウザンド・アイズ・サクリファイス
function c63519819.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddMaterialCodeList(c,64631466,27125110)
	aux.AddFusionProcFun2(c,c63519819.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_ILLUSION+RACE_FIEND+RACE_SPELLCASTER),true)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(63519819,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c63519819.eqtg)
	e1:SetOperation(c63519819.eqop)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c63519819.antarget)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e3)
	--atk/def	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c63519819.atkval)
	c:RegisterEffect(e4)
	--def
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(c63519819.defval)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(c63519819.indtg)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function c63519819.ffilter(c)
	return c:IsCode(64631466,27125110)
end
function c63519819.can_equip_monster(c)
	return true
end
function c63519819.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c63519819.eqlimit(e,c)
	return e:GetOwner()==c
end
function c63519819.equip_monster(c,tp,tc)
	if not Duel.Equip(tp,tc,c,false) then return end
	--Add Equip limit
	tc:RegisterFlagEffect(63519819,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c63519819.eqlimit)
	tc:RegisterEffect(e1)
end
function c63519819.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
		c63519819.equip_monster(c,tp,tc)
	end
end
function c63519819.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c63519819.antarget(e,c)
	return c~=e:GetHandler()
end
function c63519819.indtg(e,c)
	local tc=e:GetHandler()
	return c==tc or c==tc:GetBattleTarget()
end
function c63519819.atkval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(63519819)~=0 and tc:IsFaceup() and tc:GetAttack()>=0 then
			atk=atk+tc:GetAttack()
		end
		tc=g:GetNext()
	end
	return atk
end
function c63519819.defval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(63519819)~=0 and tc:IsFaceup() and tc:GetDefense()>=0 then
			atk=atk+tc:GetDefense()
		end
		tc=g:GetNext()
	end
	return atk
end