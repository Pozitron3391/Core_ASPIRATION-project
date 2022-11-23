local PLUGIN = PLUGIN

PLUGIN.name = "Random item"
PLUGIN.author = "gumlefar"
PLUGIN.desc = "Случайный выбор предметов на основе веса. Также может сохраняться список выпавших предметов для последующего появления.."

function PLUGIN:LoadData()
	ix.randomitems.droppedplayeritems = self:GetData() or {}
end

function PLUGIN:SaveData()
	self:SetData(ix.randomitems.droppedplayeritems)
end