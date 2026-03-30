Auxiliary.__flip_effect_list = Auxiliary.__flip_effect_list or {}

function Auxiliary.PreloadUds()
    local flip_effect_list = Auxiliary.__flip_effect_list

    local base = {}

	
	base.IsPreviousLocation = Card.IsPreviousLocation
	base.GetPreviousLocation = Card.GetPreviousLocation
	base.IsFaceup = Card.IsFaceup
	base.GetPosition = Card.GetPosition

	base.RegisterEffect = Card.RegisterEffect

	base.redirect_effects = {
		[EFFECT_LEAVE_FIELD_REDIRECT] = true,
		[EFFECT_TO_HAND_REDIRECT] = true,
		[EFFECT_TO_DECK_REDIRECT] = true,
		[EFFECT_TO_GRAVE_REDIRECT] = true,
		[EFFECT_REMOVE_REDIRECT] = true,
	}


	--hook下面这四个方法使涉及反转召唤被召唤无效的卡的位置按旧裁定显示
	Card.IsPreviousLocation = function(c,location)
		local re = c:GetReasonEffect()
		if base.IsPreviousLocation(c,LOCATION_ONFIELD) and c:IsSummonType(SUMMON_TYPE_FLIP) and c:IsReason(REASON_EFFECT) and re~=nil and re:GetCode() == EVENT_FLIP_SUMMON and re:GetCategory()&CATEGORY_DISABLE_SUMMON ~= 0 then
			return false
		end
		return base.IsPreviousLocation(c,location)
	end
	Card.GetPreviousLocation = function(c)
		local re = c:GetReasonEffect()
		if base.IsPreviousLocation(c,LOCATION_ONFIELD) and c:IsSummonType(SUMMON_TYPE_FLIP) and c:IsReason(REASON_EFFECT) and re~=nil and re:GetCode() == EVENT_FLIP_SUMMON and re:GetCategory()&CATEGORY_DISABLE_SUMMON ~= 0 then
			return 0
		end
		return base.GetPreviousLocation(c)
	end
	Card.IsFaceup = function(c)
		local re = Duel.GetChainInfo(1, CHAININFO_TRIGGERING_EFFECT)
		if c:IsLocation(LOCATION_ONFIELD) and c:IsSummonType(SUMMON_TYPE_FLIP) and re~=nil and re:GetCode() == EVENT_FLIP_SUMMON and re:GetCategory()&CATEGORY_DISABLE_SUMMON ~= 0 then
			return false
		end
		return base.IsFaceup(c)
	end
	Card.GetPosition = function(c)
		local re = Duel.GetChainInfo(1, CHAININFO_TRIGGERING_EFFECT)
		if c:IsLocation(LOCATION_ONFIELD) and c:IsSummonType(SUMMON_TYPE_FLIP) and re~=nil and re:GetCode() == EVENT_FLIP_SUMMON and re:GetCategory()&CATEGORY_DISABLE_SUMMON ~= 0 then
			return POS_FACEDOWN
		end
		return base.GetPosition(c)
	end

	--hook RegisterEffect 以将注册的反转效果全部放进自行维护的数组中并且将离场不去原区域的效果全部加上反转召唤被神警则不触发的条件
    Card.RegisterEffect = function(c, e, forced)
		if e and e.GetCode then
			local e_code = e:GetCode()
			if e_code == EVENT_FLIP then
				local cid = c:GetCode()
				flip_effect_list[cid] = flip_effect_list[cid] or {}
				table.insert(flip_effect_list[cid], e)
			elseif base.redirect_effects[e_code] then
				local cid = c:GetCode()
				local old_condition = e:GetCondition()
				e:SetCondition(function(e2,tp2,eg2,ep2,ev2,re2,r2,rp2)
					local re = Duel.GetChainInfo(1, CHAININFO_TRIGGERING_EFFECT)
					if c:IsLocation(LOCATION_ONFIELD) and c:IsSummonType(SUMMON_TYPE_FLIP) and re~=nil and re:GetCode() == EVENT_FLIP_SUMMON and re:GetCategory()&CATEGORY_DISABLE_SUMMON ~= 0 then
						return false
					end
					return old_condition(e2,tp2,eg2,ep2,ev2,re2,r2,rp2)
				end)
			end
		end
        return base.RegisterEffect(c, e, forced)
    end
	-- provide Card.GetFlipEffect to retrieve the registered flip effect of a card
    Card.GetFlipEffect = function(c)
        local cid = c:GetCode()
        local list = flip_effect_list[cid]
        if not list then return nil end
        for _, e in ipairs(list) do
            if e:GetHandler() == c then
                return e
            end
        end
        return nil
    end

end	