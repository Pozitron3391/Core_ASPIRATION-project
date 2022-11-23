ITEM.name = "Детектор аномалий"
ITEM.description = "Устройство, которое издает звуковой сигнал при приближении аномалий."
ITEM.longdesc = "Этот взломанный дозимтетер является прототипом, сделанным неизвестными источниками. Кажется, он был произведен в довольно больших количествах, хотя его появления в руках большинства сталкеров в зоне загадочны. Некоторые предполагают, что выбросы превратили эти дозиметры в обнаружение аномалий, но это далеко не подтверждено."
ITEM.model = "models/lostsignalproject/items/devices/dosimeter.mdl"
ITEM.category = "Электроника"

ITEM.width = 1
ITEM.height = 1
ITEM.price = 1100
ITEM.weight = 0.720

ITEM.isAnomalydetector = true

ITEM.equipIcon = ix.util.GetMaterial("materials/vgui/ui/stalker/misc/equip.png")

ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(0, 0, 200),
	ang = Angle(90, 0, -180),
	fov = 2.1,
}

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 255)
		else
			surface.SetDrawColor(255, 110, 110, 255)
		end

		surface.SetMaterial(item.equipIcon)
		surface.DrawTexturedRect(w-23,h-23,19,19)
	end
end

function ITEM:PopulateTooltip(tooltip)
    --if !self.entity then
		ix.util.PropertyDesc(tooltip, "Гаджет", Color(200, 200, 200))
        ix.util.PropertyDesc(tooltip, "Детектор", Color(64, 224, 208), Material("vgui/ui/stalker/weaponupgrades/handling.png"))
    --end
end

ITEM.functions.Equip = { -- sorry, for name order.
	name = "Прикрепить к поясу",
	tip = "useTip",
	icon = "icon16/stalker/equip.png",
	OnRun = function(item)
		item:Equip(item.player)

		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == item:GetOwner():GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Открепить от пояса",
	tip = "equipTip",
	icon = "icon16/stalker/unequip.png",
	OnRun = function(item)
		item:UnEquip()

		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == item:GetOwner():GetCharacter():GetInventory():GetID()
	end
}

function ITEM:Equip(client)
	local char = client:GetCharacter()
	local items = char:GetInventory():GetItems()
	for _, v in pairs(items) do
		if (v.id != self.id) then
			local itemTable = ix.item.instances[v.id]

			if (!itemTable) then
				client:NotifyLocalized("tellAdmin", "wid!xt")

				return false
			else
				if (itemTable.isAnomalydetector and itemTable:GetData("equip")) then
					client:NotifyLocalized("You are already equipping an anomaly detector.")

					return false
				end
			end
		end
	end

	self:SetData("equip", true)
	self:OnLoadout()
	client:EmitSound("stalkersound/inv_dozimetr.ogg", 80)
end

function ITEM:UnEquip(client)
	self:SetData("equip", false)
	self.player:SetNetVar("ixhasanomdetector", false)
	self.player:SetData("ixhasanomdetector", false)
end

ITEM:Hook("drop", function(item)
	item:UnEquip(item.player)
end)

function ITEM:OnLoadout()
	if self:GetData("equip", false) then
		self.player:SetNetVar("ixhasanomdetector", true)
		self.player:SetData("ixhasanomdetector", true)
	end
end