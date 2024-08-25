SP_RULE={}
SP_RULE.Card=56889
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = true
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 1

SP_RULE.RuleName="洗牌风暴"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message={"决斗开始时，双方从卡组随机将20张卡里侧除外。","每个抽卡阶段，回合玩家将那些除外的卡的随机2张加入手卡。",
                    "（那些卡发生过移动后，即从随机列表中除外）"}

--第一个抽卡阶段执行，tp是AI
function SP_RULE.InitAdjust(tp)
    if not SP_RULE.IsInit then
        local g=Duel.GetFieldGroup(0,LOCATION_DECK,0):RandomSelect(tp,20)
        local g2=Duel.GetFieldGroup(0,LOCATION_DECK,0):RandomSelect(tp,20)
        g:Merge(g2)
        Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
        for c in aux.Next(g) do
            c:RegisterFlagEffect(98765432,RESET_EVENT+RESETS_STANDARD,0,1)
        end
        SP_RULE.IsInit = true
    end

    local m = Duel.GetMatchingGroup(SP_RULE.filter,Duel.GetTurnPlayer(),LOCATION_REMOVED,0,nil)
    if not m then return end
    if #m > 2 then
        m = m:RandomSelect(Duel.GetTurnPlayer(),2)
    end
    Duel.SendtoHand(m,nil,REASON_RULE)
end
function SP_RULE.filter(c)
    return c:GetFlagEffect(98765432)>0
end