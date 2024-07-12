CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "死者苏生"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    if not (Duel.GetLocationCount(rp,LOCATION_MZONE)>0
    and Duel.IsExistingMatchingCard(CHEST.filter,rp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,rp)) then
        return "但似乎没有合适的死者……"
    end
    return name .. "使用了死者苏生！"
end

function CHEST.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_MONSTER_REBORN,tp,false,false)
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
	Duel.Hint(HINT_SELECTMSG,rp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(rp,c83764718.filter,rp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,rp)
    local tc=g:GetFirst()
    if aux.NecroValleyFilter()(tc)
        Duel.SpecialSummon(tc,SUMMON_VALUE_MONSTER_REBORN,rp,rp,false,false,POS_FACEUP)
    end
end