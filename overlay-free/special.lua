function aux.PreloadUds()
  local e1=Effect.GlobalEffect()
	e1:SetDescription(aux.Stringid(58600555,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
  local function alterf(c,e,tp,xyzc)
    if xyzc:IsSetCard(0x1048) then
      return c:IsSetCard(0x48) and aux.GetXyzNumber(c)==aux.GetXyzNumber(xyzc) and c:IsRank(xyzc:GetRank()-1) and not c:IsSetCard(0x1048)
    else
      return c:IsRank(xyzc:GetRank()-1) and c:IsRace(xyzc:GetRace()) and not c:IsSetCard(0x1073) and not c:IsSetCard(0x48)
    end
  end
  local params={aux.FALSE,13,2,2,alterf,aux.Stringid(58600555,2),nil}
	e1:SetCondition(Auxiliary.XyzConditionAlter(table.unpack(params)))
	e1:SetTarget(Auxiliary.XyzTargetAlter(table.unpack(params)))
	e1:SetOperation(Auxiliary.XyzOperationAlter(table.unpack(params)))
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
end
