--村规决斗：汉诺之塔 Finale
--后攻玩家开局时抽1张卡；先攻第1回合可以进入战斗阶段。
--所有1速效果在自己·对方回合都能发动。

--※要把速攻魔法·灵摆卡以外的1速魔法在对方回合发动的场合，必须先在场上盖放。
--※并不意味着变成了2速，因此旋风可以直接按死想要发动的通常魔法卡。

--开局时，双方将1张神速召唤（55557574）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--自己·对方回合，这张卡在除外的状态才能从下列效果中选1个发动。
--这个效果的发动和效果不会被无效化，同1个连锁只能发动1次。
--·进行1次同调召唤。
--·进行1次XYZ召唤。
--·进行1次连接召唤。
--·进行1次灵摆召唤。（注：需要消耗自己正常灵摆召唤的次数）
--·从自己的手卡将1只怪兽通常召唤（注：需要消耗自己的通常召唤次数）
--·履行特殊召唤的手续，将1只怪兽（如坏兽）从手卡特殊召唤。
--·从自己的手卡将任意数量的魔法·陷阱卡盖放。

CUNGUI = {}
CUNGUI.SPSummonProcs={}
CUNGUI.SPSummonProcTargetRanges={}
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN,5)

OrigTargetRange = Effect.SetTargetRange 
Effect.SetTargetRange = function(e,s,o)
	CUNGUI.SPSummonProcTargetRanges[e]={s,o}
	OrigTargetRange(e,s,o)
end

Effect.GetTargetRange = function(e)
	if not CUNGUI.SPSummonProcTargetRanges[e] then return nil,nil end
	return CUNGUI.SPSummonProcTargetRanges[e][1],CUNGUI.SPSummonProcTargetRanges[e][2]
end

OrigRegister = Card.RegisterEffect
Card.RegisterEffect = function(c,e,forced)
	local typ = e:GetType()
	if typ and (typ & EFFECT_TYPE_IGNITION)>0 then
		e:SetType(EFFECT_TYPE_QUICK_O)
		e:SetCode(EVENT_FREE_CHAIN)
		local cat = e:GetCategory()
		if cat and (cat & (CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_NEGATE))>0 then
			local prop = e:GetProperty()
			if not prop then prop = 0 end
			prop = prop | (EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
			e:SetProperty(prop)
		end
	end
	if typ and (typ & EFFECT_TYPE_ACTIVATE)>0 then
		local prop = e:GetProperty()
		if not prop then prop = 0 end
		e:SetProperty(prop,EFFECT_FLAG2_COF)
		local cond = e:GetCondition()
		e:SetCondition(CUNGUI.ReworkSpellCondition(cond))
	end
	local code = e:GetCode()
	if code == EFFECT_SPSUMMON_PROC then
		if not CUNGUI.SPSummonProcs[c] then CUNGUI.SPSummonProcs[c] = {} end
		table.insert(CUNGUI.SPSummonProcs[c],e)
	end
	return OrigRegister(c,e,forced)
end

function CUNGUI.ReworkSpellCondition(f)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if not f then f=aux.TRUE end
		local ot = e:GetHandler():GetOriginalType()
		if (ot & TYPE_SPELL+TYPE_PENDULUM)==0 or (ot & TYPE_QUICKPLAY)>0 then return f(e,tp,eg,ep,ev,re,r,rp) end
		return Duel.GetCurrentChain()<1 and f(e,tp,eg,ep,ev,re,r,rp)
	end
end

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end

CUNGUI.RegisteredCards = Group.CreateGroup()

function CUNGUI.AdjustOperation()
	if not CUNGUI.INIT then
		CUNGUI.INIT = true
		CUNGUI.RegisterCardRule(0)
		CUNGUI.RegisterCardRule(1)
		Duel.Draw(1,1,REASON_RULE)
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
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_HAND,LOCATION_HAND,nil,TYPE_PENDULUM+TYPE_SPELL)
	g:ForEach(CUNGUI.RegisterSpecialEffects)
end

function CUNGUI.RegisterSpecialEffects(c)
	if CUNGUI.RegisteredCards:IsContains(c) then return end
	CUNGUI.RegisteredCards:AddCard(c)
	if (c:GetOriginalType() & TYPE_QUICKPLAY)>0 then return end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(CUNGUI.setcond)
	e3:SetValue(TYPE_QUICKPLAY)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3,true)
	e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	c:RegisterEffect(e3,true)
end

function CUNGUI.setcond(e)
	return e:GetHandler():IsFacedown() and Duel.GetTurnPlayer()==1-e:GetHandler():GetControler()
end

CUNGUI.RuleCard={}

function CUNGUI.RegisterCardRule(tp)
	local c=Duel.CreateToken(tp,55557574)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	--synchro
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50091196,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.ruletg_synchro)
	e1:SetOperation(CUNGUI.ruleop_synchro)
	c:RegisterEffect(e1)
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5352328,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.ruletg_xyz)
	e1:SetOperation(CUNGUI.ruleop_xyz)
	c:RegisterEffect(e1)
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65741786,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.ruletg_link)
	e1:SetOperation(CUNGUI.ruleop_link)
	c:RegisterEffect(e1)
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1264319,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.ruletg_fusion)
	e1:SetOperation(CUNGUI.ruleop_fusion)
	--c:RegisterEffect(e1)
	e1=aux.AddRitualProcUltimate(c,aux.TRUE,Card.GetLevel,"Greater",nil,nil,nil,true)
	e1:SetDescription(aux.Stringid(34834619,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	local tgt=e1:GetTarget()
	e1:SetTarget(CUNGUI.ruletg_ritual(tgt))
	--c:RegisterEffect(e1)
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15939229,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.ruletg_sset)
	e1:SetOperation(CUNGUI.ruleop_sset)
	c:RegisterEffect(e1)
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(aux.TRUE)
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19041767,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.ruletg_summon)
	e1:SetOperation(CUNGUI.ruleop_summon)
	c:RegisterEffect(e1)
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45803070,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.ruletg_spsummon)
	e1:SetOperation(CUNGUI.ruleop_spsummon)
	c:RegisterEffect(e1)
	e1=Effect.CreateEffect(c)
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.ruletg_pendsummon)
	e1:SetOperation(CUNGUI.ruleop_pendsummon)
	c:RegisterEffect(e1)
end

function CUNGUI.ruletg_pendsummonfiltercond(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	if Auxiliary.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then
		return false
	end
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or c==rpz or not rpz:IsStatus(STATUS_EFFECT_ENABLED) then
		return false
	end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(CUNGUI.pc_filter,1,nil,e,tp,lscale,rscale,eset)
end

function CUNGUI.pc_filter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=Auxiliary.PendulumSummonableBool(c)
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
		and (Auxiliary.PendulumChecklist&(0x1<<tp)==0 or Auxiliary.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
end

function CUNGUI.ruletg_pendsummonfilter(c,e,tp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil or not lpz:IsStatus(STATUS_EFFECT_ENABLED) then return false end
	return CUNGUI.ruletg_pendsummonfiltercond(e,lpz,Group.FromCards(c))
end
function CUNGUI.ruletg_pendsummon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(CUNGUI.ruletg_pendsummonfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp)
			and Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>1
			and c:GetFlagEffect(66666666)==0
	end
	c:RegisterFlagEffect(66666666,RESET_CHAIN,0,1)
end
function CUNGUI.ruleop_pendsummon(e,tp,eg,ep,ev,re,r,rp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_EXTRA,0)
	if #g==0 then return end
	local sg=Group.CreateGroup()
	local pop=aux.PendOperation()
	pop(e,tp,eg,ep,ev,re,r,rp,lpz,sg,g)
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
end
function CUNGUI.ruletg_spsummonfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not CUNGUI.SPSummonProcs[c] then return false end
	for i,e in pairs(CUNGUI.SPSummonProcs[c]) do
		local cond = e:GetCondition() or aux.TRUE
		local tg = e:GetTarget() or aux.TRUE
		local op = e:GetOperation()
		local prop = e:GetProperty()
		local tgs,tgo = e:GetTargetRange()
		local tp = c:GetControler()
		local sumtyp,zone = e:GetValue()
		local sump = tp
		if (prop & EFFECT_FLAG_SPSUM_PARAM)==0 then
			tgs = POS_FACEUP
		else
			tgs = tgs or POS_FACEUP
			if tgo==1 then
				sump = 1-tp
			end
		end
		sumtyp = sumtyp or 0
		zone = zone or 0xff
		if e:CheckCountLimit(tp) and cond(e,c,sumtyp) and tg(e,tp,eg,ep,ev,re,r,rp,0,c)
			and c:IsCanBeSpecialSummoned(e,sumtyp,tp,true,false,tgs,sump,zone) then return true end
	end -- c,e,sumtyp
end

function CUNGUI.ruletg_spsummon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
		Duel.GetMZoneCount(tp)>0 and
		Duel.IsExistingMatchingCard(CUNGUI.ruletg_spsummonfilter,tp,LOCATION_HAND,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and c:GetFlagEffect(66666666)==0 end
	c:RegisterFlagEffect(66666666,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function CUNGUI.ruleop_spsummon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
	local tc
	local g=Duel.SelectMatchingCard(tp,CUNGUI.ruletg_spsummonfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	if #g>0 then
		tc=g:GetFirst()
		local procs={}
		local procs_desc={}
		for i,e in pairs(CUNGUI.SPSummonProcs[tc]) do
			local cond = e:GetCondition()
			local op = e:GetOperation()
			local prop = e:GetProperty()
			local tgs,tgo = e:GetTargetRange()
			local tp = tc:GetControler()
			local sumtyp,zone = e:GetValue()
			local sump = tp
			if (prop & EFFECT_FLAG_SPSUM_PARAM)==0 then
				tgs = POS_FACEUP
			else
				tgs = tgs or POS_FACEUP
				if tgo==1 then
					sump = 1-tp
				end
			end
			sumtyp = sumtyp or 0
			zone = zone or 0xff
			local condyes = cond(e,tc,sumtyp)
			if e:CheckCountLimit(tp) and condyes and tc:IsCanBeSpecialSummoned(e,sumtyp,tp,true,false,tgs,sump,zone) then
				table.insert(procs,e)
				local desc = e:GetDescription()
				if not desc or desc==0 then desc = aux.Stringid(82301904,0) end
				table.insert(procs_desc, desc)
			end
		end
		local opt = 1
		if #procs_desc>1 then
			opt = Duel.SelectOption(tp,table.unpack(procs_desc))+1
		end
		local te=procs[opt]
		local tecond = e:GetCondition() or aux.TRUE
		local tetg = e:GetTarget() or aux.TRUE
		local teop = e:GetOperation() or aux.TRUE
		local teprop = e:GetProperty() or 0
		local tetgs,tetgo = e:GetTargetRange()
		local tetp = tc:GetControler()
		local tesumtyp,tezone = e:GetValue()
		local tesump = tetp
		if (teprop & EFFECT_FLAG_SPSUM_PARAM)==0 then
			tetgs = POS_FACEUP
		else
			tetgs = tetgs or POS_FACEUP
			if tetgo==1 then
				tesump = 1-tetp
			end
		end
		tesumtyp = tesumtyp or 0
		tezone = tezone or 0xff
		Duel.DisableActionCheck(true)
		tetg(te,tetp,tc,tp,0,te,REASON_RULE,tp,1,tc)
		teop(te,tetp,tc,tp,0,te,REASON_RULE,tp,tc)
		Duel.DisableActionCheck(false)
		Duel.SpecialSummon(tc,tesumtyp,tetp,tesump,true,false,tetgs,tezone)
		local _,cl2=te:GetCountLimit()
		if not cl2 then cl2 = 0 end
		te:UseCountLimit(tp,1,(cl2 & EFFECT_FLAG_OATH)>0)
		tc:CompleteProcedure()
	end
end

function CUNGUI.ruletg_summonfilter(c)
	if not c:IsSummonableCard() then return false end
	return (c:IsSummonable(false,nil) or c:IsMSetable(false,nil))
end

function CUNGUI.ruletg_summon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.ruletg_summonfilter,tp,LOCATION_HAND,0,1,nil,nil) and c:GetFlagEffect(66666666)==0 end
	c:RegisterFlagEffect(66666666,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function CUNGUI.ruleop_summon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,CUNGUI.ruletg_summonfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		local s1=tc:IsSummonable(false,nil)
		local s2=tc:IsMSetable(false,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,false,nil)
		else
			Duel.MSet(tp,tc,false,nil)
		end
	end
end

function CUNGUI.ruletg_ssetfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end

function CUNGUI.ruletg_sset(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.ruletg_ssetfilter,tp,LOCATION_HAND,0,1,nil,nil) and c:GetFlagEffect(66666666)==0 end
	c:RegisterFlagEffect(66666666,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function CUNGUI.ruleop_sset(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,CUNGUI.ruletg_ssetfilter,tp,LOCATION_HAND,0,1,99,nil)
	if #g>0 then
		Duel.SSet(tp,g,tp,false)
	end
end

function CUNGUI.ruletg_synchro(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) and c:GetFlagEffect(66666666)==0 end
	c:RegisterFlagEffect(66666666,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function CUNGUI.ruleop_synchro(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
function CUNGUI.ruletg_xyz(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) and c:GetFlagEffect(66666666)==0 end
	c:RegisterFlagEffect(66666666,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function CUNGUI.ruleop_xyz(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,sg:GetFirst(),nil)
	end
end

function CUNGUI.ruletg_link(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) and c:GetFlagEffect(66666666)==0 end
	c:RegisterFlagEffect(66666666,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function CUNGUI.ruleop_link(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil)
	end
end

function CUNGUI.fusion_filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function CUNGUI.fusion_filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function CUNGUI.ruletg_fusion(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if c:GetFlagEffect(66666666)>0 then return false end
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(CUNGUI.fusion_filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(CUNGUI.fusion_filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	c:RegisterFlagEffect(66666666,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function CUNGUI.ruleop_fusion(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(CUNGUI.fusion_filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(CUNGUI.fusion_filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(CUNGUI.fusion_filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end

function CUNGUI.ruletg_ritual(f)
	if f==nil then f=aux.TRUE end
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return f(e,tp,eg,ep,ev,re,r,rp,chk) and c:GetFlagEffect(66666666)==0 end
		c:RegisterFlagEffect(66666666,RESET_CHAIN,0,1)
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		f(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end