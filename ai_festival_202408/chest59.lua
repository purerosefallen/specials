CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "宝箱时代"

function CHEST.MessageAbsolute(rp)
    return "突然间，不知谁吼了一句：“这个时代已经是宝箱怪的时代了！”"
end

CHEST.EffectMessage = "感觉场上要发生巨变了……"

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local g=Duel.GetFieldGroup(rp,LOCATION_MZONE,LOCATION_MZONE)
    Duel.SendtoGrave(g,REASON_RULE)
    local c=Duel.CreateToken(rp,1102515)
    while Duel.SpecialSummon(c,0,rp,rp,true,true,POS_FACEUP)>0 do
        c=Duel.CreateToken(rp,1102515)
    end
    c=Duel.CreateToken(1-rp,1102515)
    while Duel.SpecialSummon(c,0,1-rp,1-rp,true,true,POS_FACEUP)>0 do
        c=Duel.CreateToken(1-rp,1102515)
    end
end