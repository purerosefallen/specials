-- Change DrawOverride.VALUE to set the replacement for "draw 1".

if not DrawOverride then DrawOverride = {} end

-- CONFIG: set your global draw amount here
DrawOverride.VALUE = DrawOverride.VALUE or 5  -- ← change this to any integer >=1
