CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "一个宇宙"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    local g=Duel.GetMatchingGroup(CHEST.filter,rp,LOCATION_EXTRA,0,nil,e,rp)
    if #g<1 then
        return "但是它好像已经热寂了……"
    end
    return name .. "呼唤着宇宙的力量！"
end

function CHEST.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,true,true)
        and Duel.GetLocationCountFromEx(rp,rp,nil,c)>0
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local g=Duel.GetMatchingGroup(CHEST.filter,rp,LOCATION_EXTRA,0,nil,e,rp):RandomSelect(rp,1)
    while Duel.SpecialSummon(g,0,rp,rp,true,true,POS_FACEUP)>0 do
        g=Duel.GetMatchingGroup(CHEST.filter,rp,LOCATION_EXTRA,0,nil,e,rp):RandomSelect(rp,1)
    end
end