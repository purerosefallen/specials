--スクラップ・フィスト
function c8529136.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8529136)
	e1:SetTarget(c8529136.thtg)
	e1:SetOperation(c8529136.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8529136,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,8529137)
	e2:SetTarget(c8529136.target)
	e2:SetOperation(c8529136.activate)
	c:RegisterEffect(e2)
end
function c8529136.thfilter(c)
	return c:IsAttackBelow(1500) and c:IsRace(RACE_WARRIOR+RACE_MACHINE) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c8529136.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8529136.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c8529136.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c8529136.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c8529136.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()<PHASE_MAIN2
end
function c8529136.filter(c)
	return c:IsFaceup() and c:IsCode(60800381) and c:GetFlagEffect(8529136)==0
end
function c8529136.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c8529136.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8529136.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c8529136.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c8529136.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(8529136)==0 then
			tc:RegisterFlagEffect(8529136,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0,1)
			e1:SetCondition(c8529136.actcon)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PIERCE)
			e2:SetCondition(c8529136.effcon)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
			e3:SetCondition(c8529136.damcon)
			e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e3,true)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e4:SetCondition(c8529136.effcon)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e4)
		end
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_DAMAGE_STEP_END)
		e5:SetCondition(c8529136.descon)
		e5:SetOperation(c8529136.desop)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e5,true)
	end
end
function c8529136.actcon(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and c:GetBattleTarget()~=nil
		and e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c8529136.effcon(e)
	return e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c8529136.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c8529136.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tc and tc:IsRelateToBattle() and e:GetOwnerPlayer()==tp
end
function c8529136.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	Duel.Hint(HINT_CARD,0,8529136)
	Duel.Destroy(tc,REASON_EFFECT)
end
