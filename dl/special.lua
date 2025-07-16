local skillLists={}
local skillSelections={}
local lp_record={[0]=0,[1]=0}
local need_shuffle={[0]=true,[1]=true}
local toss_coin=Duel.TossCoin
local labget=Effect.GetLabel
local getattack=Card.GetAttack
function Duel.TossCoin(player,count)
	local tmp_count=count
	if Duel.GetLP(player)<=1000 and Duel.GetFlagEffect(player,37812118)>0 then
		if count < 0 then
			tmp_count=7
		end
	end
	return toss_coin(player,tmp_count)
end

local function addSkill(code, skill)
	if not skillLists[code] then
		skillLists[code]={}
	end
	table.insert(skillLists[code], skill)
end

local function getAllSkillCodes()
	local skillCodes={}
	for code,_ in pairs(skillLists) do
		table.insert(skillCodes, code)
	end
	return skillCodes
end

local function registerSkillForPlayer(tp, code)
	local skills=skillLists[code]
	for _,skill in ipairs(skills) do
		local e1=Effect.GlobalEffect()
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		skill(e1,tp)
		Duel.RegisterEffect(e1,tp)
	end
end

local function wrapDeckSkill(code, effectFactory)
	addSkill(code, function(e2)
		local e1=Effect.GlobalEffect()
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(LOCATION_DECK)
		effectFactory(e1)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetTargetRange(LOCATION_DECK,0)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetTarget(function(e,c)
			local dg=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_DECK,0)
			if #dg==0 then return false end
			local minc=dg:GetMinGroup(Card.GetSequence):GetFirst()
			return c==minc
		end)
		e2:SetLabelObject(e1)
	end)
end

local function phaseSkill(code, phase, op, con, both)
	wrapDeckSkill(code, function(e1)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(phase)
		if phase==EVENT_PHASE_START+PHASE_DRAW then
			phase=PHASE_DRAW
		else
			phase=phase-EVENT_PHASE
		end
		e1:SetCountLimit(1,0x7ffffff-code-phase)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return (both or Duel.GetTurnPlayer()==tp) and Duel.GetCurrentPhase()==phase and (not con or con(e,tp,eg,ep,ev,re,r,rp))
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_CARD,0,code)
			op(e,tp,eg,ep,ev,re,r,rp)
		end)
	end)
end

local function mainphaseSkill(code, op, con, both)
	wrapDeckSkill(code, function(e1)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return (both or Duel.GetTurnPlayer()==tp) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and (not con or con(e,tp,eg,ep,ev,re,r,rp))
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_CARD,0,code)
			op(e,tp,eg,ep,ev,re,r,rp)
		end)
	end)
end

local function mainphaseSkillEx(code, op, con, both , count , countid ,duellimit,desc)
	if not countid then countid=code end
	wrapDeckSkill(code, function(e1)
		if desc then e1:SetDescription(desc) end
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			if count and Duel.GetFlagEffect(tp,countid)>=count then return false end
			return (both or Duel.GetTurnPlayer()==tp) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and (not con or con(e,tp,eg,ep,ev,re,r,rp))
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_CARD,0,code)
			op(e,tp,eg,ep,ev,re,r,rp)
			if count then
				if duellimit then
					Duel.RegisterFlagEffect(tp,countid,0,0,1)
				else
					Duel.RegisterFlagEffect(tp,countid,RESET_PHASE+PHASE_END,0,1)
				end
			end
		end)
	end)
end

local function mainphaseSkillList(code,...)
	local configs = {...}
	wrapDeckSkill(code, function(e1)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			if not Duel.IsMainPhase() then return false end
			for _, config in ipairs(configs) do
				if (config.both or Duel.GetTurnPlayer()==tp) and (not config.con or config.con(e,tp,eg,ep,ev,re,r,rp)) and (not config.count or Duel.GetFlagEffect(tp,config.countid)<config.count) then
					return true
				end
			end
			return false
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_CARD,0,code)
			local available = {}
			for _, config in ipairs(configs) do
				local both = config.both
				local turn_cond = both or (Duel.GetTurnPlayer() == tp)
				if turn_cond then
					local count = config.count
					local countid = config.countid or code
					if count and Duel.GetFlagEffect(tp, countid) >= count then
					else
						local con = config.con
						if not con or con(e,tp,eg,ep,ev,re,r,rp) then
							table.insert(available, config)
						end
					end
				end
			end
			local options={}
			for i, config in ipairs(configs) do
				local enabled=(config.both or Duel.GetTurnPlayer()==tp) and (not config.con or config.con(e,tp,eg,ep,ev,re,r,rp)) and (not config.count or Duel.GetFlagEffect(tp,config.countid)<config.count)
				table.insert(options,{enabled,config.desc})
			end
			local selected=aux.SelectFromOptions(tp,table.unpack(options))
			local config=configs[selected]
			if config then
				if config.count then
					if config.duellimit then
						Duel.RegisterFlagEffect(tp,config.countid,0,0,1)
					else
						Duel.RegisterFlagEffect(tp,config.countid,RESET_PHASE+PHASE_END,0,1)
					end
				end
				config.op(e,tp,eg,ep,ev,re,r,rp)
				if config.count and config.count>1 then
					Duel.AdjustAll()
				end
			end
		end)
	end)
end

local onetimeSkillResolveOperationsPrior={
	[0]={},
	[1]={},
}
local onetimeSkillResolveOperations={
	[0]={},
	[1]={},
}
local function oneTimeSkill(code, op, prior)
	addSkill(code, function(e1,tp)
		local oneTimeSkillObject={
			code=code,
			op=op,
			tp=tp,
		}
		if prior then
			table.insert(onetimeSkillResolveOperationsPrior[tp], oneTimeSkillObject)
		else
			table.insert(onetimeSkillResolveOperations[tp], oneTimeSkillObject)
		end
	end)
end

local function startPhaseSkill(code, op, con, both)
	phaseSkill(code, EVENT_PHASE_START+PHASE_DRAW, op, con, both)
end

local function standbyPhaseSkill(code, op, con, both)
	phaseSkill(code, EVENT_PHASE+PHASE_STANDBY, op, con, both)
end

local function endPhaseSkill(code, op, con, both)
	phaseSkill(code, EVENT_PHASE+PHASE_END, op, con, both)
end

--重新开始
--[[
oneTimeSkill(85852291, function(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(43227,0)) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=#g
	Duel.SendtoDeck(g,nil,0,REASON_RULE)
	Duel.ShuffleDeck(tp)
	Duel.Draw(tp,ct,REASON_RULE)
end)

--青眼白龙
local function lvcheck(c)
	return c:IsFaceup() and c:IsLevelAbove(5)
end
mainphaseSkill(89631139,
function(ce,ctp)
	local g=Duel.GetMatchingGroup(lvcheck,ctp,LOCATION_MZONE,0,nil)
	local atk=g:GetCount()*300
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,ctp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(ag) do
		local e3=Effect.CreateEffect(ce:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(atk)
		tc:RegisterEffect(e3)
	end
	Duel.RegisterFlagEffect(ctp,89631139,RESET_PHASE+PHASE_END,0,1)
end,
function(ce,ctp) 
	local g=Duel.GetMatchingGroup(lvcheck,ctp,LOCATION_MZONE,0,nil)
	return Duel.GetFlagEffect(ctp,89631139)==0 and #g>0 
end,
false)

--黑魔术师
local function lvcheck(c)
	return c:IsFaceup()
end
mainphaseSkill(46986414,
function(ce,ctp)
	local g=Duel.GetMatchingGroup(nil,ctp,LOCATION_MZONE,0,nil)
	local atk=g:GetCount()*100
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,ctp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(ag) do
		local e3=Effect.CreateEffect(ce:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(atk)
		tc:RegisterEffect(e3)
	end
	Duel.RegisterFlagEffect(ctp,46986414,RESET_PHASE+PHASE_END,0,1)
end,
function(ce,ctp) 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,ctp,LOCATION_MZONE,0,nil)
	return Duel.GetFlagEffect(ctp,46986414)==0 and #g>0 
end,
false)

--注定一抽
local function repcon(e,tp,eg,ep,ev,re,r,rp)
	local cur_lp = Duel.GetLP(tp)
	return Duel.GetDrawCount(tp)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) and lp_record[tp] - cur_lp >= 2000 and Duel.GetTurnPlayer()==tp
end
local function repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,1108) then
		Duel.Hint(HINT_CARD,0,2295831)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	lp_record[tp] = Duel.GetLP(tp)
	e:Reset()
end

wrapDeckSkill(2295831, function(e7)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EVENT_PREDRAW)
	e7:SetCountLimit(1)
	e7:SetCondition(repcon)
	e7:SetOperation(repop)
end)

oneTimeSkill(2295831, function(e,tp,eg,ep,ev,re,r,rp)
	lp_record[tp]=Duel.GetLP(tp)
end)
]]
--传说的渔夫
local function activate_check(c,tp)
	return c:GetActivateEffect():IsActivatable(tp,true,true)
end
oneTimeSkill(3643300, function(e,tp,eg,ep,ev,re,r,rp)
	local field_1=Duel.CreateToken(tp,43175858)
	local field_2=Duel.CreateToken(tp,37694547)
	local field_3=Duel.CreateToken(tp,295517)
	local field_4=Duel.CreateToken(tp,712559)
	local field_5=Duel.CreateToken(tp,10080320)
	local field_6=Duel.CreateToken(tp,73206827)
	local field_7=Duel.CreateToken(tp,90011152)
	local field_8=Duel.CreateToken(tp,75782277)

	local field_group=Group.FromCards(field_1,field_2,field_3,field_4,field_5,field_6,field_7,field_8)
	field_group:KeepAlive()
	Duel.SendtoDeck(field_group,tp,0,REASON_RULE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=field_group:FilterSelect(tp,activate_check,1,1,nil,tp):GetFirst()
	if tc then
		field_group:RemoveCard(tc)
		Duel.Exile(field_group,REASON_RULE)
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEDOWN,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end)
--毅力
oneTimeSkill(74677422, function(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil):GetFirst()
	local ge1=Effect.CreateEffect(rc)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ge1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
	ge1:SetTargetRange(1,0)
	ge1:SetValue(1)
	Duel.RegisterEffect(ge1,tp)
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCondition(function(...)
		return Duel.GetLP(tp) <= 0 and not special_adjusting
	end)
	e1:SetOperation(function(...)
		special_adjusting=true
		local ge2=Effect.CreateEffect(rc)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE+PHASE_END)
		ge2:SetCountLimit(1)
		ge2:SetReset(RESET_PHASE+PHASE_END)
		ge2:SetOperation(function(...)
			Duel.SetLP(tp,1) 
			ge1:Reset()
		end)
		Duel.RegisterEffect(ge2,tp)
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		special_adjusting=false
	end
	)
	Duel.RegisterEffect(e1,tp)
end)
--抽卡放弃
--[[
local function skipdrcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return aux.IsPlayerCanNormalDraw(tp) and Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.GetTurnPlayer()==tp
end
local function skipdrop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(49838105,1)) then
		aux.GiveUpNormalDraw(e,tp)
		Duel.Recover(tp,600,REASON_RULE)
		Duel.DiscardDeck(tp,1,REASON_RULE)
	end
end
oneTimeSkill(3701074, function(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetMatchingGroup(nil,tp,0xff,0,nil):GetFirst()
	local ge1=Effect.CreateEffect(rc)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_PREDRAW)
	ge1:SetCondition(skipdrcon)
	ge1:SetOperation(skipdrop)
	Duel.RegisterEffect(ge1,tp)
end,true)
]]

--[[
--生命增加
oneTimeSkill(47852924, function(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)+1500)
end)
]]

--最后的赌博
--[[
local function dicecon(e,tp)
	return Duel.GetTurnCount()>=3 and Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(tp,3280747)==0 and Duel.GetMatchingGroupCount(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)>=2
end
local function diceop(e,tp)
	Duel.RegisterFlagEffect(tp,3280747,0,0,0)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,100)
	Duel.DiscardHand(tp,aux.TRUE,2,2,REASON_COST,nil)

	local dice=Duel.TossDice(tp,1)
	Duel.Draw(tp,dice,REASON_RULE)
end
standbyPhaseSkill(3280747, diceop, dicecon, false)]]

--[[
----幸运的朋友
local function coincon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and Duel.GetLP(tp)<=1000
end
local function coinop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,37812118)
	local res={Duel.GetCoinResult()}
	local ct=ev
	for i=1,ct do
		res[i]=1
	end
	Duel.SetCoinResult(table.unpack(res))
end
oneTimeSkill(37812118, function(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,37812118,0,0,0)
	local rc=Duel.GetMatchingGroup(nil,tp,0xff,0,nil):GetFirst()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_COIN_NEGATE)
	e1:SetCondition(coincon)
	e1:SetOperation(coinop)
	Duel.RegisterEffect(e1,tp)
end)
]]

--神秘抽卡
local function hdchangecon(e,tp)
	return Duel.GetTurnPlayer()==tp and Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)>=1 and Duel.GetFlagEffect(tp,48712196)==0 and Duel.GetFlagEffect(tp,48712195)<3
end
local function hdchangeop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_RULE)
	Duel.Draw(tp,1,REASON_RULE)
	Duel.RegisterFlagEffect(tp,48712195,0,0,0)
	Duel.RegisterFlagEffect(tp,48712196,RESET_PHASE+PHASE_END,0,0)
end
mainphaseSkill(48712195, hdchangeop, hdchangecon, false)

--成金
oneTimeSkill(70368879, function(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_RULE)
end)

--天平
oneTimeSkill(67443336, function(e,tp,eg,ep,ev,re,r,rp)
	need_shuffle[tp]=false
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local hand_count=#hg
	Duel.SendtoDeck(hg,nil,0,REASON_RULE)
	Duel.ShuffleDeck(tp)
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local deck_count=#dg
	local type_cards={}
	local type_count={}
	local current_type=TYPE_MONSTER
	while current_type<=TYPE_TRAP do
		type_cards[current_type]=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,current_type)
		type_count[current_type]=#type_cards[current_type]
		current_type=current_type<<1
	end

	local draw_type_count={}
	local draw_type_count_precise={}
	local draw_type_count_tweaked={}
	current_type=TYPE_MONSTER
	local total_draw_count=0
	while current_type<=TYPE_TRAP do
		draw_type_count_precise[current_type]=type_count[current_type]*hand_count/deck_count
		draw_type_count[current_type]=math.floor(draw_type_count_precise[current_type] + 0.5)
		draw_type_count_tweaked[current_type]=draw_type_count[current_type]-draw_type_count_precise[current_type]
		total_draw_count=total_draw_count+draw_type_count[current_type]
		current_type=current_type<<1
	end

	local difference=total_draw_count-hand_count
	-- 这里是四舍五入的结果，但是可能有偏差
	while difference>0 do
		-- 抽多了，需要找一个偏差最大的少抽
		local max_tweaked=0
		local max_tweaked_type=0
		current_type=TYPE_MONSTER
		while current_type<=TYPE_TRAP do
			if draw_type_count_tweaked[current_type]>max_tweaked then
				max_tweaked=draw_type_count_tweaked[current_type]
				max_tweaked_type=current_type
			end
			current_type=current_type<<1
		end
		draw_type_count[max_tweaked_type]=draw_type_count[max_tweaked_type]-1
		draw_type_count_tweaked[max_tweaked_type]=draw_type_count[max_tweaked_type]-draw_type_count_precise[max_tweaked_type]
		difference=difference-1
	end

	while difference<0 do
		-- 抽少了，需要找一个偏差最小的多抽
		local min_tweaked=0
		local min_tweaked_type=0
		current_type=TYPE_MONSTER
		while current_type<=TYPE_TRAP do
			if draw_type_count_tweaked[current_type]<min_tweaked then
				min_tweaked=draw_type_count_tweaked[current_type]
				min_tweaked_type=current_type
			end
			current_type=current_type<<1
		end
		draw_type_count[min_tweaked_type]=draw_type_count[min_tweaked_type]+1
		draw_type_count_tweaked[min_tweaked_type]=draw_type_count[min_tweaked_type]-draw_type_count_precise[min_tweaked_type]
		difference=difference+1
	end

	current_type=TYPE_TRAP
	while current_type>=TYPE_MONSTER do
		local g=type_cards[current_type]
		local sg=g:RandomSelect(tp,draw_type_count[current_type])
		for tc in aux.Next(sg) do
			Duel.MoveSequence(tc,SEQ_DECKTOP)
		end
		current_type=current_type>>1
	end
	Duel.Draw(tp,hand_count,REASON_RULE)
end,true)

local function addMakerPool(code, codeList)
	table.sort(codeList)
	oneTimeSkill(code, function (e,tp,eg,ep,ev,re,r,rp)
		local afilter = {codeList[1], OPCODE_ISCODE}
		for i = 2, #codeList do
			table.insert(afilter,codeList[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
		local g = Group.CreateGroup()
		for i = 1, 3 do
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CODE)
			local ac=Duel.AnnounceCard(tp, table.unpack(afilter))
			g:AddCard(Duel.CreateToken(tp, ac))
		end
		Duel.SendtoDeck(g, tp, 2, REASON_RULE)
	end,true)
end

--幻惑之眼
addMakerPool(23446369, {27204311,10000080,102380,55063751,78661338,34267821,42141493,84192580,87126721,14558127,52038441,59438930,60643553,94145021,2263869,4031928,12580477,14532163,25311006,35269904,66236707,35480699,43711255,10045474,40366667,43262273,49299410,83326048,97045737,41420027,90448279,93039339,90590303,46772449,66011101,45112597,65330383,86066372,38342335,2857636,75452921,65741786,24842059,41999284,60303245,2772337,45819647,8264361,9839945,30674956,48815792,73309655,97661969,60303245,94259633})
--无脸幻想魔术师
addMakerPool(15173384, {94689206,68304193,76794549,32909498,6637331,33854624,91800273,73356503,17266660,1845204,2295440,18144506,32807846,35261759,35726888,46411259,49238328,54447022,60682203,72892473,73628505,75500286,81439173,83764718,84211599,85106525,24224830,48130397,65681983,67723438,73468603,31423101,3280747,64697231,23002292,37818794,21044178,4280258,24094258,29301450,50588353,39064822,70369116,3679218})

--霸道灵摆
local function emcheck(c)
	return c:IsSetCard(0x99,0x98,0x9f,0x20f8,0x10f8)
end
oneTimeSkill(76840111, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(emcheck,tp,LOCATION_DECK+LOCATION_HAND,0,10,nil) then
		Duel.RegisterFlagEffect(tp,76840111,0,0,1)
		local pc1=Duel.CreateToken(tp,24094258)
		local pc2=Duel.CreateToken(tp,30095833)
		local pc3=Duel.CreateToken(tp,88305705)
		local pc4=Duel.CreateToken(tp,82044279)
		local pc5=Duel.CreateToken(tp,41209827)
		local pc6=Duel.CreateToken(tp,76794549)
		local pg=Group.FromCards(pc1,pc2,pc3,pc4,pc5)
		Duel.Remove(pg,POS_FACEUP,REASON_RULE)
		Duel.SendtoDeck(pg,tp,0,REASON_RULE)
		Duel.Remove(pc6,POS_FACEUP,REASON_RULE)
		Duel.SendtoDeck(pc6,tp,2,REASON_RULE)
		local e1=Effect.CreateEffect(pc6)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetOperation(function (e,tp)
			e:Reset()
			local hc1=Duel.CreateToken(tp,94415058)
			local hc2=Duel.CreateToken(tp,20409757)
			Duel.SendtoHand(hc1,nil,REASON_RULE)
			Duel.SendtoHand(hc2,nil,REASON_RULE)
		end)
		Duel.RegisterEffect(e1,tp)  
	end
end,true)
local function pmcheck(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand()
end
mainphaseSkillEx(76840111,
function(e,tp)
	local g=Duel.GetMatchingGroup(pmcheck,tp,LOCATION_EXTRA,0,nil)
	Duel.SendtoHand(g:Select(tp,1,1,nil),tp,REASON_RULE)
end,
function(e,tp)
	local g=Duel.GetMatchingGroup(pmcheck,tp,LOCATION_EXTRA,0,nil)
	return #g>0 and Duel.GetFlagEffect(tp,76840111)>0
end,
false,1,76840112)

--三幻神
local function MRcheck(c)
	return c:IsCode(83764718) and c:IsAbleToHand()
end
local exgodlist={79339613,85182315,85758066,59094601,79868386,269012,39913299,5253985,7373632,32247099,79387392,42166000,83764718}
local function godcheck(c)
	local bool=false
	local code=c:GetCode()
	for i,v in ipairs(exgodlist) do
		if v==code then bool=true break end
	end
	if aux.IsCodeOrListed(c,10000000) or aux.IsCodeOrListed(c,10000010) or aux.IsCodeOrListed(c,10000020) then bool=true end
	return bool
end
local function godthcheck(c)
	return godcheck(c) and c:IsAbleToHand()
end
local function disgodcheck(c)
	return c:IsDiscardable(REASON_RULE)
end
mainphaseSkillList(78665705,
{
	op=function(e,tp)
		local g=Duel.GetMatchingGroup(MRcheck,tp,LOCATION_GRAVE,0,nil)
		Duel.SendtoHand(g:Select(tp,1,1,nil),tp,REASON_RULE)
	end,
	con=function(e,tp) 
		local g=Duel.GetMatchingGroup(MRcheck,tp,LOCATION_GRAVE,0,nil)
		return #g>0
	end,
	count=1,
	countid=78665705,
	duellimit=false,
	desc=1110
},
{
	op=function(e,tp)
		local g=Duel.GetMatchingGroup(godthcheck,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if Duel.DiscardHand(tp,disgodcheck,1,1,REASON_RULE+REASON_DISCARD,nil,REASON_EFFECT)>0 then
			Duel.SendtoHand(g:Select(tp,1,1,nil),tp,REASON_RULE)
		end
	end,
		con=function(e,tp) 
		local g=Duel.GetMatchingGroup(godthcheck,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		return #g>0 and Duel.IsExistingMatchingCard(disgodcheck,tp,LOCATION_HAND,0,1,nil,REASON_RULE)
	end,
	count=3,
	countid=78665706,
	desc=1104
}
)
local function godaclimit(e,re,tp)
	local rc=re:GetHandler()
	return not godcheck(rc) and rc:IsType(TYPE_MONSTER+TYPE_TRAP)
end
local function godsplimit(e,c)
	return not godcheck(c)
end
oneTimeSkill(78665705,function(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(godaclimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(godsplimit)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e4,tp)
	local gc1=Duel.CreateToken(tp,12930501)
	local gc2=Duel.CreateToken(tp,10000010)
	Duel.Remove(gc1,POS_FACEDOWN,REASON_RULE)
	Duel.SendtoGrave(gc1,REASON_RULE)
	Duel.Remove(gc2,POS_FACEDOWN,REASON_RULE)
	Duel.SendtoGrave(gc2,REASON_RULE)
end)

--电子龙
local function cyberfilter(c)
	return c:IsSetCard(0x93) and c:IsType(TYPE_MONSTER)
end
oneTimeSkill(77565204, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cyberfilter,tp,LOCATION_DECK+LOCATION_HAND,0,10,nil) then
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
		e1:SetValue(5)
		Duel.RegisterEffect(e1,tp)
		local ec1=Duel.CreateToken(tp,1546123)
		local ec2=Duel.CreateToken(tp,84058253)
		local ec3=Duel.CreateToken(tp,46724542)
		local g=Group.FromCards(ec1,ec2,ec3)
		Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
		Duel.SendtoDeck(g,tp,2,REASON_RULE)
		Duel.RegisterFlagEffect(tp,77565204,0,0,1)
	end
end,true)
local function msplimit1(e,re,tp)
	local c=re:GetHandler()
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_MACHINE+RACE_DRAGON)
end
local function msplimit2(e,re,tp)
	local c=re:GetHandler()
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_MACHINE)
end
local function cybertograve(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c,tp)>=2
end
local function cybertograve(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c,tp)>=2
end
local function cyberpfilter(c)
	return (c:IsSetCard(0x93) or c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)) and c:IsType(TYPE_MONSTER)
end
mainphaseSkillList(77565204,
{
	op=function(e,tp)
		local gc1=Duel.CreateToken(tp,77625948)
		local gc2=Duel.CreateToken(tp,41230939)
		local gc3=Duel.CreateToken(tp,3019642)
		local gc4=Duel.CreateToken(tp,70095154)
		local g=Group.FromCards(gc1,gc2,gc3,gc4)
		Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
		Duel.SendtoGrave(g,REASON_RULE)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(msplimit1)
		Duel.RegisterEffect(e1,tp)
	end,
	con=function(e,tp) 
		return Duel.GetFlagEffect(tp,77565204)>0
	end,
	count=1,
	countid=77565205,
	duellimit=true,
	desc=1103
},
{
	op=function(e,tp)
		local g=Duel.GetMatchingGroup(cybertograve,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp)
		if Duel.SendtoGrave(g:Select(tp,1,1,nil),REASON_RULE)>0 then
			for i=1,2 do
				local token=Duel.CreateToken(tp,26439287)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			end
			Duel.SpecialSummonComplete()
		end
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(msplimit2)
		Duel.RegisterEffect(e1,tp)
	end,
		con=function(e,tp) 
		local g=Duel.GetMatchingGroup(cybertograve,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp)
		return Duel.GetFlagEffect(tp,77565204)>0 and #g>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,26439287,0x1093,TYPES_TOKEN_MONSTER,1100,600,3,RACE_MACHINE,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK) and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	end,
	count=1,
	countid=77565206,
	duellimit=true,
	desc=1075
},
{
	op=function(e,tp)
		local g=Duel.GetMatchingGroup(cyberpfilter,tp,LOCATION_HAND,0,nil)
		Duel.ConfirmCards(1-tp,g:Select(tp,1,1,nil))
		local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if Duel.SendtoDeck(dg:Select(tp,1,1,nil),tp,2,REASON_RULE)>0 then
			Duel.Draw(tp,1,REASON_RULE)
		end
	end,
	con=function(e,tp)
		local g=Duel.GetMatchingGroup(cyberpfilter,tp,LOCATION_HAND,0,nil)
		return Duel.GetFlagEffect(tp,77565204)>0 and #g>0
	end,
	count=1,
	countid=77565206,
	desc=1108
}
)

--革命的时花
local function fleurfilter(c)
	return c:IsAttack(2900) and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER)
end
oneTimeSkill(19642774, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(fleurfilter,tp,LOCATION_DECK+LOCATION_HAND,0,6,nil) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetCondition(function(e,c,minc)
			if c==nil then return true end
			return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		end)
		e1:SetTarget(function (e,c)
			return c:IsAttack(2900) and c:IsRace(RACE_SPELLCASTER)
		end)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,19642774,0,0,1)
	end
end)
local function fleurtoDeckfilter(c,tp)
	return c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c,tp)>0
end
local function fleurtoLvfilter(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(2)
end
mainphaseSkillList(19642774,
{
	op=function(e,tp) 
		local g=Duel.GetMatchingGroup(fleurtoDeckfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
		if Duel.SendtoDeck(g:Select(tp,1,1,nil),tp,2,REASON_RULE)>0 then
			local token=Duel.CreateToken(tp,48421595)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			local g=Duel.GetMatchingGroup(fleurtoLvfilter,tp,LOCATION_MZONE,0,nil):CancelableSelect(tp,1,1,nil)
			if g then
				local tc=g:GetFirst()
				local lv=0
				if tc:IsLevelAbove(3) then
					lv=Duel.AnnounceNumber(tp,-2,-1,0,1,2)
				elseif tc:IsLevel(2) then
					lv=Duel.AnnounceNumber(tp,-1,0,1,2)
				elseif tc:IsLevel(1) then
					lv=Duel.AnnounceNumber(tp,0,1,2)
				end
				local e1=Effect.CreateEffect(token)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(lv)
				tc:RegisterEffect(e1)
			end
		end
	end,
	con=function(e,tp) 
		local g=Duel.GetMatchingGroup(fleurtoDeckfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
		return #g>0 and Duel.GetFlagEffect(tp,19642774)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,48421595,0x1017,TYPES_TOKEN_MONSTER+TYPE_TUNER,200,400,2,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP)
	end,
	count=1,
	countid=19642775,
	desc=1062
},
{
	op=function(e,tp) 
		local g=Duel.GetMatchingGroup(fleurtoDeckfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
		if Duel.SendtoDeck(g:Select(tp,1,1,nil),tp,2,REASON_RULE)>0 then
			local token=Duel.CreateToken(tp,36405256)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end,
	con=function(e,tp) 
		local g=Duel.GetMatchingGroup(fleurtoDeckfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
		return #g>0 and Duel.GetFlagEffect(tp,19642774)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,36405256,0,TYPES_TOKEN_MONSTER,2900,0,8,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP)
	end,
	count=1,
	countid=19642776,
	desc=1118
}
)

--蓝天使
oneTimeSkill(91706817, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK+LOCATION_HAND,0,8,nil,0xfb) then
		local e1=Effect.GlobalEffect()
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetCondition(Duel.IsBattlePhase)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsOriginalCodeRule,35199656))
		e1:SetValue(61283655)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(function (e,c)
			return c:IsSetCard(0xfb)
		end)
		e2:SetValue(500)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(function(ce,cc) return not cc:IsSetCard(0xfb) end)
		e3:SetValue(-500)
		Duel.RegisterEffect(e3,tp)
		Duel.RegisterFlagEffect(tp,91706817,0,0,1)
	end
end)
local function tricktoGravefilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xfb) and c:IsType(TYPE_MONSTER)
end
local function trickspfilter(c,e,tp)
	return c:IsCode(32448765) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
mainphaseSkillList(91706817,
{
	op=function(e,tp) 
		local token=Duel.CreateToken(tp,35199656)
		Duel.SendtoHand(token,tp,REASON_RULE)
	end,
	con=function(e,tp) 
		return Duel.GetFlagEffect(tp,91706817)>0
	end,
	count=1,
	countid=91706818,
	desc=1190
},
{
	op=function(e,tp) 
		local g1=Duel.GetMatchingGroup(tricktoGravefilter,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetMatchingGroup(trickspfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if Duel.SendtoGrave(g1:Select(tp,2,2,nil),REASON_RULE)>0 then
			Duel.SpecialSummon(g2:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP)
		end
	end,
	con=function(e,tp) 
		local g1=Duel.GetMatchingGroup(tricktoGravefilter,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetMatchingGroup(trickspfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		return Duel.GetFlagEffect(tp,91706817)>0 and #g1>=2 and #g2>0
	end,
	count=1,
	countid=91706819,
	duellimit=true,
	desc=1118
}
)
--幻魔
local function beastfilter(c)
	return c:IsCode(69890967,32491822,6007213)
end
oneTimeSkill(93224848, function(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(beastfilter,tp,0xff,0,nil)
	for tc in aux.Next(g) do
		local re1={tc:IsHasEffect(EFFECT_SPSUMMON_CONDITION)}
		for _,te in pairs(re1) do
			if te:GetOwner()==tc then
				local value=te:GetValue()
				te:SetValue(function (e,se,sp,st)
					return sp==e:GetHandler():GetControler() or value(e,se,sp,st)
				end)
			end
		end
		local re2={tc:IsHasEffect(EFFECT_REVIVE_LIMIT)}
		for _,te in pairs(re2) do
			if te:GetOwner()==tc then
				te:Reset()
			end
		end
	end
end)
local function beastthfilter(c)
	return (c:IsCode(6007213,32491822,69890967)
		or aux.IsCodeListed(c,6007213) or aux.IsCodeListed(c,32491822) or aux.IsCodeListed(c,69890967)) and c:IsAbleToHand()
end
local function beasttdfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsAbleToDeck() or c:IsAbleToGrave()) and Duel.GetMZoneCount(tp,c,tp)>0
end
local function resolvecheck(c,tp)
	return c:IsAbleToDeck() or c:IsDiscardable(REASON_RULE)
end
local function beastspfilter(c,e,tp)
	return c:IsCode(6007213,32491822,69890967) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
mainphaseSkillList(93224848,
{
	op=function(e,tp)
		local cg=Duel.GetMatchingGroup(beastfilter,tp,LOCATION_HAND,0,nil)
		if #cg>1 then cg=cg:Select(tp,1,1,nil) end
		Duel.ConfirmCards(1-tp,cg)
		local g=Duel.GetMatchingGroup(resolvecheck,tp,LOCATION_HAND,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local og=g:Select(tp,1,1,nil)
		local num=0
		if og:GetCount()>0 then
			local tc=og:GetFirst()
			if tc:IsAbleToDeck() and (not tc:IsDiscardable(REASON_RULE) or Duel.SelectOption(tp,1105,501)==0) then
				num=Duel.SendtoDeck(tc,nil,2,REASON_RULE)
			elseif tc:IsDiscardable(REASON_RULE) then
				num=Duel.SendtoGrave(tc,REASON_RULE+REASON_DISCARD)
			end
			if num>0 then
				local tg=Duel.GetMatchingGroup(beastthfilter,tp,LOCATION_DECK,0,nil)
				Duel.SendtoHand(tg:Select(tp,1,1,nil),tp,REASON_RULE)
			end
		end 
	end,
	con=function(e,tp)
		local cg=Duel.GetMatchingGroup(beastfilter,tp,LOCATION_HAND,0,nil)
		local g=Duel.GetMatchingGroup(resolvecheck,tp,LOCATION_HAND,0,nil)
		local tg=Duel.GetMatchingGroup(beastthfilter,tp,LOCATION_DECK,0,nil)
		return #cg>0 and #g>0 and #tg>0
	end,
	count=3,
	countid=93224848,
	desc=1190
},
{
	op=function(e,tp) 
		local g1=Duel.GetMatchingGroup(beasttdfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,tp)  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local og=g1:Select(tp,1,1,nil)
		local num=0
		if og:GetCount()>0 then
			local tc=og:GetFirst()
			if tc:IsAbleToDeck() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1105,1103)==0) then
				num=Duel.SendtoDeck(tc,nil,2,REASON_RULE)
			elseif tc:IsAbleToGrave() then
				num=Duel.SendtoGrave(tc,REASON_RULE)
			end
			if num>0 then
			local g2=Duel.GetMatchingGroup(beastspfilter,tp,LOCATION_DECK,0,nil,e,tp)
			Duel.SpecialSummon(g2:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP)
			end
		end 
	end,
	con=function(e,tp) 
		local g1=Duel.GetMatchingGroup(beasttdfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,tp)
		local g2=Duel.GetMatchingGroup(beastspfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_GRAVE)>0 and #g1>=2 and #g2>0
	end,
	count=1,
	countid=93224849,
	desc=1118
}
)

--契约漏洞
local function dddamval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0xae) then return 0
	else return val end
end
local function checkMainDeck(c)
	return c:IsSetCard(0xaf,0xae) and not c:IsType(TYPE_XYZ|TYPE_SYNCHRO|TYPE_FUSION|TYPE_LINK)
end
oneTimeSkill(46372010, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(checkMainDeck,tp,0xff,0,12,nil) then
		local sc=Duel.CreateToken(tp,46372010)
		Duel.SSet(tp,sc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(dddamval)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterFlagEffect(tp,46372010,0,0,1)
	end
end)
local function ddcostfilter(c,tp,sc)
	return c:IsFaceup() and c:IsSetCard(0xaf) and c:IsLevelAbove(6)
		and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsReleasable()
end
local function ddspfilter(c,e,tp)
	return c:IsSetCard(0xaf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(ddcostfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
local function ddpfilter(c,e,tp)
	return c:IsSetCard(0xaf) and c:IsType(TYPE_PENDULUM) and c:IsFaceupEx()
end
local function ddseqfilter(c)
	return c:GetSequence()==0 or c:GetSequence()==4
end
mainphaseSkillList(46372010,
{
	op=function(e,tp)
		local g=Duel.GetMatchingGroup(ddspfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		local rc=Duel.SelectMatchingCard(tp,ddcostfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,sc)
		Duel.Release(rc,REASON_RULE)
		if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 and sc:IsType(TYPE_XYZ) then
			local og=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,sc):CancelableSelect(tp,1,2,nil)
			if og then
				Duel.Overlay(sc,og)
			end
		end
	end,
	con=function(e,tp)
		local g=Duel.GetMatchingGroup(ddspfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		return Duel.GetFlagEffect(tp,46372010)>0 and #g>0
	end,
	count=1,
	countid=46372011,
	desc=1118
},
{
	op=function(e,tp) 
		local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		local g2=Duel.GetMatchingGroup(ddpfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e,tp)
		local sg=Duel.GetFieldGroup(tp,LOCATION_SZONE,0):Filter(ddseqfilter,nil)
		if #sg<2 then sg:Merge(g1:Select(tp,2-#sg,2-#sg,sg)) end
		if Duel.Destroy(sg,REASON_RULE)==2 then
			local pg=g2:Select(tp,2,2,nil)
			Duel.MoveToField(pg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			Duel.MoveToField(pg:GetNext(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end,
	con=function(e,tp) 
		local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		local g2=Duel.GetMatchingGroup(ddpfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e,tp)
		return Duel.GetFlagEffect(tp,46372010)>0 and #g1>=2 and #g2>=2
	end,
	count=1,
	countid=46372012,
	duellimit=true,
	desc=1160
}
)

--爷爷的卡
local function acvcheck(e,ct)
    local p=e:GetHandlerPlayer()
    local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
    return te:GetHandler():IsCode(37613663)
end
oneTimeSkill(33396948, function(e,tp,eg,ep,ev,re,r,rp)
	local sc1=Duel.CreateToken(tp,8124921)
	local sc2=Duel.CreateToken(tp,44519536)
	local sc3=Duel.CreateToken(tp,70903634)
	local sc4=Duel.CreateToken(tp,7902349)
	local sc5=Duel.CreateToken(tp,33396948)
	local g=Group.FromCards(sc1,sc2,sc3,sc4,sc5)
	Duel.Remove(g,POS_FACEUP,REASON_RULE)
	Duel.SendtoDeck(g,tp,2,REASON_RULE)
	local e1=Effect.CreateEffect(sc5)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(function (e,tp)
		return Duel.GetTurnPlayer()==tp
	end)
	e1:SetOperation(function (e,tp)
		Duel.Recover(tp,1000,REASON_RULE)
	end)
	Duel.RegisterEffect(e1,tp)
	--Cost Change
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LPCOST_CHANGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(costchange)
	Duel.RegisterEffect(e2,tp)
	
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(function (e,c)
		return c:IsCode(83257450) and c:IsFaceup()
	end)
	e3:SetValue(1)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(1000)
	Duel.RegisterEffect(e4,tp)

	local e5=Effect.CreateEffect(sc5)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_INACTIVATE)
	e5:SetTargetRange(0xff,0xff)
	e5:SetValue(acvcheck)
	Duel.RegisterEffect(e5,tp)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e6,tp)

end,true)
local function costchange(e,re,rp,val)
	if re and re:GetHandler():IsSetCard(0x1ae) then
		return 0
	else
		return val
	end
end
--御巫
function battlediscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
    local rc=re:GetHandler()
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_PLAYER)
    return bit.band(loc,LOCATION_ONFIELD)~=0 and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and rc:GetControler()==1-tp
end
function battledisop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end
oneTimeSkill(79912449, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK+LOCATION_HAND,0,10,nil,0x18d) then
		local sc=Duel.CreateToken(tp,17255673)
		Duel.MoveToField(sc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetTarget(function (e,c)
			return (c:IsSetCard(0x18d) or c:IsType(TYPE_EQUIP)) and c:IsFaceup()
		end)
		e1:SetValue(aux.tgoval)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetTarget(function (e,c)
			return c:IsCode(17255673) and c:IsFaceup()
		end)
		e2:SetValue(1)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(sc)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetTargetRange(0,LOCATION_ONFIELD)
		e3:SetTarget(function(...) 
						local ph=Duel.GetCurrentPhase()
   		 				return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
					end)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(sc)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAIN_SOLVING)
		e4:SetCondition(battlediscon)
		e4:SetOperation(cbattledisop)
		Duel.RegisterEffect(e4,tp)
	end
end)
--仪式
local function rispfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsControler(tp)
end
oneTimeSkill(88301833, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK+LOCATION_HAND,0,5,nil,TYPE_RITUAL) and Duel.IsExistingMatchingCard(Card.IsAllTypes,tp,LOCATION_DECK+LOCATION_HAND,0,2,nil,TYPE_RITUAL+TYPE_MONSTER) and Duel.IsExistingMatchingCard(Card.IsAllTypes,tp,LOCATION_DECK+LOCATION_HAND,0,2,nil,TYPE_RITUAL+TYPE_SPELL) then
		local e1=Effect.GlobalEffect()
		e1:SetDescription(1057)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,23401839,95492061,90027012,57617178,92919429))
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SUMMON_PROC)
		e2:SetTargetRange(LOCATION_HAND,0)
		e2:SetCondition(function(e,c,minc)
			if c==nil then return true end
			return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		end)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,90027012))
		Duel.RegisterEffect(e2,tp)

		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetProperty(EFFECT_FLAG_DELAY)
		e3:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
			return eg:IsExists(rispfilter,1,nil,tp)
		end)
		e3:SetOperation(function (e,tp)
			local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
			if #g>0 then
				local sg=g:CancelableSelect(tp,1,1,nil)
				if sg then Duel.SendtoHand(sg,tp,nil,REASON_RULE) end
			end
		end)
		Duel.RegisterEffect(e3,tp)

		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetCondition(function (e,tp)
			local g=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)
			return #g>0
		end)
		e4:SetOperation(function (e,tp)
			local g=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)
			if #g>0 then
				local sg=g:CancelableSelect(tp,1,1,nil)
				if sg then Duel.SendtoHand(sg,tp,nil,REASON_RULE) end
			end
		end)
		Duel.RegisterEffect(e4,tp)
		local rc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_HAND,0,nil)
		local e5=Effect.CreateEffect(rc)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CHANGE_LEVEL)
		e5:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE,0)
		e5:SetTarget(function(ce,cc) return cc:IsType(TYPE_RITUAL) and cc:IsLevelAbove(1) end)
		e5:SetValue(1)
		--Duel.RegisterEffect(e5,tp)
		Duel.RegisterFlagEffect(tp,88301833,0,0,0)
		function Card.GetAttack(card)
			local gp=card:GetControler()
			if Duel.GetFlagEffect(gp,88301833)>0 and card:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and card:IsType(TYPE_RITUAL) then
				return 1000
			else
				return getattack(card)
			end
		end
	end
end)
--炎兽
local function cylvtg(e,c)
	return c:IsLevel(2,3) and c:IsRace(RACE_CYBERSE)
end
oneTimeSkill(64178424,function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK+LOCATION_HAND,0,10,nil,0x119) then
		local sc1=Duel.CreateToken(tp,14812471)
		local sc2=Duel.CreateToken(tp,87871125)
		local sc3=Duel.CreateToken(tp,57134592)
		local sc4=Duel.CreateToken(tp,31313405)
		local sc5=Duel.CreateToken(tp,41463181)
				local g=Group.FromCards(sc1,sc2,sc3,sc4,sc5)
				Duel.Remove(g,POS_FACEUP,REASON_RULE)
				Duel.SendtoDeck(g,tp,2,REASON_RULE)
		local e1=Effect.GlobalEffect()
		e1:SetDescription(1012)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTarget(cylvtg)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,64178424,0,0,0)
	end
	
	function Effect.GetLabel(effect)
		if aux.GetValueType(effect:GetHandler())=="Card" 
			and effect:GetHandler():IsSetCard(0x119) and effect:GetHandler():IsType(TYPE_FUSION|TYPE_LINK) then
			return 1
		else
			return labget(effect)
		end
	end
end,true)
local function saspfilter(c,e,tp,lv)
	return c:IsSetCard(0x119) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsLevel(lv)
end
local function satoglvfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x119) and Duel.IsExistingMatchingCard(saspfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel()) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c,tp)>0
end
mainphaseSkillEx(64178424,
function(e,tp)
	local g=Duel.GetMatchingGroup(satoglvfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	local sg=g:Select(tp,1,1,nil)
	local lv=sg:GetFirst():GetLevel()
	if Duel.SendtoGrave(sg,REASON_RULE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg=Duel.SelectMatchingCard(tp,saspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
	end
end,
function(e,tp)
	local g=Duel.GetMatchingGroup(satoglvfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	return #g>0 and Duel.GetFlagEffect(tp,64178424)>0
end,
false,1,64178425)

--古代机械
local function gearsplimit(e,c)
	return not (c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)) and not c:IsLocation(LOCATION_EXTRA)
end
oneTimeSkill(44874522,function(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(gearsplimit)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e4,tp)
end)
local gearlist={56889,313513,1278431,4064925,12652643,27483935,32762201,37663536,53541822,64061284,64603182,75892194,91098230}
local function gearcheck(c)
	if c:IsCode(83104731) then return true end
	local bool=false
	local code=c:GetCode()
	for i,v in ipairs(gearlist) do
		if v==code then bool=true break end
	end
	return bool
end
mainphaseSkillList(44874522,
{
	op=function(e,tp)
		local g=Duel.GetMatchingGroup(gearcheck,tp,LOCATION_HAND,0,nil)
		local dg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(tp,dg)
		if Duel.SendtoDeck(dg,tp,2,REASON_RULE)>0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp, function(ac) return ac:IsSetCard(0x7) and ac:IsAbleToHand() end, tp ,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(sg,tp,REASON_RULE)
			Duel.ConfirmCards(1-tp,sg)
		end
	end,
	con=function(e,tp) 
		local g=Duel.GetMatchingGroup(gearcheck,tp,LOCATION_HAND,0,nil)
		local sg=Duel.GetMatchingGroup(function(ac) return ac:IsSetCard(0x7) and ac:IsAbleToHand() end,tp,LOCATION_DECK,0,nil)
		return #g>0 and #sg>0
	end,
	count=1,
	countid=44874522,   
	desc=1109
},
{
	op=function(e,tp)
		local sc=Duel.CreateToken(tp,70147689)
		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end,
	con=function(e,tp) 
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end,
	count=1,
	countid=44874523,
	duellimit=true,
	desc=1151
}
)
--骚灵
local function alterextg(e,c)
	return c:GetSequence()==5 or c:GetSequence()==6
end
oneTimeSkill(25533642, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK+LOCATION_HAND,0,8,nil,0x103) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK+LOCATION_HAND,0,6,nil,TYPE_TRAP) then
		local sc1=Duel.CreateToken(tp,61470213)
		local sc2=Duel.CreateToken(tp,1508649)
		local sc3=Duel.CreateToken(tp,93503294)
		local sc4=Duel.CreateToken(tp,23790299)
		local g=Group.FromCards(sc1,sc2,sc3,sc4)
		Duel.Remove(g,POS_FACEUP,REASON_RULE)
		Duel.SendtoDeck(g,tp,2,REASON_RULE)
		local sc5=Duel.CreateToken(tp,22024279)
		Duel.Remove(sc5,POS_FACEUP,REASON_RULE)
		Duel.SendtoGrave(sc5,REASON_RULE)

		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(1153)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_SZONE,0)
		e1:SetCountLimit(1)
		e1:SetTarget(function (e,c)
			return c:IsSetCard(0x103)
		end)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.GlobalEffect()
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetCode(EFFECT_ADD_SETCODE)
		e2:SetTarget(alterextg)
		e2:SetValue(0x103)
		Duel.RegisterEffect(e2,tp)
		local cm=_G["c42790071"]
		if cm then
			function fakerinit(c)
				--special summon
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(42790071,0))
				e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
				e2:SetRange(LOCATION_HAND)
				e2:SetCode(EVENT_CHAIN_SOLVED)
				e2:SetCountLimit(1,42790071)
				e2:SetProperty(EFFECT_FLAG_DELAY)
				e2:SetCondition(cm.spcon1)
				e2:SetTarget(cm.sptg1)
				e2:SetOperation(cm.spop1)
				c:RegisterEffect(e2)
				--spsummon
				local e3=Effect.CreateEffect(c)
				e3:SetDescription(aux.Stringid(42790071,1))
				e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
				e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
				e3:SetCode(EVENT_SPSUMMON_SUCCESS)
				e3:SetProperty(EFFECT_FLAG_DELAY)
				e3:SetCountLimit(1,42790072)
				e3:SetTarget(cm.sptg2)
				e3:SetOperation(cm.spop2)
				c:RegisterEffect(e3)
			end
			cm.initial_effect=fakerinit
		end
		local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0xff,nil,42790071)
		for tc in aux.Next(g) do
			local bool=tc:IsStatus(STATUS_EFFECT_REPLACED)
			tc:ReplaceEffect(id,80316585)
			if not bool then tc:SetStatus(STATUS_EFFECT_REPLACED,false) end
			tc.initial_effect(tc)
		end
		Duel.RegisterFlagEffect(tp,25533642,0,0,1)
	end
end,true)
mainphaseSkillEx(25533642,
function(e,tp)
	local cg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)	
	if Duel.SendtoDeck(cg:Select(tp,1,1,nil),tp,2,REASON_RULE)>0 then
		local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,59185998)
		local sc=g:Select(tp,1,1,nil):GetFirst()		
		Duel.SendtoHand(sc,tp,REASON_RULE)
	end
end,
function(e,tp)
	local cg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,59185998)
	return #cg>0 and #g>0 and Duel.GetFlagEffect(tp,25533642)>0
end,
false,1,25533643)

--宵暗星转
function worldmatval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x11b,0xfd,0x104,0x116,0x10c,0xfe) then return false,nil end
	return true,true
end
oneTimeSkill(97345699, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK+LOCATION_HAND,0,12,nil,0x11b,0xfd,0x104,0x116,0x10c,0xfe) then
		Duel.RegisterFlagEffect(tp,97345699,0,0,1)
		--hand link
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		e1:SetRange(LOCATION_HAND)
		e1:SetValue(worldmatval)
		e1:SetCountLimit(1,7345699)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetTargetRange(LOCATION_HAND,0)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
	end
end)
local function worldcostfilter(c)
	return c:IsSetCard(0x11b,0xfd,0x104,0x116,0x10c,0xfe) and c:IsDiscardable()
end
local function worldspfilter(c,e,tp)
	return c:IsSetCard(0xfe) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or c:IsAbleToHand())
end
mainphaseSkillEx(97345699,
function(e,tp)
	local cg=Duel.GetMatchingGroup(worldcostfilter,tp,LOCATION_HAND,0,nil)  
	if Duel.SendtoGrave(cg:Select(tp,1,1,nil),REASON_RULE+REASON_DISCARD)>0 then
		local g=Duel.GetMatchingGroup(worldspfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		local op=aux.SelectFromOptions(tp,
			{sc:IsAbleToHand(),1190},
			{sc:IsCanBeSpecialSummoned(e,0,tp,false,false),1152})
		if op==1 then
			Duel.SendtoHand(sc,tp,REASON_RULE)
		else
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end,
function(e,tp)
	local cg=Duel.GetMatchingGroup(worldcostfilter,tp,LOCATION_HAND,0,nil)
	local g=Duel.GetMatchingGroup(worldspfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	return #cg>0 and #g>0 and Duel.GetFlagEffect(tp,97345699)>0
end,
false,1,97345700)

--袭击队集结
local function dddamval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0xae) then return 0
	else return val end
end
local function NotFtmCheck(c)
	return not c:IsSetCard(0x10db,0xba) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_XYZ|TYPE_SYNCHRO|TYPE_FUSION|TYPE_LINK)
end
local function ExtraCheck(c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
local function ActivateCon(e,tp)
	return not Duel.IsExistingMatchingCard(NotFtmCheck,tp,0xff,0,1,nil) and not Duel.IsExistingMatchingCard(ExtraCheck,tp,LOCATION_EXTRA,0,1,nil)
end
oneTimeSkill(52159691, function(e,tp,eg,ep,ev,re,r,rp)
	if ActivateCon(e,tp) then
		local ac=Duel.CreateToken(tp,73347079)
		local ac2=Duel.CreateToken(tp,73347079)
		local bc=Duel.CreateToken(tp,8617563)
		local cc=Duel.CreateToken(tp,96157835)
		local dc=Duel.CreateToken(tp,86221741)
		local ec=Duel.CreateToken(tp,71222868)
		local g=Group.FromCards(ac,ac2,bc,cc,dc,ec)
		Duel.SendtoDeck(g,tp,2,REASON_RULE)
		Duel.RegisterFlagEffect(tp,52159693,0,0,0)
	end
end)
local function tdcheck(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToDeck()
end
local function setfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
local function setcon(e,tp)
	return Duel.GetFlagEffect(tp,52159693)>0 and Duel.GetFlagEffect(tp,52159692)==0 and Duel.IsExistingMatchingCard(tdcheck,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(setfilter,tp,LOCATION_DECK,0,1,1,nil)
end
local function setop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,tdcheck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g1,nil,2,REASON_RULE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(36429703,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
	Duel.RegisterFlagEffect(tp,52159692,RESET_PHASE+PHASE_END,0,0)
end
mainphaseSkill(52159691, setop, setcon, false)
local function tdcheck(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToDeck()
end
local function sendfilter(c)
	return c:IsSetCard(0x10db) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(sendfilter2,tp,LOCATION_DECK,0,1,c)
end
local function sendfilter2(c)
	return c:IsSetCard(0xba) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
local function sendcon(e,tp)
	return Duel.GetFlagEffect(tp,52159693)>0 and Duel.GetFlagEffect(tp,52159691)==0 and Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(sendfilter,tp,LOCATION_DECK,0,1,1,nil)
end
local function sendop(e,tp)
	if Duel.SelectYesNo(tp,1103) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,sendfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g2=Duel.SelectMatchingCard(tp,sendfilter2,tp,LOCATION_DECK,0,1,1,g)
			g:Merge(g2)
			Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.RegisterFlagEffect(tp,52159691,0,0,0)
	end
end
standbyPhaseSkill(52159691, sendop, sendcon, false)
--天气
local function tenkitdcheck(c)
	return c:IsAbleToDeck()
end
local function tenkitdcheck2(c)
	return c:IsAbleToDeck() and c:IsFaceupEx() and c:IsSetCard(0x109)
end
local function tenkitdcheck3(c,e,tp)
	return c:IsAbleToDeck() and c:IsFaceup() and c:IsSetCard(0x109) --and Duel.IsExistingMatchingCard(tenkispcheck,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,c)
end
local function tenkispcheck(c,e,tp,tc)
	return c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
local function tenkitfcheck(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSetCard(0x109)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
mainphaseSkillList(74218258,
{
	op=function(e,tp)
		local g=Duel.GetMatchingGroup(tenkitdcheck,tp,LOCATION_HAND,0,nil)
		local dg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(tp,dg)
		if Duel.SendtoDeck(dg,tp,2,REASON_RULE)>0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,function(ac) return ac:IsSetCard(0x109) and ac:IsFaceupEx() and ac:IsAbleToHand() end,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
			Duel.SendtoHand(sg,tp,REASON_RULE)
			Duel.ConfirmCards(1-tp,sg)
		end
	end,
	con=function(e,tp) 
		local g=Duel.GetMatchingGroup(tenkitdcheck,tp,LOCATION_HAND,0,nil)
		local sg=Duel.GetMatchingGroup(function(ac) return ac:IsSetCard(0x109) and ac:IsFaceupEx() and ac:IsAbleToHand() end,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		return #g>0 and #sg>0
	end,
	count=1,
	countid=74218258,   
	desc=1190
},
{
	op=function(e,tp)
		local g=Duel.GetMatchingGroup(tenkitdcheck2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local dg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(tp,dg)
		if Duel.SendtoDeck(dg,tp,2,REASON_RULE)>0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
			local sg=Duel.SelectMatchingCard(tp,tenkitfcheck,tp,LOCATION_DECK,0,1,1,nil,tp)
			Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end,
	con=function(e,tp) 
		local g=Duel.GetMatchingGroup(tenkitdcheck2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local sg=Duel.GetMatchingGroup(tenkitfcheck,tp,LOCATION_DECK,0,nil,tp)
		return #g>0 and #sg>0
	end,
	count=1,
	countid=74218259,   
	desc=aux.Stringid(91299846,0)
},
{
	op=function(e,tp)
		local g=Duel.GetMatchingGroup(tenkitdcheck3,tp,LOCATION_MZONE,0,nil,e,tp)
		local dg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(tp,dg)
		local tc=dg:GetFirst()
		if Duel.SendtoDeck(dg,tp,2,REASON_RULE)>0 and Duel.IsExistingMatchingCard(tenkispcheck,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,tc) and Duel.SelectYesNo(tp,aux.Stringid(11302671,2)) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,tenkispcheck,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end,
	con=function(e,tp) 
		local g=Duel.GetMatchingGroup(tenkitdcheck3,tp,LOCATION_MZONE,0,nil,e,tp)
		return #g>0
	end,
	count=1,
	countid=74218260,   
	desc=1193
}
)

--人鱼泪
function tearcheck(c)
	return c:IsCode(1845204) or c:IsSetCard(0x9d)
end
oneTimeSkill(77103950, function(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(tearcheck,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) then
		local ag=Group.CreateGroup()
		local token=Duel.CreateToken(tp,74078255)
		ag:AddCard(token)
		token=Duel.CreateToken(tp,74078255)
		ag:AddCard(token)
		token=Duel.CreateToken(tp,37961969)
		ag:AddCard(token)
		token=Duel.CreateToken(tp,37961969)
		ag:AddCard(token)
		token=Duel.CreateToken(tp,572850)
		ag:AddCard(token)
		token=Duel.CreateToken(tp,572850)
		ag:AddCard(token)
		token=Duel.CreateToken(tp,73956664)
		ag:AddCard(token)
		token=Duel.CreateToken(tp,92731385)
		ag:AddCard(token)
		token=Duel.CreateToken(tp,92731385)
		ag:AddCard(token)
		token=Duel.CreateToken(tp,92731385)
		ag:AddCard(token)
		token=Duel.CreateToken(tp,84330567)
		ag:AddCard(token)
		token=Duel.CreateToken(tp,28226490)
		ag:AddCard(token)
		token=Duel.CreateToken(tp,54757758)
		ag:AddCard(token)

		Duel.SendtoDeck(ag,tp,0,REASON_RULE)
		Duel.ShuffleExtra(tp)
		Duel.ShuffleDeck(tp)
	end
end)
--复制猫
local function drcheck(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_RULE)
end
local function cpdrcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==eg:GetFirst():GetControler() and Duel.GetCurrentPhase()==PHASE_DRAW and eg:IsExists(drcheck,1,nil,tp)
end
local function cpdrop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(drcheck,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	local cg=Group.CreateGroup()
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
		cg:AddCard(Duel.CreateToken(tp,82385847))
		cg:AddCard(Duel.CreateToken(tp,82385847))
	end
	if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
		cg:AddCard(Duel.CreateToken(tp,19230407))
		cg:AddCard(Duel.CreateToken(tp,19230407))
	end
	if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
		cg:AddCard(Duel.CreateToken(tp,10045474))
		cg:AddCard(Duel.CreateToken(tp,10045474))
	end
	Duel.SendtoHand(cg,tp,REASON_RULE)
	Duel.ConfirmCards(1-tp,cg)
end
oneTimeSkill(88032456, function(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(cpdrcon)
	e1:SetOperation(cpdrop)
	Duel.RegisterEffect(e1,tp)
end)

local function initialize(e,_tp,eg,ep,ev,re,r,rp)
	local skillCodes=getAllSkillCodes()
	for tp=0,1 do
		local codes={}
		for _,code in ipairs(skillCodes) do
			table.insert(codes,code)
		end
		table.sort(codes)
		local afilter={codes[1],OPCODE_ISCODE}
		if #codes>1 then
			for i=2,#codes do
				table.insert(afilter,codes[i])
				table.insert(afilter,OPCODE_ISCODE)
				table.insert(afilter,OPCODE_OR)
			end
		end
		local player_type = Duel.GetRegistryValue("player_type_" .. tostring(tp))
		local skillKey = "selected_skill_" .. player_type
		local prevSkill = Duel.GetRegistryValue(skillKey)
		if prevSkill then
			skillSelections[tp]=tonumber(prevSkill)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
			local ac=Duel.AnnounceCardSilent(tp,table.unpack(afilter))
			skillSelections[tp]=ac
			Duel.SetRegistryValue(skillKey,ac)
		end
	end
	for tp=0,1 do
		registerSkillForPlayer(tp,skillSelections[tp])
	end
	-- resolve onetime skills
	-- for _,onetimeSkillList in ipairs({onetimeSkillResolveOperationsPrior,onetimeSkillResolveOperations}) do
	local function resolveOnetimeSkill(onetimeSkillList)
		for tp=0,1 do
			for _,onetimeSkillObject in ipairs(onetimeSkillList[tp]) do
				Duel.Hint(HINT_CARD,0,onetimeSkillObject.code)
				onetimeSkillObject.op(e,onetimeSkillObject.tp,eg,ep,ev,re,r,rp)
			end
		end
	end
	resolveOnetimeSkill(onetimeSkillResolveOperationsPrior)
	for tp=0,1 do
		if need_shuffle[tp] then
			local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			local hand_count=#hg
			Duel.SendtoDeck(hg,nil,0,REASON_RULE)
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,hand_count,REASON_RULE)
		end
	end
	resolveOnetimeSkill(onetimeSkillResolveOperations)
end

function Auxiliary.PreloadUds()
	-- disable field
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(0x110011)
	Duel.RegisterEffect(e1,0)

	-- skip m2
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_M2)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)

	-- half effect damage
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(function(e,re,val,r,rp,rc)
		if bit.band(r,REASON_EFFECT)~=0 then return math.floor(val/2)
		else return val end
	end)
	Duel.RegisterEffect(e1,0)

	-- skill init
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(function() return not special_adjusting end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		special_adjusting=true
		initialize(e,tp,eg,ep,ev,re,r,rp)
		e:Reset()
		special_adjusting=false
	end)
	Duel.RegisterEffect(e1,0)
end

-- disable EFFECT_SKIP_M1
EFFECT_SKIP_M1=0

-- 正对面的自身的主要怪兽区域（群豪）
function aux.FrontSequence(c)
	local seq = c:GetSequence()
	local list = {}
	if c:IsLocation(LOCATION_PZONE) then
		list = {
			[0] = 1,
			[4] = 3
		}
	end
	return 1 << (list[seq] or seq)
end
