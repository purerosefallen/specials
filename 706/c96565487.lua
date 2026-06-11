--ブリザード・ウォリアー
---@param c Card
function c96565487.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(96565487,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetLabel(65703851) --相杀算场上发动统一使用透破拔卡片密码标记处理类透破拔条件
	e1:SetCondition(aux.dserodcon)
	e1:SetOperation(c96565487.operation)
	c:RegisterEffect(e1)
end
function c96565487.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	local tc=g:GetFirst()
	local opt=Duel.SelectOption(tp,aux.Stringid(96565487,1),aux.Stringid(96565487,2))
	if opt==1 then
		Duel.MoveSequence(tc,opt)
	end
end
