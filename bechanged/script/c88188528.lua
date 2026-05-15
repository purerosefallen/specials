--混沌
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	if not aux.Fusion_replacement_check then
		aux.Fusion_replacement_check=true
		function Card.IsSetCard(card,...)
			return true
		end
		function Card.IsCode(card,...)
			return true
		end
		function Card.IsOriginalCodeRule(card,...)
			return true
		end
		function Card.IsOriginalSetCard(card,...)
			return true
		end
		function Card.IsFusionCode(card,...)
			return true
		end
		function Card.IsLinkCode(card,...)
			return true
		end
		function Card.IsFusionSetCard(card,...)
			return true
		end
		function Card.IsLinkSetCard(card,...)
			return true
		end
	end
end
