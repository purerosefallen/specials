--AI祭-202408-世界BOSS活动 森罗无尽的万华镜
--Boss会有1或16张额外，第1或16张额外为龙魔导（37818794）
--这张卡开局时会被撕掉（标记为AI）

--回合开始时，回合玩家抽1张赌博卡。
--AI手卡在2以下，则额外抽到【圣杯A】
--AI基本分在700以下，则额外抽到【大逆转谜题】【风魔手里剑】
--玩家基本分在2000以下，则额外抽到【命运的分岔道】【火焰飞镖】
--玩家手卡6以上，AI手卡2以下，额外抽到【赌博】
--玩家后场3以上，额外抽到【骰子旋风】
--玩家怪兽3以上，额外抽到【时间的魔术师】【二重召唤】
--玩家后场5张，抽卡阶段直接发动【同花顺】

--特殊规则
--载入各个特殊规则。

--兜底
math.random = Duel.GetRandomNumber or math.random
CUNGUI={}

CUNGUI.AI = 0
CUNGUI.SummoningChest = false


--赌博卡列表
CUNGUI.GambleCards = {3280747,37812118,50470982,43061293,37313786,3493058,38299233,25173686,71625222,36562627,19162134,81172176,
						21598948,39537362,36378044,38143903,96012004,62784717,84290642,3549275,41139112,36708764,74137509,126218,
						93078761,76895648,22802010,83241722,84397023,31863912,39454112,59905358,5990062,9373534,58577036}

function CUNGUI.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.CheckAI)
	Duel.RegisterEffect(e1,0)

	--要执行的特殊规则
	--本次活动中，一阶段=8，二阶段=13
	local RULE_MAX_INDEX = 13
	Duel.LoadScript("rule" .. tostring(math.random(RULE_MAX_INDEX)) .. ".lua")
	if SP_RULE and SP_RULE.Init then
		SP_RULE.Init()
	end
    if math.random(2)==1 then
        InitRefreshChest()
		Debug.Message("宝箱怪们在蠢蠢欲动……")
    end
end

CUNGUI.ChestCheck=10

function InitRefreshChest()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(CUNGUI.RefreshChestCheck)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.RefreshChestCheck(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(table.unpack(CUNGUI.GambleCards)) then
		if math.random(CUNGUI.ChestCheck) == 1 then
			if CUNGUI.CreateChest(math.random(2)-1) then
				CUNGUI.ChestCheck = CUNGUI.ChestCheck + 2
			end
		end
		CUNGUI.ChestCheck = math.max(1, CUNGUI.ChestCheck - 1)
	end
end

function CUNGUI.CreateChest(tp)
	local c = CUNGUI.CreateChestStep(tp)
	Duel.SpecialSummonComplete()
	return c
end

CUNGUI.Chests={}
CUNGUI.Chests[0]={}
CUNGUI.Chests[1]={}
function CUNGUI.CreateChestStep(tp)
	local c=Duel.CreateToken(tp,1102515)
	if not Duel.SpecialSummonStep(c,0,tp,tp,true,true,POS_FACEUP_ATTACK) then return nil end
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetReset(RESET_EVENT+RESET_TOFIELD+RESET_MSCHANGE+RESET_TEMP_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(CUNGUI.chestcond)
	e1:SetTarget(CUNGUI.chesttg)
	e1:SetOperation(CUNGUI.chestop)
	c:RegisterEffect(e1)

	table.insert(CUNGUI.Chests[tp],c)
	return c
end

function CUNGUI.chestcond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE)
end

CUNGUI.ChestEffectIndex=70 --待调整

function CUNGUI.chesttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local i=math.random(CUNGUI.ChestEffectIndex)
	e:SetLabel(i)
	local p = Duel.GetAttacker():GetControler()
	Duel.LoadScript("chest" .. tostring(i) .. ".lua")

	if CHEST then
		local name = CUNGUI.GetPlayerName()
		if CUNGUI.AI == p then
			name = CUNGUI.GetAIName()
		end
		Debug.Message(name .. "狩猎了一个宝箱怪！")
		if CHEST.Name then
			Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
		elseif CHEST.Message then
			Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
		elseif CHEST.MessageAbsolute then
			Debug.Message(CHEST.MessageAbsolute(p))
		end
	end
end

function CUNGUI.GetAIName()
	return "你的对手"
end

function CUNGUI.GetPlayerName()
	return "你"
end

function CUNGUI.chestop(e,tp,eg,ep,ev,re,r,rp)
	local i = e:GetLabel()
	local p = Duel.GetAttacker():GetControler()
	--对撞会同时触发2个，在这里要重新载入一次
	Duel.LoadScript("chest" .. tostring(i) .. ".lua")
	if CHEST and CHEST.BattleDestroyedEffect then
		if CHEST.EffectMessage then
			local name = CUNGUI.GetPlayerName()
			if CUNGUI.AI == p then
				name = CUNGUI.GetAIName()
			end
			Debug.Message(name .. CHEST.EffectMessage)
		elseif CHEST.EffectMessageAbsolute then
			Debug.Message(CHEST.EffectMessageAbsolute(e,p))
		end
		CHEST.BattleDestroyedEffect(e,p)
	end
	e:Reset()
end

function CUNGUI.CheckAI(e)
    local a0 = Duel.GetFieldGroupCount(0, LOCATION_EXTRA, 0)
    local a1 = Duel.GetFieldGroupCount(1, LOCATION_EXTRA, 0)
    local c0 = Duel.GetMatchingGroup(Card.IsCode, 0, LOCATION_EXTRA, 0, nil, 37818794)
    local c1 = Duel.GetMatchingGroup(Card.IsCode, 1, LOCATION_EXTRA, 0, nil, 37818794)
    if a0 > 15 and #c0>0 then
		Duel.Exile(c0:GetFirst(),REASON_RULE)
		CUNGUI.StartAI(0)
	else
		CUNGUI.StartHuman(0)
    end
    if a1 > 15 and #c1>0 then
		Duel.Exile(c1:GetFirst(),REASON_RULE)
		CUNGUI.StartAI(1)
	else
		CUNGUI.StartHuman(1)
    end
	if SP_RULE then
		if SP_RULE.Card then
			CUNGUI.RuleCardGroup={}
			--创造并固定规则卡
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_ADJUST)
			e1:SetLabel(SP_RULE.Card)
			e1:SetOperation(CUNGUI.RuleCardMove)
			Duel.RegisterEffect(e1,0)
			e1=e1:Clone()
			Duel.RegisterEffect(e1,1)
		end
		CUNGUI.HintRule()
	end
	e:Reset()
end

function CUNGUI.StartHuman(tp)
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1,34567890)
	e1:SetOperation(CUNGUI.HumanDraw)
	Duel.RegisterEffect(e1,tp)
end

function CUNGUI.HumanDraw(e,tp)
	if Duel.GetTurnPlayer()~=tp then return end
	local id=CUNGUI.GambleCards[math.random(#CUNGUI.GambleCards)]
	local c=Duel.CreateToken(tp,id)
    Duel.SendtoDeck(c,tp,SEQ_DECKTOP,REASON_RULE)
	Duel.Draw(tp,1,REASON_RULE)
	if tp ~= 0 or Duel.GetTurnCount(tp) > 1 then
		CUNGUI.HintRule()
	end
end

function CUNGUI.HintRule()
	if SP_RULE.RuleName then
		Debug.Message("已启动规则：【" .. SP_RULE.RuleName .. "】，以下为规则详情。")
	end
	if SP_RULE.Message then
		for _,v in pairs(SP_RULE.Message) do
			Debug.Message(v)
		end
	else
		Debug.Message("（详情不明）")
	end
end

function CUNGUI.RuleCardMove(e,tp)
	local c=e:GetLabelObject()
	if not c then
		c=CUNGUI.CreateRuleCard(tp,e:GetLabel())
		if SP_RULE and SP_RULE.InitRuleCard then
			SP_RULE.InitRuleCard(c)
		end
		e:SetLabelObject(c)
		CUNGUI.RuleCardGroup[tp]=c
	end
	if not c:IsLocation(LOCATION_EXTRA) or c:IsFacedown() then
		Duel.SendtoExtraP(c,tp,REASON_RULE)
	end
end

function CUNGUI.CreateRuleCard(tp,code)
	local c=Duel.CreateToken(tp,code)
	--[[if tp~=CUNGUI.AI then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCondition(function (e)
			return e:GetHandler():IsFaceup()
		end)
		e1:SetOperation(function ()
			CUNGUI.HintRule()
		end)
		c:RegisterEffect(e1)
	end]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EFFECT_CANNOT_USE_AS_COST)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone(c)
	e3:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone(c)
	e4:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e4)
	local e5=e2:Clone(c)
	e5:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(aux.FALSE)
	c:RegisterEffect(e6)
	return c
end

function CUNGUI.GetRandomGambleCard(tp)
	local id=CUNGUI.GambleCards[math.random(#CUNGUI.GambleCards)]
	local c=Duel.CreateToken(tp,id)
	if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_ATTACK)>0 then
		c:CompleteProcedure()
		return true
	end
	return false
end

function CUNGUI.StartStep3(tp)
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.Step3DiceDuel)
	Duel.RegisterEffect(e1,tp)
end

function CUNGUI.Step3DiceDuel(e,tp)
	if not CUNGUI.Step3Checked then
		--非素体AI，直接永久终止执行本部分
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_EXTRA,0,1,nil,21848500)
			and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_EXTRA,0,1,nil,95454996) then
			CUNGUI.Step3Checked = true
		else
			e:Reset()
		end
	end
	if Duel.GetTurnCount() < 2 then

		if math.random(2) == 1 then
			--只给AI刷
			CUNGUI.RandomSummonStep(tp)
			local m = math.random(3)
			local c = nil
			if m == 1 then
				c=CUNGUI.CreateAndSpecialSummonStep(tp,68059897)
			elseif m == 2 then
				c=CUNGUI.CreateAndSpecialSummonStep(tp,95454996)
			elseif m == 3 then
				c=CUNGUI.CreateAndSpecialSummonStep(tp,21848500)
			end
			Duel.SpecialSummonComplete()
		else
			CUNGUI.RandomSummonStep(tp)
			CUNGUI.RandomSummonStep(tp)
			CUNGUI.RandomSummonStep(tp)
			Duel.SpecialSummonComplete()
			local m = math.random(7)
			local str = ""

			if m == 1 then
				str = "？？？：来自家人的增援！"
				CUNGUI.CreateAndSpecialSummonStep(1-tp,76782778)
				CUNGUI.CreateAndSpecialSummonStep(1-tp,42055234)
				CUNGUI.CreateAndSpecialSummonStep(1-tp,15848542)
				CUNGUI.CreateAndSpecialSummonStep(1-tp,24799107)
				Duel.SpecialSummonComplete()
			elseif m == 2 then
				str = "？？？：阿宙斯，出击！"
				local c=CUNGUI.CreateAndSpecialSummonStep(1-tp,90448279)
				local oc=CUNGUI.CreateAndSendtoHand(1-tp,20129614)
				Duel.Overlay(c,oc)
				Duel.SpecialSummonComplete()
			elseif m == 3 then
				str = "？？？：不击灭入侵者，有辱黄金卿之名！"
				CUNGUI.CreateAndSpecialSummon(1-tp,95440946,POS_FACEUP_DEFENSE)
				Duel.SpecialSummonComplete()
				local c=Duel.CreateToken(1-tp,20590515)
				Duel.SSet(1-tp,c)
				local c=Duel.CreateToken(1-tp,56984514)
				Duel.SSet(1-tp,c)
			elseif m == 4 then
				str = "？？？：够格的对手，久违的实战。"
				CUNGUI.CreateAndSpecialSummon(1-tp,42632209)
				local c=CUNGUI.CreateAndSpecialSummon(1-tp,69488544)
				Duel.SpecialSummonComplete()
				local tc=Duel.CreateToken(1-tp,31423101)
				Duel.Equip(1-tp,tc,c)
			elseif m == 5 then
				str = "一道强光从发牌姬的卡组中射出——！！"
				CUNGUI.CreateAndSpecialSummon(1-tp,37818794):RegisterFlagEffect(37818795,RESET_EVENT+RESETS_STANDARD,0,1,2)
			elseif m == 6 then
				str = "小蓝们前来支援！！"
				CUNGUI.CreateAndSpecialSummonStep(1-tp,74078255)
				CUNGUI.CreateAndSpecialSummonStep(1-tp,76145933)
				CUNGUI.CreateAndSpecialSummonStep(1-tp,73810864)
				CUNGUI.CreateAndSpecialSummonStep(1-tp,10000000)
				Duel.SpecialSummonComplete()
			else
				str = "天上划出一道口子，有个意义不明戴着假面并且你不认识的怪兽前来助阵。"
				local c=CUNGUI.CreateAndSpecialSummonStep(1-tp,26973555)
				Duel.SpecialSummonComplete()
				local oc=CUNGUI.CreateAndSendtoHand(1-tp,13171876)
				Duel.Overlay(c,oc)
			end

			Debug.Message(str)

			--给玩家刷，也给AI刷
		end

		--仅第一回合执行
		return
	end
	--从第二回合开始的抽卡阶段，玩家和AI都丢一个骰子。比点数。
	local ai_dice = Duel.TossDice(tp,1)
	local human_dice = Duel.TossDice(1-tp,1)
	Debug.Message("骰子对决！你掷出了" .. tostring(human_dice) .. "，素体掷出了" .. tostring(ai_dice))
	if ai_dice < human_dice then
		CUNGUI.Step3DiceDuelHumanMove(1-tp,human_dice)
	else
		CUNGUI.Step3DiceDuelAIMove(tp,ai_dice)
	end
end

function CUNGUI.CreateAndSendtoHand(tp,id)
	local c=Duel.CreateToken(tp,id)
	Duel.SendtoHand(c,nil,REASON_RULE)
	return c
end

function CUNGUI.CreateAndSpecialSummonStep(tp,id,pos)
	if not pos then pos = POS_FACEUP_ATTACK end
	local c=Duel.CreateToken(tp,id)
	Duel.SpecialSummonStep(c,0,tp,tp,true,true,pos)
	c:RegisterFlagEffect(10000000,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET-RESET_TEMP_REMOVE,0,1)
	return c
end

function CUNGUI.CreateAndSpecialSummon(tp,id,pos)
	if not pos then pos = POS_FACEUP_ATTACK end
	local c=Duel.CreateToken(tp,id)
	Duel.SpecialSummon(c,0,tp,tp,true,true,pos)
	c:RegisterFlagEffect(10000000,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET-RESET_TEMP_REMOVE,0,1)
	return c
end

--继承自深渊代码
CUNGUI.SPList = {27279764,40061558,99267150,62873545,72989439,98630720,31833038,98127546,86221741,
80611581,52085072,63468625,69120785,31764700,82103466,84433295,4167084,13331639,
8505920,21123811,37442336,97836203,97489701,15982593,95095116,18666161,40939228,
41517789,62180201,47084486,33746252,21208154,57793869,14799437,23440231,10669138,
21637210,3134857,29479265,8763963,27572350,72402069,30604579,96633955,84815190,
67508932,87460579,60465049,23288411,91588074,25451652,22073844,47556396,51522296,
68199168,6150044,37663536,75286621,58481572}

--继承自深渊代码
function CUNGUI.RandomSummon(tp)
	local id=CUNGUI.SPList[math.random(#CUNGUI.SPList)]
	local c=Duel.CreateToken(tp,id)
	if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_ATTACK)>0 then
		c:CompleteProcedure()
		return true
	end
	return false
end

function CUNGUI.RandomSummonStep(tp)
	local id=CUNGUI.SPList[math.random(#CUNGUI.SPList)]
	local c=Duel.CreateToken(tp,id)
	if Duel.SpecialSummonStep(c,0,tp,tp,true,true,POS_FACEUP_ATTACK) then
		c:CompleteProcedure()
		return true
	end
	return false
end

function CUNGUI.Step3DiceDuelAIMove(tp,dice)
	if dice == 1 then
		--●双方手牌和场上的怪兽全部返回卡组。
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE+LOCATION_HAND,nil,TYPE_MONSTER)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		--●双方抽出4张卡。
		Duel.Draw(0,4,REASON_RULE)
		Duel.Draw(1,4,REASON_RULE)
		Debug.Message("感受吧，千年前战争的冰山一角。")
		--红心加密在EX区
		local c=Duel.CreateToken(tp,21848500)
		Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_RULE)
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_ATTACK,0x60)
		c=Duel.CreateToken(tp,68059897)
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		c=Duel.CreateToken(tp,95454996)
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		c=Duel.CreateToken(tp,69272449)
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		c=Duel.CreateToken(tp,96676583)
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		c=Duel.CreateToken(tp,32061192)
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		Duel.SpecialSummonComplete()
		--●AI后场发动1张次元裂缝(81674782)。
		c=Duel.CreateToken(tp,81674782)
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		--●玩家场上刷防守表示的洗衣龙女(13171876)。
		c=Duel.CreateToken(1-tp,13171876)
		Duel.SpecialSummonStep(c,0,1-tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	elseif dice == 2 then
		local c=Duel.CreateToken(tp,23846921)
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		c=Duel.CreateToken(tp,69831560)
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		CUNGUI.RandomSummonStep(tp)
		Duel.SpecialSummonComplete()
	elseif dice == 3 then
		CUNGUI.RandomSummonStep(tp)
		CUNGUI.RandomSummonStep(tp)
		local c=Duel.CreateToken(tp,94853057)
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		Duel.SpecialSummonComplete()
	elseif dice == 4 then
		Duel.Draw(tp,2,REASON_RULE)
		Duel.Recover(tp,8000,REASON_RULE)
	elseif dice == 5 then
		Duel.Destroy(Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(tp,1),REASON_RULE)
		Duel.Destroy(Duel.GetFieldGroup(1-tp,LOCATION_MZONE,0):RandomSelect(tp,1),REASON_RULE)
		Duel.Destroy(Duel.GetFieldGroup(1-tp,LOCATION_SZONE,0):RandomSelect(tp,1),REASON_RULE)
		local c=Duel.CreateToken(tp,31849106)
		Duel.SSet(tp,c)
	else
		CUNGUI.RandomSummon(tp)
		CUNGUI.CreateAndSendtoHand(tp,CUNGUI.GambleCards[math.random(#CUNGUI.GambleCards)])
		Duel.Recover(tp,2000,REASON_RULE)
	end
end

function CUNGUI.Step3DiceDuelHumanMove(tp,dice)
	if dice < 6 then
		CUNGUI.CreateAndSendtoHand(tp,CUNGUI.GambleCards[math.random(#CUNGUI.GambleCards)])
	else
		Debug.Message("发牌姬偷偷给你手里塞了点东西……")
		local rand = math.random(8)
		
		if rand == 1 then
			CUNGUI.CreateAndSendtoHand(tp,55144522)
		elseif rand == 2 then
			CUNGUI.CreateAndSendtoHand(tp,79571449)
		elseif rand == 3 then
			CUNGUI.CreateAndSendtoHand(tp,54447022)
		elseif rand == 4 then
			CUNGUI.CreateAndSendtoHand(tp,74191942)
		elseif rand == 5 then
			CUNGUI.CreateAndSendtoHand(tp,45986603)
		elseif rand == 6 then
			CUNGUI.CreateAndSendtoHand(tp,76375976)
		elseif rand == 7 then
			CUNGUI.CreateAndSendtoHand(tp,27174286)
		else
			CUNGUI.CreateAndSendtoHand(tp,8124921)
			CUNGUI.CreateAndSendtoHand(tp,44519536)
			CUNGUI.CreateAndSendtoHand(tp,70903634)
			CUNGUI.CreateAndSendtoHand(tp,7902349)
			CUNGUI.CreateAndSendtoHand(tp,33396948)
			Debug.Message("素体：不是，哥们，你卡组里下这个？")
		end

	end
end

function CUNGUI.StartAI(tp)
	CUNGUI.AI = tp

	CUNGUI.StartStep3(tp)

	if SP_RULE and SP_RULE.InitAdjust then
		--adjust
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_ADJUST)
		if SP_RULE.AdjustCountLimit > 0 then
			e1:SetCountLimit(SP_RULE.AdjustCountLimit)
		end
		e1:SetCondition(CUNGUI.SpecialRuleAdjustCond)
		e1:SetOperation(CUNGUI.SpecialRuleAdjust)
		Duel.RegisterEffect(e1,tp)
	end
	
    Duel.Draw(tp,1,REASON_RULE)
    Duel.Recover(tp,4000,REASON_RULE)
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AICheckDraw)
	Duel.RegisterEffect(e1,tp)
	--Draw
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
    e2:SetLabel(1)
	e2:SetValue(CUNGUI.DrawCount)
    CUNGUI.AIDrawCountEffect = e2
	Duel.RegisterEffect(e2,tp)
end

function CUNGUI.SpecialRuleAdjustCond(e,tp)
	return (not SP_RULE.Card) or not (CUNGUI.RuleCardGroup and CUNGUI.RuleCardGroup[tp])
end

function CUNGUI.SpecialRuleAdjust(e,tp)
	if e:GetLabel()==1 then return end
	e:SetLabel(1)
	SP_RULE.InitAdjust(tp)
	e:SetLabel(0)
	if not SP_RULE.AlwaysAdjust then
		e:Reset()
	end
end

function CUNGUI.AICheckDraw(e,tp)
	if Duel.GetTurnPlayer()~=tp then return end
	local i=Duel.GetDrawCount(tp) - CUNGUI.AIDrawCountEffect:GetLabel() + 1
	if i < 1 then i = 1 end
	CUNGUI.AIDrawCountEffect:SetLabel(i)

	--额外抽1张赌博卡
	local code = CUNGUI.GambleCards[math.random(#CUNGUI.GambleCards)]
	CUNGUI.CreateCardForAIDraw(tp,code)

	--AI手卡在2以下，则额外抽到【圣杯A】37812118
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3 then
        CUNGUI.CreateCardForAIDraw(tp,37812118)
	end

	--AI基本分在700以下，则额外抽到【大逆转谜题5990062】【风魔手里剑9373534】
	if Duel.GetLP(tp)<=700 then
        CUNGUI.CreateCardForAIDraw(tp,5990062)
        CUNGUI.CreateCardForAIDraw(tp,9373534)
	end

	--玩家基本分在2000以下，则额外抽到【命运的分岔道50470982】【火焰飞镖43061293】
	if Duel.GetLP(1-tp)<=2000 then
        CUNGUI.CreateCardForAIDraw(tp,50470982)
        CUNGUI.CreateCardForAIDraw(tp,43061293)
	end

	--玩家手卡6以上，AI手卡2以下，额外抽到【赌博37313786】
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=6 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2 then
        CUNGUI.CreateCardForAIDraw(tp,37313786)
	end

	--玩家后场3以上，额外抽到【骰子旋风3493058】
	if Duel.GetFieldGroupCount(tp,0,LOCATION_SZONE)>=3 then
        CUNGUI.CreateCardForAIDraw(tp,3493058)
	end

	--玩家怪兽3以上，额外抽到【时间魔术师71625222】【二重召唤43422537】
	if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>=3 then
        CUNGUI.CreateCardForAIDraw(tp,71625222)
        CUNGUI.CreateCardForAIDraw(tp,43422537)
	end

	local royal = true
	for i=0,4 do
		if Duel.GetFieldCard(1-tp,LOCATION_SZONE,i)==nil then royal = false end
	end
	--玩家后场5张，抽卡阶段直接使用1次【同花顺25173686】效果
	if royal then
		local sg=Duel.GetMatchingGroup(CUNGUI.royalfilter,tp,0,LOCATION_SZONE,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

function CUNGUI.royalfilter(c)
	return c:GetSequence()<5
end

function CUNGUI.CreateCardForAIDraw(tp,code)
    local c=Duel.CreateToken(tp, code)
    Duel.SendtoDeck(c,tp,SEQ_DECKTOP,REASON_RULE)
	CUNGUI.AIDrawCountEffect:SetLabel((CUNGUI.AIDrawCountEffect:GetLabel() or Duel.GetDrawCount(tp)) + 1)
end

function CUNGUI.DrawCount(e)
	return e:GetLabel() or Duel.GetDrawCount(e:GetOwner())
end