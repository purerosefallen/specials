--AI祭-231024-世界BOSS活动 窥视深渊的发牌姬
--发牌姬会有1或16张额外，第1或16张额外为龙魔导（37818794）
--这张卡开局时会被撕掉（标记为AI）
--或，发牌姬额外【仅有】2张龙魔导，则发牌姬会在自己能抽卡的第一个回合抽到5老I。

--对方怪兽卡>=3 -> 多抽张雷击
--对方后场>=3 -> 多抽张羽毛扫
--对方LP<=1000 -> 多抽2张火球
--对方手卡>=5 -> 多抽张强引的番兵
--（以上可叠加）
--自己LP<=1000 -> 抽卡固定为5
--以上条件全部不满足 ->多抽1张

local CUNGUI={}
function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.CheckAI)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.CheckAI(e)
    local a0 = Duel.GetFieldGroupCount(0, LOCATION_EXTRA, 0)
    local a1 = Duel.GetFieldGroupCount(1, LOCATION_EXTRA, 0)
    local c0 = Duel.GetMatchingGroup(Card.IsCode, 0, LOCATION_EXTRA, 0, nil, 37818794)
    local c1 = Duel.GetMatchingGroup(Card.IsCode, 1, LOCATION_EXTRA, 0, nil, 37818794)
    if a0 > 15 and #c0>0 then
        if #c0 < 3 then Duel.Exile(c0,REASON_RULE) end
        CUNGUI.StartAI(0,#c0 == 2)
    end
    if a1 > 15 and #c1>0 or ex1 then
        if #c1 < 3 then Duel.Exile(c1,REASON_RULE) end
        CUNGUI.StartAI(1,#c1 == 2)
    end
    e:Reset()
end

function CUNGUI.StartAI(tp,ex)
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
    e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.BeforeDraw)
    if ex then
        e1:SetLabel(1)
    end
	Duel.RegisterEffect(e1,tp)
	--Draw
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
    e2:SetLabel(1)
	e2:SetValue(CUNGUI.DrawCount)
    e1:SetLabelObject(e2)
	Duel.RegisterEffect(e2,tp)
end
function CUNGUI.CreateCard(tp,code)
    local c=Duel.CreateToken(tp, code)
    Duel.SendtoDeck(c,tp,SEQ_DECKTOP,REASON_RULE)
end
function CUNGUI.BeforeDraw(e,tp)
    if Duel.GetTurnCount()==1 then return end
    if Duel.GetTurnPlayer()~=tp then
        e:GetLabelObject():SetLabel(1)
        return
    end
    if e:GetLabel()==1 then
        CUNGUI.CreateCard(tp,8124921)
        CUNGUI.CreateCard(tp,44519536)
        CUNGUI.CreateCard(tp,70903634)
        CUNGUI.CreateCard(tp,7902349)
        CUNGUI.CreateCard(tp,33396948)
        e:GetLabelObject():SetLabel(5)
        return
    end
    local draw=Duel.GetDrawCount(tp)
    if Duel.GetFieldGroupCount(tp, 0, LOCATION_MZONE)>=3 then
        CUNGUI.CreateCard(tp,12580477)
        draw=draw + 1
    end
    if Duel.GetFieldGroupCount(tp, 0, LOCATION_SZONE)>=3 then
        CUNGUI.CreateCard(tp,18144506)
        draw=draw + 1
    end
    if Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND)>=5 then
        CUNGUI.CreateCard(tp,42829885)
        draw=draw + 1
    end
    if Duel.GetLP(1-tp)<=1000 then
        CUNGUI.CreateCard(tp,46130346)
        CUNGUI.CreateCard(tp,46130346)
        draw=draw + 2
    end
    if Duel.GetLP(tp)<=1000 then
        draw=5
    end
    if draw == Duel.GetDrawCount(tp) then
        draw = draw + 1
    end
    e:GetLabelObject():SetLabel(draw)
end

function CUNGUI.DrawCount(e)
	return e:GetLabel() or 1
end
