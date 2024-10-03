CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Message = "结果宝箱里突然跳出了好几只怪兽！"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(e,rp))
function CHEST.EffectMessageAbsolute(e,rp)
    local name=CUNGUI.GetPlayerName()
    local name2=CUNGUI.GetAIName()
    if rp == CUNGUI.AI then name2,name = name,name2 end
    local c=Duel.CreateToken(rp,99267150)
    if Duel.GetLocationCountFromEx(rp,rp,nil,c)<1
        or not Duel.IsPlayerCanSpecialSummonMonster(1-rp,99267150,0,TYPE_MONSTER+TYPE_EFFECT+TYPE_FUSION,5000,5000,12,RACE_DRAGON,ATTRIBUTE_DARK) then return "然而，场上似乎并没有什么变化……" end
    return name2 .. "的场上多了些东西！"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    if not Duel.IsPlayerCanSpecialSummonMonster(1-rp,99267150,0,TYPE_MONSTER+TYPE_EFFECT+TYPE_FUSION,5000,5000,12,RACE_DRAGON,ATTRIBUTE_DARK) then return end
    local c=Duel.CreateToken(rp,99267150)
    while Duel.SpecialSummonStep(c,0,1-rp,1-rp,true,true,POS_FACEUP_ATTACK)>0 do
        c=Duel.CreateToken(rp,99267150)
    end
    Duel.SpecialSummonComplete()
end