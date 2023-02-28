--村规决斗：愚者千虑
--开局时，双方将1张扰乱王（90140980）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--在自己的回合，扰乱王可能会“帮你打牌”。
--你进行的动作越多，扰乱王出手的概率就越大。

--细则：
--扰乱王的所有动作不检查空发，也（尽量）无视规则
--（比如，就算王谷在场也仍然能从墓地回收卡）
--……但是特殊召唤因引擎原因还是过不了虚无空间。

--概率：
--初始进行动作的概率为1/50。你每做1个动作，分母-1；扰乱王每次出手，分母+10。
--回合结束后复原为1/50。

--动作列表：
--·把你的1~2张手卡返回卡组。重抽同样的数量。
--·把你的1~2张手卡送去墓地。从墓地选同样数量的随机卡回到手卡。
--·从你的卡组随机选5张卡除外。从墓地+除外的卡中选5张卡返回卡组。
--·帮你盖伏手卡中的1~2张随机魔法·陷阱卡。
--·帮你把场上1只怪兽返回手卡·额外卡组。从相同位置把1只怪兽攻击表示特殊召唤（如果是超量怪兽，还会从卡组最上方送你0~3张卡当素材）。
--·帮你在场上特殊召唤1~3只【扰乱衍生物】。
--·帮你交换自己和对方场上各1只怪兽的控制权。某一方没有怪兽的场合，则单方面送出怪兽。
--·把场上5只怪兽解放，从卡组外把1只【原始生命态 尼比鲁】攻击表示放置到场上。

CUNGUI = {}
CUNGUI.RuleCardCode=90140980

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
	--adjust
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCountLimit(1)
	e2:SetOperation(CUNGUI.AdjustOperation2)
	Duel.RegisterEffect(e2,0)
end
function CUNGUI.AdjustOperation2()
	CUNGUI.FENMU={}
	CUNGUI.FENMU[0]=50
	CUNGUI.FENMU[1]=50
end
function CUNGUI.AdjustOperation()
	if not CUNGUI.RandomSeedInit then
		CUNGUI.RandomSeedInit = true
		Duel.LoadScript("random.lua")
		math.randomseed(_G.RANDOMSEED)
		for i=1,10 do math.random(1000) end
	end
	if not CUNGUI.RuleCardInit then
		CUNGUI.RuleCardInit = true
		CUNGUI.RegisterCardRule(0)
		CUNGUI.RegisterCardRule(1)
	end
	if not CUNGUI.DrawInit then
		CUNGUI.DrawInit = true
		--Duel.Draw(1,1,REASON_RULE)
	end
	if CUNGUI.RuleCard[0] and (not CUNGUI.RuleCard[0]:IsLocation(LOCATION_REMOVED) or not CUNGUI.RuleCard[0]:IsFaceup()) then
		Duel.Remove(CUNGUI.RuleCard[0],POS_FACEUP,REASON_RULE)
	end
	if CUNGUI.RuleCard[1] and (not CUNGUI.RuleCard[1]:IsLocation(LOCATION_REMOVED) or not CUNGUI.RuleCard[1]:IsFaceup()) then
		Duel.Remove(CUNGUI.RuleCard[1],POS_FACEUP,REASON_RULE)
	end
	if CUNGUI.RuleCard[0] and not CUNGUI.RuleCard[0]:IsFaceup() then
		Duel.ChangePosition(CUNGUI.RuleCard[0],POS_FACEUP)
	end
	if CUNGUI.RuleCard[1] and not CUNGUI.RuleCard[1]:IsFaceup() then
		Duel.ChangePosition(CUNGUI.RuleCard[1],POS_FACEUP)
	end
end

CUNGUI.RuleCard={}
CUNGUI.RefreshTurn={}
CUNGUI.RefreshTurn[0]=0
CUNGUI.RefreshTurn[1]=0
CUNGUI.FENMU={}
CUNGUI.FENMU[0]=50
CUNGUI.FENMU[1]=50

function CUNGUI.RegisterCardRule(tp)
	local c=Duel.CreateToken(tp,CUNGUI.RuleCardCode)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	--forbid
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66666004,4))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(CUNGUI.rulecond)
	e1:SetTarget(CUNGUI.ruletg)
	e1:SetOperation(CUNGUI.ruleop)
	c:RegisterEffect(e1)
end
function CUNGUI.rulecond(e,tp,eg,ep,ev,re,r,rp)
	local result = Duel.GetTurnPlayer()==tp and math.random(CUNGUI.FENMU[tp])==1
	if CUNGUI.FENMU[tp] > 2 then CUNGUI.FENMU[tp]=CUNGUI.FENMU[tp]-2 end
	return result
end
function CUNGUI.ruletg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,1-tp,e:GetHandler():GetCode())
end
function CUNGUI.ruleop(e,tp,eg,ep,ev,re,r,rp)
	CUNGUI.FENMU[tp]=CUNGUI.FENMU[tp]+10
	local action=math.random(10)
	if action==1 then
		--·把你的1~2张手卡返回卡组，重抽同样的数量。
		local num=math.random(2)
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if #g>=num then
			local g2=g:RandomSelect(tp,num)
			if #g2>0 then Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_RULE) end
			Duel.Draw(tp,num,REASON_RULE)
		end
	elseif action==2 then
		--·把你的1~2张手卡送去墓地，随机从墓地选同样数量的卡回到手卡。
		local num=math.random(2)
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if #g>=num then
			local g2=g:RandomSelect(tp,num)
			Duel.SendtoGrave(g2,REASON_RULE)
			g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
			if #g>=num then
				g2=g:RandomSelect(tp,num)
				Duel.SendtoHand(g2,nil,REASON_RULE)
			end
		end
	elseif action==3 then
		--·从你的卡组随机选5张卡除外，从墓地+除外的卡中选5张卡返回卡组。
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		if #g>=5 then
			local g2=g:RandomSelect(tp,5)
			Duel.Remove(g2,POS_FACEUP,REASON_RULE)
			g=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_REMOVED,0)
			if #g>=5 then
				g2=g:RandomSelect(tp,5)
				if #g2>0 then Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_RULE) end
			end
		end
	elseif action==4 then
		--·帮你盖伏手卡中的1~2张随机魔法·陷阱卡。
		local num=math.random(2)
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_SPELL+TYPE_TRAP)
		local g2=g:RandomSelect(tp,num)
		if #g2>0 then Duel.SSet(tp,g2,tp,false) end
	elseif action==5 then
		--·帮你把场上1只怪兽返回手卡·额外卡组，从相同位置把1只怪兽攻击表示特殊召唤
		--（如果是超量怪兽，还会把卡组最上方的0~3张卡当素材）。
		local num=math.random(4)-1
		local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		local tc=g:RandomSelect(tp,1):GetFirst()
		if not tc then return end
		local loc=LOCATION_EXTRA
		Duel.SendtoHand(tc,nil,REASON_RULE)
		if tc:IsLocation(LOCATION_HAND) then loc=LOCATION_HAND end
		if tc:IsLocation(LOCATION_MZONE) then Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_RULE) end
		local g=Duel.GetMatchingGroup(Card.IsType,tp,loc,0,nil,TYPE_MONSTER)
		if #g<1 then return end
		tc=g:RandomSelect(tp,1):GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)>0 then
			tc:CompleteProcedure()
			if tc:IsType(TYPE_XYZ) and num>0 then
				local g=Duel.GetDecktopGroup(tp,num)
				if #g>0 then
					Duel.Overlay(tc,g)
				end
			end
		end
	elseif action==6 then
		--·帮你在场上表侧守备表示特殊召唤1~3只【扰乱衍生物】。
		-- 这些衍生物不能为召唤而解放；被破坏的场合，每只给控制者造成300点伤害。
		local num=math.random(3)
		for i=1,num do
			local token=Duel.CreateToken(tp,29843091+i)
			if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UNRELEASABLE_SUM)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(1)
				token:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_LEAVE_FIELD)
				e2:SetOperation(CUNGUI.damop)
				token:RegisterEffect(e2,true)
			end
		end
		Duel.SpecialSummonComplete()
	elseif action==7 then
		--·帮你把（双方）场上1~2张魔法陷阱卡返回卡组。从各自的卡组盖伏同样数量的魔法·陷阱卡。
		local num=math.random(2)
		local g=Duel.GetFieldGroup(tp,LOCATION_SZONE,LOCATION_SZONE)
		local g2=g:RandomSelect(tp,num)
		for tc in aux.Next(g2) do
			tp=tc:GetControler()
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_RULE)
			local nc=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL+TYPE_TRAP):RandomSelect(tp,1):GetFirst()
			if nc then Duel.SSet(tp,nc,tp,false) end
		end
	elseif action==8 then
		--·帮你交换自己和对方场上各1只怪兽的控制权。某一方没有怪兽的场合，则单方面送出怪兽。
		local ag=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		local bg=Duel.GetFieldGroup(1-tp,LOCATION_MZONE,0)
		local ac=ag:RandomSelect(tp,1):GetFirst()
		local bc=bg:RandomSelect(tp,1):GetFirst()
		if ac and bc then
			Duel.SwapControl(ac,bc)
		elseif ac then
			Duel.GetControl(ac,1-tp)
		elseif bc then
			Duel.GetControl(bc,1-tp)
		end
	elseif action==9 then
		--·帮你破坏场上的1张随机卡（不分敌我）。
		local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		g=g:RandomSelect(tp,1)
		if #g>0 then
			Duel.Destroy(g,REASON_RULE)
		end
	else
		--·如果双方场上的怪兽在4只以下，什么都不做。
		--否则，把5只随机怪兽解放。从卡组外把1只【原始生命态 尼比鲁】攻击表示放置到场上。
		local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
		if #g<5 then return end
		g=g:RandomSelect(tp,5)
		Duel.Release(g,REASON_RULE)
		local nc=Duel.CreateToken(tp,27204311)
		Duel.SpecialSummon(nc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end

function CUNGUI.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		Duel.Damage(c:GetPreviousControler(),300,REASON_EFFECT)
	end
	e:Reset()
end
