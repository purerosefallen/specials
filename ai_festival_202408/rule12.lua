SP_RULE={}
--如果没有规则卡，填false
SP_RULE.Card=81380218
--如果设为true，则InitAdjust方法不会在执行后被reset
SP_RULE.AlwaysAdjust = false
--如果设为大于0的值，则InitAdjust方法会带上CountLimit
SP_RULE.AdjustCountLimit = 0

SP_RULE.RuleName="人均胡狗"
--虽然没有限制，但ygopro最多显示5行文字
SP_RULE.Message={"硬币投掷出的结果无论正反均当作正面，骰子投掷出的结果无论数值均当作6处理。",
                    "仍可用卡片效果修改结果，但没有实际意义，仍当作正面/6点处理。"}

local dueltd = Duel.TossDice
Duel.TossDice = function(tp,p1,p2)
    dueltd(tp,p1,p2)
    if p2~=nil then p1 = p1 + p2 end
    if p1 > 5 then p1 = 5 end
    local result={}
    for i=1,p1 do
        table.insert(result,6)
    end
    return table.unpack(result)
end

local dueltc = Duel.TossCoin
Duel.TossCoin = function(tp,num)
    dueltc(tp,num)
    if num > 5 then num = 5 end
    local result={}
    for i=1,num do
        table.insert(result,1)
    end
    return table.unpack(result)
end
