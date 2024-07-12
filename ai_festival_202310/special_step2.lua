--AI祭-231024-世界BOSS活动 窥视深渊的发牌姬 Step2
--发牌姬会有16张额外，开局多抽1张卡。

--event 1
--AI的抽卡阶段：
--对方怪兽卡>=3 -> 多抽张雷击
--对方后场>=3 -> 多抽张羽毛扫
--对方LP<=1000 -> 多抽2张火球
--对方手卡>=5 -> 多抽张强引的番兵
--（以上可叠加）
--自己LP<=1000 -> 抽卡固定为5
--以上条件全部不满足 ->多抽1张


--event 2:
--人类手卡+场上的卡+4<=AI手卡+场上的卡的场合，决斗中只有1次：
--将以下怪兽中的1只表侧攻击表示特殊召唤到玩家场上
--90673288 #水刀
--37818794 #龙魔导
--60461804 #凤凰人
--29432356 #神星龙
--48626373 #阿莱斯哈特
--32909498 #芬里尔狼
--41685633 #雷神龙-雷龙
--84330567 #水仙女人鱼
--21522601 #玻璃女巫

--event 3:
--人类在自己的抽卡阶段手卡<=2的场合，决斗中只有1次：
--从卡组外把以下卡中的随机1张加入手卡。
--55144522 #强欲之壶
--79571449 #天使的施舍
--74191942 #苦涩的选择
--54447022 #灵魂补充
--4031928 #心变
--31305911 #棉花糖
--72589042 #辉煌的逆转之女神

--event 4:
--在第6/第7回合，人类自己的抽卡阶段：
--从卡组外把以下卡中的随机1张加入手卡。
--12580477 #雷击
--83764718 #死者苏生
--18144506 #羽毛扫
--44095762 #圣防
--62279055 #魔法筒

--event 5:
--在第10/第11回合，人类自己的抽卡阶段：
--AI从特殊召唤列表中尽可能多地将怪兽表侧攻击特殊召唤到AI的场上。
--从卡组外把以下卡加入人类手卡。
--54693926 #冥王结界波
--15693423 #颉颃胜负
--04392470 #狮子男巫

--event 6:
--AI的准备阶段：
--AI从特殊召唤列表中将1只怪兽表侧攻击特殊召唤到自己场上。
--这之后，如果AI场上只有1只怪兽，再重复1次特殊召唤。

--event 7:
--AI的抽卡前：
--AI的基本分恢复（上个回合的基本分-本回合的基本分）/2，最小为0

--特殊召唤列表：
--27279764 #物质主义
--40061558 #无神论
--99267150 #五神龙
--62873545 #究极龙骑士
--72989439 #大开辟
--98630720 #前托枪管龙
--31833038 #装弹枪管龙
--98127546 #冥神
--86221741 #究极猎鹰
--80611581 #帝企
--52085072 #绝望神
--63468625 #机皇神 机录
--69120785 #白界丧失龙
--31764700 #于贝尔-极度悲伤的魔龙
--82103466 #蛇神 格
--84433295 #五阵魔术师
--04167084 #黎明之堕天使 路西法
--13331639 #霸王龙 扎克
--08505920 #合体魔神-门之守护神
--21123811 #宇宙耀变龙
--37442336 #宇宙类星龙
--97836203 #科技属 戟炮手
--97489701 #真红莲新星龙
--15982593 #骑士皇 
--95095116 #炽天之骑士 盖亚日珥
--18666161 #死狱乡演员·镜框舞台龙
--40939228 #流天救世星龙
--41517789 #星态龙
--62180201 #邪神 恐惧之源
--47084486 #虚无魔人
--33746252 #威光魔人
--21208154 #邪神 神之化身
--57793869 #邪神 抹灭者
--14799437 #狱火机·拿玛
--23440231 #狱火机·莉莉丝
--10669138 #连神龙
--21637210 #防火龙·奇点
--03134857 #机械乐团
--29479265 #来迎
--08763963 #天蝇王
--27572350 #深渊之神兽
--72402069 #白地狱终末神
--30604579 #极神皇 托尔
--96633955 #承影
--84815190 #鲜花女男爵
--67508932 #时械神祖
--87460579 #五光
--60465049 #念力终结处刑者
--23288411 #冥地王龙
--91588074 #创星神 提耶拉
--25451652 #堕天使 路西法
--22073844 #神龙四教导
--47556396 #磁魔神
--51522296 #凶导的白天底
--68199168 #哈尔王
--06150044 #天位骑士
--37663536 #古代的机械超巨人
--75286621 #梅尔卡巴
--58481572 #暗爪

--在第1回合的抽卡阶段，有50%几率从固定配置中随机初始场面。
--没能配置的场合，AI从特殊召唤列表中特殊召唤1只怪兽到AI场上。如果为先攻，再特召1张。


local CUNGUI={}
math.random = Duel.GetRandomNumber or math.random
local orig_ist = Card.IsSummonType
function Card.IsSummonType(c,sumtype)
	if c:GetFlagEffect(87654321)>0 then
		return (sumtype & SUMMON_TYPE_ADVANCE)>0
	end
	if c:GetFlagEffect(87654322)>0 then
		return (sumtype & SUMMON_TYPE_FUSION)>0
	end
	return orig_ist(c,sumtype)
end

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
	--local c0 = Duel.GetMatchingGroup(Card.IsCode, 0, LOCATION_EXTRA, 0, nil, 37818794)
	--local c1 = Duel.GetMatchingGroup(Card.IsCode, 1, LOCATION_EXTRA, 0, nil, 37818794)
	if a0 == 16 then
		Duel.Draw(0,0,REASON_RULE)
		CUNGUI.StartAI(0,false)
		CUNGUI.StartHuman(1)
	elseif a1 == 16 then
		Duel.Draw(1,1,REASON_RULE)
		CUNGUI.StartAI(1,false)
		CUNGUI.StartHuman(0)
	end
	e:Reset()
end

CUNGUI.Event2List = {90673288,37818794,60461804,29432356,48626373,32909498,41685633,84330567,21522601}
CUNGUI.Event3List = {55144522,79571449,74191942,54447022,4031928,31305911,72589042}
CUNGUI.Event4List = {12580477,83764718,18144506,44095762,62279055}
CUNGUI.SPList = {27279764,40061558,99267150,62873545,72989439,98630720,31833038,98127546,86221741,
80611581,52085072,63468625,69120785,31764700,82103466,84433295,4167084,13331639,
8505920,21123811,37442336,97836203,97489701,15982593,95095116,18666161,40939228,
41517789,62180201,47084486,33746252,21208154,57793869,14799437,23440231,10669138,
21637210,3134857,29479265,8763963,27572350,72402069,30604579,96633955,84815190,
67508932,87460579,60465049,23288411,91588074,25451652,22073844,47556396,51522296,
68199168,6150044,37663536,75286621,58481572}

function CUNGUI.InitSpecial1(ga,gb,tp)
	local c=gb:GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(6000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	c=ga:GetFirst()
	if c:IsCode(92731385) then c=ga:GetNext() end
	c:RegisterFlagEffect(87654322,RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET,0,2)
	c=Duel.CreateToken(tp,98127546)
	Duel.SendtoDeck(c,nil,2,REASON_RULE)
end

function CUNGUI.InitSpecial2(ga,gb,tp)
	local c=ga:GetFirst()
	if not c:IsCode(3285552) then c=ga:GetNext() end
	local tc=Duel.CreateToken(tp,38745520)
	Duel.Equip(tp,tc,c)
end

function CUNGUI.InitSpecial3(ga,gb,tp)
	for c in aux.Next(gb) do
		c:RegisterFlagEffect(87654321,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	if Duel.GetTurnPlayer()==tp then
		local cc=Duel.CreateToken(1-tp,10000040)
		Duel.SendtoHand(cc,nil,REASON_RULE)
	end
	local tc=Duel.CreateToken(1-tp,10000020)
	Duel.SendtoDeck(tc,nil,2,REASON_RULE)
	tc=Duel.CreateToken(1-tp,10000080)
	Duel.SendtoDeck(tc,nil,2,REASON_RULE)
end

function CUNGUI.InitSpecial4(ga,gb,_)
	local c=ga:GetFirst()
	c:RegisterFlagEffect(37818795,RESET_EVENT+RESETS_STANDARD,0,1,2)
end

function CUNGUI.InitSpecial5(ga,gb,tp)
	for _=1,3 do
		local c=Duel.CreateToken(1-tp,16308000)
		Duel.SendtoGrave(c,REASON_RULE)
	end
end

function CUNGUI.InitSpecial6(ga,gb,tp)
	local c=Duel.CreateToken(1-tp,72883039)
	Duel.MoveToField(c,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
end

function CUNGUI.InitSpecial7(ga,gb,tp)
	local c=gb:GetFirst()
	while not c:IsCode(84013237) do
		c=gb:GetNext()
	end
	if not c:IsLocation(LOCATION_MZONE) then return end
	local g=Group.CreateGroup()
	for i=1,3 do
		local tc = Duel.CreateToken(c:GetControler(), 50185950)
		g:AddCard(tc)
	end
	if Duel.SendtoHand(g, c:GetControler(), REASON_RULE)~=3 then return end
	Duel.Overlay(c,g)
end

CUNGUI.InitList = {{{26077387},{10963799,47961808,73356503,19740112,46145256},false},
{{92731385,84330567},{11738489},CUNGUI.InitSpecial1}, --11738489要加6000攻，再给玩家印一张冥神98127546
{{3285552,2563463},{23693634,84815190,40854197,34408491},CUNGUI.InitSpecial2}, --3285552要装备38745520
{{32909498,68304193,31149212},{10000000,10000090,10000020},CUNGUI.InitSpecial3}, --三幻神设为非特召，卡组印一张球和一张原版鸟。若为玩家回合，手卡印一张创世神
{{37818794},{12298909,12298909,12298909,86221741},CUNGUI.InitSpecial4}, --龙骑兵可发动2次效果
{{32909498,68304193,31149212},{69890967,6007213,32491822},CUNGUI.InitSpecial5}, --墓地扔3张神之威光
{{35952884,24696097},{8967776,7733560,33015627,28929131,91712985},CUNGUI.InitSpecial6}, --后场给一张72883039
{{15291624},{44508094,84013237,16178681,5043010},CUNGUI.InitSpecial7}, --给霍普加素材
{{29432356},{27279764,40061558,14799437,23440231},false},
{{21522601,84523092},{99267150,99267150,99267150,99267150,99267150},false},
{{62420419},{21208154,21208154,21208154},false},
{{46986414,44508094,89943723},{89631139,1546123,70902743},false},
}

function CUNGUI.StartHuman(tp)
	--event 2
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.Event2)
	Duel.RegisterEffect(e1,tp)

	--event 3
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.Event3)
	Duel.RegisterEffect(e1,tp)

	--event 4
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.Event4)
	Duel.RegisterEffect(e1,tp)

	--event 5
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.Event5)
	Duel.RegisterEffect(e1,tp)

	if not _G.ev6 then
		--event 6
		e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCountLimit(1)
		e1:SetOperation(CUNGUI.InitField)
		Duel.RegisterEffect(e1,tp)
		_G.ev6 = true
	end

end

function CUNGUI.RandomSummon(tp)
	local id=CUNGUI.SPList[math.random(#CUNGUI.SPList)]
	local c=Duel.CreateToken(tp,id)
	if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_ATTACK)>0 then
		c:CompleteProcedure()
		return true
	end
	return false
end

function CUNGUI.InitField(e,tp)
	if math.random(2)==1 then
		local tbl = CUNGUI.InitList[math.random(#CUNGUI.InitList)]
		local ga=tbl[1] --Summon for human
		local gb=tbl[2] --Summon for AI
		local func=tbl[3] --Special function
		for _,code in pairs(ga) do
			local c=Duel.CreateToken(tp,code)
			Duel.SpecialSummonStep(c,0,tp,tp,true,true,POS_FACEUP_ATTACK)
			c:CompleteProcedure()
		end
		for _,code in pairs(gb) do
			local c=Duel.CreateToken(1-tp,code)
			Duel.SpecialSummonStep(c,0,1-tp,1-tp,true,true,POS_FACEUP_ATTACK)
			c:CompleteProcedure()
		end
		Duel.SpecialSummonComplete()
		if func then
			func(Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0),Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD),tp)
		end
	else
		CUNGUI.RandomSummon(1-tp)
		if Duel.GetTurnPlayer()==1-tp then
			CUNGUI.RandomSummon(1-tp)
		end
	end
	e:Reset()
end

CUNGUI.LockEvent2 = false
function CUNGUI.Event2(e,tp)
	CUNGUI.LockEvent2 = true
	if not CUNGUI.LockEvent2 and Duel.GetMZoneCount(tp)>0 and
		((Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0) + 4
		<= Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND))
		or (Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp
		and Duel.GetLP(tp) <= 2000)) then
		local id = CUNGUI.Event2List[math.random(#CUNGUI.Event2List)]
		local c=Duel.CreateToken(tp,id)
		if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_ATTACK)>0 then
			c:CompleteProcedure()
			e:Reset()
		end
	end
	CUNGUI.LockEvent2 = false
end

function CUNGUI.CreateCardToHand(tp,id)
	local c=Duel.CreateToken(tp,id)
	Duel.SendtoHand(c,nil,REASON_RULE)
end

function CUNGUI.Event3(e,tp)
	if Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2 then
		local id = CUNGUI.Event3List[math.random(#CUNGUI.Event3List)]
		CUNGUI.CreateCardToHand(tp,id)
		e:Reset()
	end
end

function CUNGUI.Event4(e,tp)
	if Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()>=6 then
		local id=CUNGUI.Event4List[math.random(#CUNGUI.Event4List)]
		CUNGUI.CreateCardToHand(tp,id)
		e:Reset()
	end
end

function CUNGUI.Event5(e,tp)
	if Duel.GetTurnCount()>=10 and Duel.GetLP(tp)<=3000 then
		while CUNGUI.RandomSummon(1-tp) do end
		CUNGUI.CreateCardToHand(tp,54693926)
		CUNGUI.CreateCardToHand(tp,15693423)
		CUNGUI.CreateCardToHand(tp,4392470)
		e:Reset()
	end
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
	--event 5.5
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetOperation(CUNGUI.StandbySPSummon)
	Duel.RegisterEffect(e3,tp)
	--event 7
	e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetOperation(CUNGUI.AIRecover)
	e3:SetCountLimit(1)
	Duel.RegisterEffect(e3,tp)
end

CUNGUI.LastLife = 8000
function CUNGUI.AIRecover(e,tp)
	if Duel.GetTurnPlayer()==tp then
		local lp = Duel.GetLP(tp)
		if lp < CUNGUI.LastLife then
			Duel.SetLP(tp,lp + (CUNGUI.LastLife - lp) / 2)
		end
		CUNGUI.LastLife = Duel.GetLP(tp)
	end
end

function CUNGUI.CreateCard(tp,code)
	local c=Duel.CreateToken(tp, code)
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_RULE)
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

function CUNGUI.StandbySPSummon(e,tp)
	if Duel.GetTurnCount()<2 or Duel.GetTurnPlayer()~=tp
		or Duel.GetCurrentPhase()~=PHASE_STANDBY or e:GetLabel()==Duel.GetTurnCount() then return end
	e:SetLabel(Duel.GetTurnCount())
	CUNGUI.RandomSummon(tp)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 then
		CUNGUI.RandomSummon(tp)
	end
end