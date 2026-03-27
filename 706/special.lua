Auxiliary.__flip_effect_list = Auxiliary.__flip_effect_list or {}

function Auxiliary.PreloadUds()
    local flip_effect_list = Auxiliary.__flip_effect_list

    local base = {}
    base.RegisterEffect = Card.RegisterEffect

    Card.RegisterEffect = function(c, e, forced)
        if e and e.GetCode and e:GetCode() == EVENT_FLIP then
            local cid = c:GetCode()
            flip_effect_list[cid] = flip_effect_list[cid] or {}
            table.insert(flip_effect_list[cid], e)
        end
        return base.RegisterEffect(c, e, forced)
    end

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