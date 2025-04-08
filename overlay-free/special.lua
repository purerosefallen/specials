function aux.PreloadUds()
  local e1=Effect.GlobalEffect()
	e1:SetDescription(aux.Stringid(58600555,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
  e1:SetCountLimit(1,20000000)
  local function alterf(c,e,tp,xyzc)
    if xyzc:IsSetCard(0x1048) then
      return c:IsSetCard(0x48) and aux.GetXyzNumber(c)==aux.GetXyzNumber(xyzc) and c:IsRank(xyzc:GetRank()-1) and not c:IsSetCard(0x1048)
    else
      return c:IsRank(xyzc:GetRank()-1) and c:IsRace(xyzc:GetRace()) and not c:IsSetCard(0x1073) and not c:IsSetCard(0x48)
    end
  end
  local params={aux.FALSE,13,2,2,alterf,aux.Stringid(58600555,2),nil}
	e1:SetCondition(function(e,tp,...)
    return Duel.GetFlagEffect(tp,e:GetHandler():GetOriginalCode()+10)==0 and Auxiliary.XyzConditionAlter(table.unpack(params))(e,tp,...)
  end)
	e1:SetTarget(Auxiliary.XyzTargetAlter(table.unpack(params)))
	e1:SetOperation(function(e,tp,...)
    Duel.RegisterFlagEffect(tp,e:GetHandler():GetOriginalCode()+10,RESET_PHASE+PHASE_END,0,1)
    return Auxiliary.XyzOperationAlter(table.unpack(params))(e,tp,...)
  end)
  e1:SetValue(SUMMON_TYPE_XYZ)

  local e2=Effect.GlobalEffect()
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
  e2:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
  e2:SetTarget(function(e,c)
    return (c:IsSetCard(0x1048) or c:IsSetCard(0x1073)) and c:IsType(TYPE_XYZ)
  end)
  e2:SetLabelObject(e1)
  e2:SetValue(1)
  Duel.RegisterEffect(e2,0)

  local e = Effect.GlobalEffect()
  e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e:SetCode(EVENT_ADJUST)
  e:SetOperation(function (this_e)
    for tp = 0, 1, 1 do
      for c in aux.Next(Duel.GetFieldGroup(tp, LOCATION_ALL, 0)) do
        RITUAL.SP(c)
        if c:IsType(TYPE_RITUAL) then
          if c:IsType(TYPE_MONSTER) then
            RITUAL.CHK_LIST[tp][TYPE_MONSTER] = RITUAL.CHK_LIST[tp][TYPE_MONSTER] + 1
          elseif c:IsType(TYPE_SPELL) then
            RITUAL.CHK_LIST[tp][TYPE_SPELL] = RITUAL.CHK_LIST[tp][TYPE_SPELL] + 1
          end
        end
        if c:IsCode(38445524) then
          c_38445524.CannotActivate(c)
          c_38445524.ATK(c)
        end
      end
    end
    this_e:Reset()
  end)
  Duel.RegisterEffect(e,0)
end
LOCATION_ALL = 0xff

c_38445524 = {
  CannotActivate = function (c)
    local e=Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_FIELD)
    e:SetCode(EFFECT_CANNOT_ACTIVATE)
    e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
    e:SetRange(LOCATION_ALL)
    e:SetTargetRange(1,1)
    e:SetValue(function (e,re,rp)
      local rc=re:GetHandler()
      return rc:IsCode(29095457)
    end)
    c:RegisterEffect(e)
  end,
  ATK = function (c)
    local this_e1=Effect.CreateEffect(c)
    this_e1:SetType(EFFECT_TYPE_SINGLE)
    this_e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
    this_e1:SetCode(EFFECT_SET_BASE_ATTACK)
    this_e1:SetValue(1000000)
    c:RegisterEffect(this_e1)
    local this_e2 = this_e1:Clone()
    this_e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    c:RegisterEffect(this_e2)
  end
}

RITUAL = {
  CHK_LIST = {
    [0] = {
      [TYPE_MONSTER] = 0,
      [TYPE_SPELL] = 0
    },
    [1] = {
      [TYPE_MONSTER] = 0,
      [TYPE_SPELL] = 0
    }
  },
  CHK_FUNC = function (tp)
    return RITUAL.CHK_LIST[tp][TYPE_MONSTER] >= 2 and RITUAL.CHK_LIST[tp][TYPE_SPELL] >= 2 and RITUAL.CHK_LIST[tp][TYPE_MONSTER] + RITUAL.CHK_LIST[tp][TYPE_SPELL] >= 5
  end,
  SP = function (c)
    local e = Effect.CreateEffect(c)
    e:SetDescription(1075)
    e:SetType(EFFECT_TYPE_FIELD)
    e:SetCode(EFFECT_SPSUMMON_PROC)
    e:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e:SetRange(LOCATION_HAND)
    e:SetCountLimit(1,66666666 + EFFECT_COUNT_CODE_OATH)
    e:SetCondition(function (this_e)
      local this_c = this_e:GetHandler()
      if not RITUAL.CHK_FUNC(this_e:GetHandlerPlayer()) then return false end
      return this_c:IsType(TYPE_RITUAL) and this_c:IsType(TYPE_MONSTER) and this_c:IsRace(RACE_WARRIOR + RACE_FAIRY)
    end)
    e:SetTarget(function (this_e,tp,eg,ep,ev,re,r,rp,chk,this_c)
      local lp = this_c:GetLevel() * 500
      if Duel.CheckLPCost(tp, lp) then
        e:SetLabel(lp)
        return true
      else return false end
    end)
    e:SetOperation(function (this_e,tp,eg,ep,ev,re,r,rp,this_c)
      Duel.PayLPCost(tp,e:GetLabel())
    end)
    c:RegisterEffect(e)
  end
}