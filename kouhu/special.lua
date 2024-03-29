local extraTypes=TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK
local bannedCards={
  27279764,
  77832858,
  88071625,
  44910027,
  26205777,
  91810826,
  65326118,
  33393090,
  3078576,
  17375316,
  33423043,
  42829885,
  44763025,
  35371948,
  15800838,
  21076084,
  35316708,
  43262273,
  49587034,
  55773067,
  4440873,
}


local function announceCard(tp,extra)
  local opCodes={extraTypes,OPCODE_ISTYPE}
  if not extra then
    table.insert(opCodes,OPCODE_NOT)
  end
  for _,bannedCard in ipairs(bannedCards) do
    table.insert(opCodes,bannedCard)
    table.insert(opCodes,OPCODE_ISCODE)
    table.insert(opCodes,OPCODE_NOT)
    table.insert(opCodes,OPCODE_AND)
  end
  local code=Duel.AnnounceCard(tp,table.unpack(opCodes))
  local c=Duel.CreateToken(tp,code)
  return c
end


function Auxiliary._init(e)
  local c1=announceCard(1)
  Duel.SendtoHand(c1,1,REASON_RULE)
  local c2=announceCard(0)
  Duel.SendtoHand(c2,0,REASON_RULE)
  local deckCard=announceCard(0)
  Duel.SendtoDeck(deckCard,0,0,REASON_RULE)
  local extraCard=announceCard(0,true)
  Duel.SendtoDeck(extraCard,0,0,REASON_RULE)


  local e1=Effect.GlobalEffect()
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
  e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()>1
  end)
  e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetTurnPlayer()
    -- announce 2 cards and 1 extra
    local c1=announceCard(p)
    local c2=announceCard(p)
    Duel.SendtoDeck(c2,p,0,REASON_RULE)
    Duel.SendtoDeck(c1,p,0,REASON_RULE)
    local extraCard=announceCard(p,true)
    Duel.SendtoDeck(extraCard,p,0,REASON_RULE)
  end)
  Duel.RegisterEffect(e1,0)

  local function getTributeCount(e,c)
    local count=0
    if e:GetCode()==EFFECT_LIMIT_SUMMON_PROC or e:GetCode()==EFFECT_LIMIT_SET_PROC then
      count=3
    elseif c:IsLevelAbove(7) then
      count=2
    else
      count=1
    end
    return count
  end

  local te=Effect.CreateEffect(c1)
  te:SetDescription(11)
  te:SetType(EFFECT_TYPE_SINGLE)
  te:SetCode(EFFECT_SUMMON_PROC)
  te:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  te:SetCondition(function(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    local count=getTributeCount(e,c)
    return Duel.CheckLPCost(tp,count*1000) and not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
  end)
  te:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c)
    if chk==0 then return true end
    local count=getTributeCount(e,c)
    Duel.PayLPCost(tp,count*1000)
    c:SetMaterial(nil)
  end)
  te:SetValue(SUMMON_TYPE_ADVANCE)

  --any monster can advanced summon by paying 1000*count LP
  local function makeGrant(code,cond)
    local se=te:Clone()
    se:SetCode(code)
    local e2=Effect.GlobalEffect()
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
    e2:SetTarget(function(e,c)
      return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_RITUAL+TYPE_SPSUMMON) and cond(c)
    end)
    e2:SetLabelObject(se)
    Duel.RegisterEffect(e2,0)
  end

  makeGrant(EFFECT_SUMMON_PROC, function(c)
    return c:IsLevelAbove(5) and not c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC)
  end)

  makeGrant(EFFECT_SET_PROC, function(c)
    return c:IsLevelAbove(5) and not c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC) and not c:IsHasEffect(EFFECT_LIMIT_SET_PROC)
  end)

  makeGrant(EFFECT_LIMIT_SUMMON_PROC, function(c)
    return c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC)
  end)

  makeGrant(EFFECT_LIMIT_SET_PROC, function(c)
    return c:IsHasEffect(EFFECT_LIMIT_SET_PROC)
  end)

  e:Reset()
end

function Auxiliary.PreloadUds()
  Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(Auxiliary._init)
	Duel.RegisterEffect(e1,0)

	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_REVERSE_DECK)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	Duel.RegisterEffect(e2,0)

  -- cannot draw when deck empty
  for p=0,1 do
    local e2=Effect.GlobalEffect()
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_DRAW)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetCondition(function(e)
      return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_DECK,0)==0
    end)
    Duel.RegisterEffect(e2,p)
  end


  local old_duel_draw=Duel.Draw
  Duel.Draw=function(p,count,reason)
    local deckCount = Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
    if deckCount<count then
      count=deckCount
    end
    return old_duel_draw(p,count,reason)
  end
end
