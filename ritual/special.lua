
RITUAL = {
    CARD_LIST = {},
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

table.indexOf = function (table, element)
    for i, value in ipairs(table) do
        if value == element then
            return i
        end
    end
    return -1
end

function Auxiliary.PreloadUds()
    local e = Effect.GlobalEffect()
	e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e:SetCode(EVENT_ADJUST)
	e:SetOperation(function ()
        for tp = 0, 1, 1 do
            for c in aux.Next(Duel.GetFieldGroup(tp, 0xff, 0)) do
                if table.indexOf(RITUAL.CARD_LIST, c) > 0 then goto continue end
                RITUAL.SP(c)
                if c:IsType(TYPE_RITUAL) then
                    if c:IsType(TYPE_MONSTER) then
                        RITUAL.CHK_LIST[tp][TYPE_MONSTER] = RITUAL.CHK_LIST[tp][TYPE_MONSTER] + 1
                    elseif c:IsType(TYPE_SPELL) then
                        RITUAL.CHK_LIST[tp][TYPE_SPELL] = RITUAL.CHK_LIST[tp][TYPE_SPELL] + 1
                    end
                end
                table.insert(RITUAL.CARD_LIST, c)
                :: continue ::
            end
        end
    end)
	Duel.RegisterEffect(e,0)
end