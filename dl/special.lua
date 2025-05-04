local skillLists={}
local skillSelections={}
local lp_record={[0]=0,[1]=0}
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
		e1:SetCode(EVENT_FREE_CHAIN)
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

local function standbyPhaseSkill(code, op, con, both)
	phaseSkill(code, PHASE_STANDBY, op, con, both)
end

local function endPhaseSkill(code, op, con, both)
	phaseSkill(code, PHASE_END, op, con, both)
end

--重新开始
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
	local field_6=Duel.CreateToken(tp,50913601)
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
        Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
        local te=tc:GetActivateEffect()
        te:UseCountLimit(tp,1,true)
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
        Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
    end
end,true)
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
		return Duel.GetLP(tp) <= 0 
	end)
	e1:SetOperation(function(...)
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


		local function skipcon(ge)
			return Duel.GetTurnCount()~=ge:GetLabel()
		end
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

		local ph=Duel.GetCurrentPhase()
        local e1=Effect.CreateEffect(rc)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_SKIP_BP)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
        e1:SetTargetRange(1,0)
        if Duel.GetTurnPlayer()==tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
            e1:SetLabel(Duel.GetTurnCount())
            e1:SetCondition(skipcon)
            e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
        else
            e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
        end
        Duel.RegisterEffect(e1,tp)
	end
	)
	Duel.RegisterEffect(e1,tp)
end,true)

--成金
oneTimeSkill(70368879, function(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_RULE)
	Duel.Draw(1-tp,1,REASON_RULE)
end,true)

--天平
oneTimeSkill(67443336, function(e,tp,eg,ep,ev,re,r,rp)
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
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCardSilent(tp,table.unpack(afilter))
		skillSelections[tp]=ac
	end
	for tp=0,1 do
		registerSkillForPlayer(tp,skillSelections[tp])
	end
	-- resolve onetime skills
	for _,onetimeSkillList in ipairs({onetimeSkillResolveOperationsPrior,onetimeSkillResolveOperations}) do
		for tp=0,1 do
			for _,onetimeSkillObject in ipairs(onetimeSkillList[tp]) do
				Duel.Hint(HINT_CARD,0,onetimeSkillObject.code)
				onetimeSkillObject.op(e,onetimeSkillObject.tp,eg,ep,ev,re,r,rp)
			end
		end
	end
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
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		initialize(e,tp,eg,ep,ev,re,r,rp)
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end

-- disable EFFECT_SKIP_M1
EFFECT_SKIP_M1=0
