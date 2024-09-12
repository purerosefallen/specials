local skillLists={}
local skillSelections={}

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
  Duel.Draw(tp,5,REASON_RULE)
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
	local g=Group.CreateGroup()
	for i = 1, 2, 1 do
		local ac=Duel.AnnounceCard(tp,TYPE_TOKEN,OPCODE_ISTYPE,OPCODE_NOT)
		local c=Duel.CreateToken(tp,ac)
		g:AddCard(c)
	end
	Duel.SendtoHand(g,nil,REASON_RULE)
	Duel.ConfirmCards(1-tp,g)
end)

--治疗之神
standbyPhaseSkill(84257639, function(e,tp,eg,ep,ev,re,r,rp)
  Duel.Recover(tp,100000,REASON_EFFECT)
end)

addSkill(84257639, function(e1)
	e1:SetType(EFFECT_TYPE_FIELD)
	  e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_PLAYER_TARGET)
	  e1:SetTargetRange(1,0)
	  e1:SetCode(EFFECT_CHANGE_DAMAGE)
	  e1:SetValue(function (e,re,val,r,rp,rc)
		return val/2
	end)
end)

addSkill(84257639, function(e1)
	e1:SetType(EFFECT_TYPE_FIELD)
	  e1:SetCode(EFFECT_HAND_LIMIT)
	  e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_PLAYER_TARGET)
	  e1:SetTargetRange(1,0)
	  e1:SetValue(3)
end)

--大火事
endPhaseSkill(19523799, function(e,tp,eg,ep,ev,re,r,rp)
  Duel.Damage(1-tp,800,REASON_EFFECT)
end)

addSkill(19523799, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_ATTACK_COST)
    e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetCost(c19523799_cost)
    e1:SetOperation(c19523799_op)
end)

addSkill(19523799, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_ACTIVATE_COST)
    e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetCost(c19523799_cost)
    e1:SetOperation(c19523799_op)
end)

addSkill(19523799, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_COST)
    e1:SetTargetRange(0,0x7f)
    e1:SetCost(c19523799_cost)
    e1:SetOperation(c19523799_op)
end)

function c19523799_cost(e,c,tp)
    return Duel.CheckLPCost(tp,400)
end

function c19523799_op(e,tp,eg,ep,ev,re,r,rp)
    Duel.PayLPCost(tp,400)
end

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

--闪电风暴
standbyPhaseSkill(14532163, function(e,tp,eg,ep,ev,re,r,rp)
	if skillSelections[1-tp]==47529357 then return end
  local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_RULE)
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
  return c:IsControler(tp) and (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE)) and c:GetReasonPlayer()==1-tp
end

--雾状躯体
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
addSkill(47529357, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_REMOVE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
	e1:SetTarget(function (e,c,p)
		return c:IsControler(e:GetHandlerPlayer())
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

wrapDeckSkill(13171876, function(e1)
	local code=13171876
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,0x7ffffff-code)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()==1-tp
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,0,code)
		local n=Duel.GetMatchingGroupCount(function (tc)
			return tc:IsFaceupEx() and tc:IsCode(13171876)
		end,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
		v=2+n
		for i=1,v do
			local tc=Duel.CreateToken(1-tp,code)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
			e2:SetCode(EVENT_DRAW)
			e2:SetCountLimit(1)
			e2:SetOperation(c13171876_op)
			tc:RegisterEffect(e2)
			Duel.SendtoDeck(tc,nil,0,REASON_RULE)
		end
		Duel.ShuffleDeck(1-tp)
	end)
end)

function c13171876_op(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)-3000
	if lp<0 then lp=0 end
	Duel.SetLP(tp,lp)
end

addSkill(13171876, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
	e1:SetCondition(function (e)
		local tp=e:GetHandlerPlayer()
		local lp_tp=Duel.GetLP(tp)
		local lp_op=Duel.GetLP(1-tp)
		return lp_tp>lp_op and lp_tp-lp_op>=1000
	end)
    e1:SetValue(function (e,re,val,r,rp,rc)
		if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
			return val/2
		end
		return val
	end)
end)

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

--釜底抽薪(强引的番兵)
endPhaseSkill(42829885, function(e,tp,eg,ep,ev,re,r,rp)
  local p=tp
	local g=Duel.GetFieldGroup(p,0,LOCATION_DECK)
	if g:GetCount()>=8 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,8,8,nil)
		Duel.SendtoHand(sg,p,REASON_RULE)
		Duel.ConfirmCards(1-p,g)
	end
end, function(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=8 and Duel.GetTurnPlayer()==1-tp
end, true)

--奇门遁甲(永火恶魔)
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
  	Duel.SendtoGrave(g,REASON_RULE)
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
	local g=Duel.GetMatchingGroup(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()>ct then
		g=g:Select(tp,ct,ct,nil)
	end
	for tc in aux.Next(g) do
		Duel.GetControl(tc,tp)
	end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(sg) do
		Duel.SendtoGrave(tc,REASON_RULE)
	end
end, function(e,tp)
	return Duel.GetTurnPlayer()==1-tp and Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)>=3
end, true)

wrapDeckSkill(98045062, function (e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_MSET)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetTarget(aux.TRUE)
end)

wrapDeckSkill(98045062, function (e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SSET)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetTarget(aux.TRUE)
end)

wrapDeckSkill(98045062, function (e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_TURN_SET)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetTarget(aux.TRUE)
end)

wrapDeckSkill(98045062, function (e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetTarget(function (e,c,sump,sumtype,sumpos,targetp)
		return bit.band(sumpos,POS_FACEDOWN)~=0
	end)
end)

wrapDeckSkill(98045062, function (e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetValue(function (e,te,tp)
		if not te:IsHasType(EFFECT_TYPE_ACTIVATE) or not te:IsActiveType(TYPE_TRAP) then return false end
		return te:GetHandler():IsLocation(LOCATION_HAND)
	end)
end)

wrapDeckSkill(98045062, function (e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BP)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0
	end)
    e1:SetTargetRange(0,1)
end)

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

--五行旗阵（背水之阵）
addSkill(32603633, function(e1)
	e1:SetType(EFFECT_TYPE_FIELD)
	  e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_PLAYER_TARGET)
	  e1:SetTargetRange(1,0)
	  e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	  e1:SetCondition(function (e)
		return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
	  end)
end)

oneTimeSkill(32603633, function(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.FromCards(Duel.CreateToken(tp,69025477),Duel.CreateToken(tp,95519486),Duel.CreateToken(tp,31904181),Duel.CreateToken(tp,90397998),Duel.CreateToken(tp,64398890))
	for tc in aux.Next(g) do
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
		c32603633_createeffect(tp,tc)
	end
end)

function c32603633_createeffect(tp,tc)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1500)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(tc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	tc:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	tc:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	tc:RegisterEffect(e5)
	local e6=Effect.CreateEffect(tc)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c32603633_con)
	e6:SetOperation(c32603633_op)
	Duel.RegisterEffect(e6,tp)
	tc:CompleteProcedure()
end

function c32603633_con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end

function c32603633_op(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetHandler():GetOriginalCode()
	Duel.Hint(HINT_CARD,0,code)
	local cc=Duel.CreateToken(tp,code)
	Duel.MoveToField(cc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	c32603633_createeffect(tp,cc)
	local lp=Duel.GetLP(1-tp)-1500
	if lp<0 then lp=0 end
	Duel.SetLP(1-tp,lp)
	local g=Duel.GetDecktopGroup(1-tp,8)
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_RULE)
end

--四象之阵
oneTimeSkill(13513663, function(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.FromCards(Duel.CreateToken(tp,26400609),Duel.CreateToken(tp,53804307),Duel.CreateToken(tp,89399912),Duel.CreateToken(tp,90411554))
	Duel.SendtoGrave(g,REASON_RULE)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCondition(c13513663_con)
		e1:SetOperation(function ()
			Duel.RegisterFlagEffect(tp,100000000+tc:GetOriginalCode(),RESET_PHASE+PHASE_END+EFFECT_FLAG_OATH,0,1)
		end)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetDescription(2)
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_REMOVE)
		e2:SetTarget(c13513663_tg)
		e2:SetOperation(c13513663_op)
		tc:RegisterEffect(e2)
	end
end)

function c13513663_con(e,c)
    if c==nil then return true end
    if c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsLocation(LOCATION_GRAVE) then return false end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,100000000+c:GetOriginalCode())==0
end

function c13513663_tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,100000000+c:GetOriginalCode())==0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.RegisterFlagEffect(tp,100000000+c:GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c13513663_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end

standbyPhaseSkill(13513663,function (e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function (tc)
		return tc:IsCanBeSpecialSummoned(e,0,tp,true,true) and tc:IsType(TYPE_MONSTER)
		and (tc:IsAttribute(ATTRIBUTE_FIRE) or tc:IsAttribute(ATTRIBUTE_EARTH) or tc:IsAttribute(ATTRIBUTE_WATER) or tc:IsAttribute(ATTRIBUTE_WIND))
	end,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dabcheck,true,0,4)
	Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
end, nil, true)

--突破极限(流天)
oneTimeSkill(35952884, function(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.FromCards(Duel.CreateToken(tp,90953320),Duel.CreateToken(tp,90953320),Duel.CreateToken(tp,90953320))
	Duel.SendtoDeck(g,nil,0,REASON_RULE)
	local tc=Duel.CreateToken(tp,53855409)
	Duel.SendtoGrave(tc,REASON_RULE)
end)

addSkill(35952884, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(0,1)
    e1:SetValue(function (e,re)
		return re:GetHandler():IsCode(94145021,27204311,91800273)
	end)
end)

addSkill(35952884, function(e1)
	e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_REMOVE)
    e1:SetTargetRange(0,1)
	e1:SetTarget(function (e,c,rp,r,re)
		local tp=e:GetHandlerPlayer()
		return c:IsFaceupEx() and c:IsControler(tp) and rp==1-tp and c:IsType(TYPE_SYNCHRO)
	end)
end)

addSkill(35952884, function(e1)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function (e,c)
		return c:IsType(TYPE_SYNCHRO) and c:GetControler()==e:GetHandlerPlayer()
	end)
end)

--远交近攻(强制转移) 
endPhaseSkill(31036355, function (e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,LOCATION_MZONE,0,0,5,nil)
	for tc in aux.Next(g) do
		Duel.GetControl(tc,1-tp)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_PHASE+RESETS_STANDARD)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		tc:RegisterEffect(e3)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e4)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e5)
		local e6=Effect.CreateEffect(tc)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_UNRELEASABLE_SUM)
		e6:SetValue(1)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e6)
		local e7=e6:Clone()
		e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e7)
		local e8=Effect.CreateEffect(tc)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_CANNOT_ATTACK)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e8)
	end
end, nil, true)

addSkill(31036355,function (e1)
    e1:SetDescription(aux.Stringid(37991342,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND,0)
    e1:SetTarget(function (e,c,minc)
		if c==nil then return true end
		return c:IsLevelAbove(5) and c:IsLevelBelow(6) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	end)
end)

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

addSkill(37626500, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_REMOVE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    e1:SetTarget(c37626500_target)
end)

addSkill(37626500, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetValue(1)
    e1:SetTarget(c37626500_target)
end)

addSkill(37626500, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetValue(1)
    e1:SetTarget(c37626500_target)
end)

addSkill(37626500, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetValue(1)
    e1:SetTarget(c37626500_target)
end)

addSkill(37626500, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetCondition(function (e,tp)
		return Duel.IsExistingMatchingCard(function (c)
			return c:IsType(TYPE_RITUAL) and c:IsFaceup()
		end,tp,LOCATION_MZONE,0,1,nil)
	end)
    e1:SetValue(-3000)
end)

function c37626500_target(e,c,rp,r,re)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_RITUAL) and c:IsFaceup()
end

wrapDeckSkill(37626500, function(e1)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=Duel.GetAttacker()
	  return c:IsType(TYPE_RITUAL)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,0,37626500)
		local v=Duel.GetFlagEffectLabel(tp,37626500)
		if type(v)=="number" then
			v=v+1
			Duel.ResetFlagEffect(tp,37626500)
			Duel.RegisterFlagEffect(tp,37626500,0,0,1,v)
		else
			Duel.RegisterFlagEffect(tp,37626500,0,0,1,1)
		end
	end)
end)

wrapDeckSkill(37626500, function(e1)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local v=Duel.GetFlagEffectLabel(tp,37626500)
		if type(v)=="number" and v==5 then
			Duel.Win(tp,0x1)
			Duel.ResetFlagEffect(tp,37626500)
		end
	end)
end)

standbyPhaseSkill(37626500, function (e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	local sg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if g:IsExists(c37626500_filter,1,nil) then
		sg=g:FilterSelect(tp,c37626500_filter,1,5,nil)
	else
		sg=Duel.SelectMatchingCard(tp,c37626500_filter,tp,LOCATION_DECK,0,1,2,nil)
	end
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,tp,REASON_RULE)
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.ShuffleHand(1-tp)
end)

function c37626500_filter(c)
	return c:IsType(TYPE_RITUAL) or c:IsRace(RACE_FAIRY) or c:IsSetCard(0x1a6)
end

addSkill(94820406, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHAIN_MATERIAL)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTarget(function (e,te,tp)
		if te:GetHandler():GetOriginalCode()~=94820406 then return Group.CreateGroup() end
		return Duel.GetMatchingGroup(function (c)
			return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(te)
		end,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	end)
    e1:SetOperation(function (e,te,tp,tc,mat,sumtype)
		if not sumtype then sumtype=SUMMON_TYPE_FUSION end
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,POS_FACEUP)
		end)
    e1:SetValue(aux.TRUE)
end)

addSkill(94820406, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetValue(aux.tgoval)
	e1:SetTarget(function (e,c)
		return c:IsType(TYPE_FUSION) and c:IsSetCard(0x6008) and c:IsFaceup()
	end)
end)

addSkill(94820406, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(function (e)
		local ph=Duel.GetCurrentPhase()
		return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
	end)
	e1:SetTarget(function (e,c)
		return c:IsType(TYPE_FUSION) and c:IsSetCard(0x6008) and c:IsFaceup()
	end)
end)

addSkill(94820406, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(function (e,tp)
		local c=Duel.GetAttacker()
		if c:IsType(TYPE_FUSION) and c:IsSetCard(0x6008) and c:IsFaceup() then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_BASE_ATTACK)
            e1:SetValue(c:GetBaseAttack()*2)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            c:RegisterEffect(e1)
		end
	end)
end)

addSkill(51684157, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(function (e)
		local ph=Duel.GetCurrentPhase()
		return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
	end)
	e1:SetTarget(function (e,c)
		local mg = c:GetMaterial()
		return c:IsType(TYPE_SYNCHRO) and mg and mg:IsExists(function (tc)
			return (tc:IsRace(RACE_WYRM) or tc:IsSetCard(0x1a2))
		end,1,nil) and c:IsFaceup()
	end)
end)

addSkill(51684157, function(e1)
	e1:SetDescription(aux.Stringid(37991342,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetTargetRange(LOCATION_HAND,0)
    e1:SetCondition(function (e,c,minc)
		if c==nil then return true end
		return minc==0 and (c:IsRace(RACE_WYRM) or c:IsSetCard(0x1a2)) and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	end)
end)

addSkill(51684157, function (e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetValue(999)
end)

addSkill(51684157, function (e1)
	e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(function (e,c)
		return not (c:IsRace(RACE_WYRM) or c:IsSetCard(0x1a2))
	end)
end)

addSkill(51684157, function (e1)
	e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_MSET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(function (e,c)
		return not (c:IsRace(RACE_WYRM) or c:IsSetCard(0x1a2))
	end)
end)

standbyPhaseSkill(51684157, function (e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,function (tc)
		return tc:IsRace(RACE_WYRM) or tc:IsSetCard(0x1a2)
	end,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,10,nil)
	if g:GetCount()>0 then
		local mg=g:Filter(function(c) return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,nil)
		local ft=math.min((Duel.GetMZoneCount(tp)), 5)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=mg:Select(tp,0,ft,nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
		local ag=g-sg
		if ag:GetCount()>0 then
			Duel.SendtoHand(ag,tp,REASON_RULE)
		end
	end
end)

addSkill(92714517, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(function (e)
		return Duel.IsExistingMatchingCard(function (tc)
			return tc:IsLevelAbove(8) and c:IsSetCard(0x17e) and c:IsFaceup()
		end,tp,LOCATION_MZONE,0,1,nil)
	end)
	e1:SetTarget(function (e,c)
		return (c:IsSetCard(0x17e) and c:IsFaceup()) or c:IsFacedown()
	end)
end)

standbyPhaseSkill(92714517, function (e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>5 then ft=5 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,function (tc)
		return tc:GetType()==TYPE_TRAP
	end,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end, nil, true)

addSkill(92714517, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetTargetRange(LOCATION_SZONE,0)
    e1:SetTarget(function (e,c)
		return c:GetType()==TYPE_TRAP
	end)
end)

local function initialize()
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
