CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "一场噩梦"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    if Duel.GetMatchingGroupCount(CHEST.filter,rp,LOCATION_MZONE,0,nil)>0
        and Duel.GetMZoneCount(1-rp)>0 then
        return "在噩梦中，" .. name .. "心爱的怪兽似乎被NTR了……"
    end
    return name .. "凭借自己坚强的意志走出了梦魇！"
end

function CHEST.filter(c)
    return c:IsAbleToChangeControler()
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local g=Duel.GetMatchingGroup(CHEST.filter,rp,LOCATION_MZONE,0,nil):RandomSelect(1-rp,1)
    if #g>0 and Duel.GetMZoneCount(1-rp)>0 then
        Duel.GetControl(g, 1-rp)
    end
end