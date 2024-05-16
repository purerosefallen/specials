local skillLists={}

local function addSkill(code, skill)
  if not skillLists[code] then
	skillLists[code]={}
  end
  table.insert(skillLists[code], skill)
end

local function getAllSkillCodes()
  local skillCodes={}
  for code,_ in pairs(skillLists) do
	table.insert(skillCodes, code)
  end
  return skillCodes
end

local function registerSkillForPlayer(tp, code)
  local skills=skillLists[code]
  for _,skill in ipairs(skills) do
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	skill(e1)
	Duel.RegisterEffect(e1,tp)
  end
end

local function wrapDeckSkill(code, effectFactory)
  addSkill(code, function(e2)
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_DECK)
	effectFactory(e1)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_DECK,0)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(function(e,c)
	  local dg=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_DECK,0)
	  if #dg==0 then return false end
	  local minc=dg:GetMinGroup(Card.GetSequence):GetFirst()
	  return c==minc
	end)
	e2:SetLabelObject(e1)
  end)
end

local function phaseSkill(code, phase, op, con, both)
  wrapDeckSkill(code, function(e1)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+phase)
		e1:SetCountLimit(1,0x7ffffff-code)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return (both or Duel.GetTurnPlayer()==tp) and (not con or con(e,tp,eg,ep,ev,re,r,rp))
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_CARD,0,code)
			op(e,tp,eg,ep,ev,re,r,rp)
		end)
  end)
end

local function oneTimeSkill(code, op)
  addSkill(code, function(e1)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	  Duel.Hint(HINT_CARD,0,code)
	  op(e,tp,eg,ep,ev,re,r,rp)
	  e:Reset()
	end)
  end)
end

local function standbyPhaseSkill(code, op, con, both)
  phaseSkill(code, PHASE_STANDBY, op, con, both)
end

local function endPhaseSkill(code, op, con, both)
  phaseSkill(code, PHASE_END, op, con, both)
end

standbyPhaseSkill(48356796, function(e,tp,eg,ep,ev,re,r,rp)
  Duel.Draw(tp,2,REASON_RULE)
end)

phaseSkill(22959079, PHASE_BATTLE_START, function(e,tp,eg,ep,ev,re,r,rp)
  local a1,a2,a3=Duel.TossCoin(tp,3)
  local result=(a1+a2+a3)*2
  local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
  local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  local num=#g
  if num>result then num=result end
  local rg=g:RandomSelect(tp,num)
  num=#g2
  if num>result then num=result end
  local rg2=g2:RandomSelect(tp,num)
  Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
  Duel.Remove(rg2,POS_FACEUP,REASON_EFFECT)
end,nil,true)

standbyPhaseSkill(2295831, function(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
  end
end, function(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(Card.IsAbleToHand, tp, LOCATION_DECK, 0, 1, nil)
end)

standbyPhaseSkill(84257639, function(e,tp,eg,ep,ev,re,r,rp)
  Duel.Recover(tp,8000,REASON_EFFECT)
end)

endPhaseSkill(19523799, function(e,tp,eg,ep,ev,re,r,rp)
  Duel.Damage(1-tp,3200,REASON_EFFECT)
end)

for _,event in ipairs({EVENT_SUMMON_SUCCESS,EVENT_FLIP_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS}) do
  wrapDeckSkill(23434538, function(e1)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(event)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	  local count = eg:FilterCount(function(c)
		return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER)
	  end, 1, nil)
	  return ep~=tp and count>0 and Duel.GetMZoneCount(tp)>=count
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	  Duel.Hint(HINT_CARD,0,23434538)
	  local tg=eg:Filter(function(c)
		return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER)
	  end, nil)
	  for tc in aux.Next(tg) do
		local cc=Duel.CreateToken(tp,tc:GetOriginalCode())
		Duel.MoveToField(cc,tp,tp,LOCATION_MZONE,tc:GetPosition(),true)
	  end
	end)
  end)
end

wrapDeckSkill(1372887, function(e1)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_CHAIN_SOLVED)
  e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and not re:GetHandler():IsType(TYPE_TOKEN)
  end)
  e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1372887)
	local cc=Duel.CreateToken(tp,re:GetHandler():GetOriginalCode())
	Duel.SendtoHand(cc,nil,REASON_RULE)
	if(cc:IsLocation(LOCATION_HAND)) then
	  Duel.ConfirmCards(1-tp,cc)
	end
	Duel.ShuffleHand(tp)
  end)
end)

function c69015963_filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_ATTACK) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

standbyPhaseSkill(69015963, function(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c69015963_filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end, function(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c69015963_filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end)

standbyPhaseSkill(14532163, function(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end, function(e,tp)
  return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
end)

phaseSkill(71490127, PHASE_BATTLE_START, function(e,tp,eg,ep,ev,re,r,rp)
  local num=#Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_SZONE,0,nil)
  for _=1,num do
	local tc=Duel.CreateToken(tp,99267150)
	Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
  end
end, function(e,tp)
  return (#Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_SZONE,0,nil))>0
end,true)

addSkill(9952083, function(e1)
  e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0xff)
end)

local function destroyReplaceFilter(c,tp)
  return c:IsControler(tp) and (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE))
end

addSkill(47529357, function(e1)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(destroyReplaceFilter,1,nil,tp) end
	return true
  end)
	e1:SetValue(function(e,c)
	return destroyReplaceFilter(c,e:GetHandlerPlayer())
  end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,47529357)
  end)
end)

standbyPhaseSkill(73915051, function(e,tp,eg,ep,ev,re,r,rp)
  local count=math.min((Duel.GetMZoneCount(tp)),4)
  for i=1,count do
	local token=Duel.CreateToken(tp,73915051+i)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
  end
  Duel.SpecialSummonComplete()
end, function(e,tp,eg,ep,ev,re,r,rp)
  return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,73915052,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH)
end)

function c69015963_filter(c,e,tp)
  return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

addSkill(53239672, function(e1)
  e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(function(e)
	Duel.Hint(HINT_CARD,0,53239672)
	return 0
  end)
  e1:SetCondition(function(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0
  end)
end)

endPhaseSkill(53239672, function(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end, function(e,tp)
  return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) and Duel.GetTurnPlayer()==1-tp and Duel.GetActivityCount(1-tp,ACTIVITY_ATTACK)==0 and Duel.GetTurnCount()>1
end, true)

oneTimeSkill(13171876, function(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetDecktopGroup(1-tp,8)
  Duel.Exile(g,REASON_RULE)
  for i=1,8 do
		local tc=Duel.CreateToken(1-tp,13171876)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCode(EVENT_DRAW)
		e1:SetCountLimit(1)
		e1:SetOperation(c13171876_op)
		tc:RegisterEffect(e1)
		Duel.SendtoDeck(tc,nil,0,REASON_RULE)
  end
	local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	local startCount=#hg
  Duel.SendtoDeck(hg,nil,0,REASON_RULE)
	Duel.ShuffleDeck(1-tp)
  Duel.Draw(1-tp,startCount,REASON_RULE)
end)

function c13171876_op(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)-3000
	if lp<0 then lp=0 end
	Duel.SetLP(tp,lp)
end

oneTimeSkill(66957584,function(e,tp,eg,ep,ev,re,r,rp)
  for i=1,3 do
		local tc=Duel.CreateToken(tp,66957584)
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP_ATTACK,true)
  end
end)

addSkill(66957584,function(e1)
  e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
  e1:SetCondition(function(e)
		return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
  end)
	e1:SetValue(function(e,re,tp)
		return re:GetHandler():IsLocation(LOCATION_HAND)
	end)
end)

oneTimeSkill(21082832, function(e,tp,eg,ep,ev,re,r,rp)
  for i=1,5 do
		local tc=Duel.CreateToken(tp,55410871)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
		--cannot remove
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CANNOT_REMOVE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:CompleteProcedure()
  end
end)

function c18940556_tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget() end
  local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c18940556_tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
  if #g>0 then
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
  end
end

local function initializeLion(e,tp)
  Duel.Hint(HINT_CARD,0,4392470)
  local cc=Duel.CreateToken(tp,4392470)
  Duel.MoveToField(cc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
  local e4=Effect.CreateEffect(cc)
	e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(4392470)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetReset(RESET_EVENT+RESETS_STANDARD)
  e4:SetTargetRange(1,0)
  cc:RegisterEffect(e4,true)
  local e1=Effect.CreateEffect(cc)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_ADD_TYPE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
  e1:SetDescription(1016)
  e1:SetValue(TYPE_EFFECT)
  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
  cc:RegisterEffect(e1,true)
  local e4=Effect.CreateEffect(cc)
	e4:SetDescription(aux.Stringid(18940556,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_CONFIRM)
	e4:SetTarget(c18940556_tgtg)
	e4:SetOperation(c18940556_tgop)
  e4:SetReset(RESET_EVENT+RESETS_STANDARD)
  cc:RegisterEffect(e4,true)
end

wrapDeckSkill(4392470, function(e1)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_ADJUST)
  e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,4392470)
  end)
  e1:SetOperation(initializeLion)
end)

standbyPhaseSkill(42829885, function(e,tp,eg,ep,ev,re,r,rp)
  local p=tp
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
	end
end, function(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.GetTurnPlayer()==1-tp
end, true)

addSkill(99177923, function(e1)
  e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
	e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
end)

endPhaseSkill(99177923, function(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetDecktopGroup(tp,8)
	Duel.DisableShuffleCheck()
  Duel.Exile(g,REASON_EFFECT)
end, function(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetLP(tp)<=0
end)

wrapDeckSkill(72283691, function(e4)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCondition(c72283691_atkcon)
	e4:SetOperation(c72283691_atkop)
end)

function c72283691_atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	return tc:IsControler(1-tp)
end

local function destroyGold(tc)
	Duel.Hint(HINT_CARD,0,72283691)
	local atk=math.floor(tc:GetAttack()/2)
	local tp=tc:GetControler()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(tp,atk,REASON_EFFECT)
	end
end

function c72283691_atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	destroyGold(tc)
end

--桃李代僵（和睦的使者）
addSkill(12607053, function(e1)
	e1:SetType(EFFECT_TYPE_FIELD)
	  e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_PLAYER_TARGET)
	  e1:SetTargetRange(1,0)
	  e1:SetCode(EFFECT_CHANGE_DAMAGE)
	  e1:SetValue(0)
	  e1:SetCondition(function (e)
		return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_DECK,0)>=25
	  end)
end)

oneTimeSkill(12607053, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_DECK,0)==35 then
		local tc=Duel.CreateToken(tp,95308449)
		Duel.SendtoHand(tc,tp,REASON_RULE)
		Duel.ConfirmCards(1-tp,tc)
	end
end)

--兵临城下（六武之门）
oneTimeSkill(27970830, function(e,tp,eg,ep,ev,re,r,rp)
	for i=1,3 do
		local tc=Duel.CreateToken(tp,27970830)
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_CANNOT_REMOVE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetRange(LOCATION_SZONE)
		tc:RegisterEffect(e2)
		tc:CompleteProcedure()
		tc:AddCounter(0x3,99)
	end
end)

--草船借箭（敌人操纵器）
endPhaseSkill(98045062, function(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()>ct then
		g=g:Select(tp,ct,ct,nil)
	end
	for tc in aux.Next(g) do
		Duel.GetControl(tc,tp)
	end
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(sg) do
		Duel.SendtoGrave(tc,REASON_RULE)
	end
end, function(e,tp)
	return Duel.GetTurnPlayer()==1-tp
end, true)

--4个2（赌博）
wrapDeckSkill(37313786, function(e1)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c37313786_op)
end)

endPhaseSkill(37313786, function (e,tp,eg,ep,ev,re,r,rp)
	c37313786_op(e,tp,eg,ep,ev,re,r,rp)
end, nil, true)

function c37313786_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=0
	local dice=0
	for i=1,4 do
		local dc=Duel.TossDice(tp,1)
		if dc==2 then ct=ct+1 end
		dice=dice+dc
	end
	if ct>0 then
		if Duel.GetAttacker() then
			Duel.NegateAttack()
		end
        if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=2*ct then
			local g=Duel.GetDecktopGroup(1-tp,2*ct)
            Duel.DisableShuffleCheck()
            Duel.Remove(g,POS_FACEUP,REASON_RULE)
        end
		if ct==4 then
			local lp=Duel.GetLP(1-tp)-20220222
			if lp<0 then lp=0 end
			Duel.SetLP(1-tp,lp)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(dice*100)
	Duel.RegisterEffect(e1,tp)
end

--[[
wrapDeckSkill(72283691, function(e4)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c72283691_chaincon)
	e4:SetOperation(c72283691_chainop)
end)

function c72283691_chaincon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and tc and tc:IsControler(1-tp) and tc:IsOnField()
end

function c72283691_chainop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	destroyGold(tc)
end
]]

local function initialize()
  local skillSelections={}
  local skillCodes=getAllSkillCodes()
  local res=Duel.TossCoin(0,1)
  for tp=1-res, res, 2*res-1 do
    local codes={}
	for _,code in ipairs(skillCodes) do
		table.insert(codes,code)
	end
    table.sort(codes)
    local afilter={codes[1],OPCODE_ISCODE}
    if #codes>1 then
        for i=2,#codes do
            table.insert(afilter,codes[i])
            table.insert(afilter,OPCODE_ISCODE)
            table.insert(afilter,OPCODE_OR)
        end
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
    local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	skillSelections[tp]=ac
  end
  for tp=0,1 do
	registerSkillForPlayer(tp,skillSelections[tp])
  end
end

function Auxiliary.PreloadUds()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		initialize()
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end
