ITEM.name = "Bag"
ITEM.description = "A bag to increase your carry capacity."
ITEM.model = "models/props_c17/suitcase001a.mdl"
ITEM.category = "Storage"

ITEM.width = 2
ITEM.height = 2
ITEM.price = 0

ITEM.invWidth = 4
ITEM.invHeight = 2

ITEM.isNewBag = true
ITEM.outfitCategory = "backpack"
ITEM.pacData = {}
ITEM.equipIcon = ix.util.GetMaterial("materials/vgui/ui/stalker/misc/equip.png")

ITEM.weight = 1
ITEM.carryinc = 10

function ITEM:GetDescription()
	local quant = self:GetData("quantity", self.ammoAmount or self.quantity or 0)
	local quantdesc = ""
	local invdesc = ""
	if self.longdesc then
		invdesc = "\n\n"..(self.longdesc)
	end

	if self.quantdesc then
		quantdesc = "\n\n"..Format(self.quantdesc, quant)
	end

	if (self.entity) then
		return (self.description)
	else
        return (self.description..quantdesc..invdesc)
	end
end

if (CLIENT) then
	function ITEM:PaintOver(item, width, height)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 255)
			--surface.DrawRect(w - 14, h - 14, 8, 8)
		else
			surface.SetDrawColor(255, 110, 110, 255)
		end

		surface.SetMaterial(item.equipIcon)
		surface.DrawTexturedRect(width-23,height-23,19,19)
	end
end

function ITEM:PopulateTooltip(tooltip)
    if (!self.entity) then
        ix.util.PropertyDesc2(tooltip, "Рюкзак", Color(64, 224, 208), Material("vgui/ui/stalker/weaponupgrades/handling.png"))
    end

    if (self.PopulateTooltipIndividual) then
      self:PopulateTooltipIndividual(tooltip)
    end
end

ITEM.functions.Equip = {
	name = "Надеть",
	tip = "equipTip",
	icon = "icon16/stalker/equip.png",
	OnRun = function(item)
		local char = item.player:GetCharacter()
		local items = char:GetInventory():GetItems()

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("equip")) then
					item.player:Notify("Вы уже экипируете этот вид снаряжения")

					return false
				end
			end
		end

		item:SetData("equip", true)
		item.player:AddPart(item.uniqueID, item)
		char:UpdateWeight()

		if (item.attribBoosts) then
			for k, v in pairs(item.attribBoosts) do
				char:AddBoost(item.uniqueID, k, v)
			end
		end

		item:OnEquipped()
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and
			hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == item:GetOwner():GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Снять",
	tip = "equipTip",
	icon = "icon16/stalker/unequip.png",
	OnRun = function(item)
		local char = item.player:GetCharacter()

		if (!char:CanRemoveCarry(item)) then
			item.player:Notify("Если снять, у вас будет избыточный вес.")
			return false
		end

		item:RemovePart(item.player)
		char:UpdateWeight()

		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false
	end
}

ITEM:Hook("drop", function(item)
	if (item:GetData("equip") && item.player:GetCharacter():CanRemoveCarry(item)) then
		item:RemovePart(item.player)
	end
end)

function ITEM:RemovePart(client)
	local char = client:GetCharacter()

	self:SetData("equip", false)
	client:RemovePart(self.uniqueID)

	if (self.attribBoosts) then
		for k, _ in pairs(self.attribBoosts) do
			char:RemoveBoost(self.uniqueID, k)
		end
	end

	self:OnUnequipped()
end

-- Called before the item is permanently deleted.
function ITEM:OnRemoved()
	local owner = self.player
	local index = self:GetData("id")

	if (self:GetData("equip")) then
		self:RemovePart(owner)
	end
	if (index) then
		local query = mysql:Delete("ix_items")
			query:Where("inventory_id", index)
		query:Execute()

		query = mysql:Delete("ix_inventories")
			query:Where("inventory_id", index)
		query:Execute()
	end
end

function ITEM:OnEquipped()
	self.player:EmitSound("stalkersound/inv_slot.mp3")
end

function ITEM:OnUnequipped()
	self.player:EmitSound("stalkersound/inv_slot.mp3")
end

---------------------------------------99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999-------------------------------------------

ITEM.functions.View = {
	icon = "icon16/briefcase.png",
	OnClick = function(item)
		local index = item:GetData("id", "")

		if (index) then
			local panel = ix.gui["inv"..index]
			local inventory = ix.item.inventories[index]
			local parent = IsValid(ix.gui.menuInventoryContainer) and ix.gui.menuInventoryContainer or ix.gui.openedStorage

			if (IsValid(panel)) then
				panel:Remove()
			end

			if (inventory and inventory.slots) then
				panel = vgui.Create("ixInventory", IsValid(parent) and parent or nil)
				panel:SetInventory(inventory)
				panel:ShowCloseButton(true)
				panel:SetTitle(item.GetName and item:GetName() or L(item.name))

				if (parent != ix.gui.menuInventoryContainer) then
					panel:Center()

					if (parent == ix.gui.openedStorage) then
						panel:MakePopup()
					end
				else
					panel:MoveToFront()
				end

				ix.gui["inv"..index] = panel
			else
				ErrorNoHalt("[Helix] Attempt to view an uninitialized inventory '"..index.."'\n")
			end
		end

		return false
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetData("id") and !IsValid(ix.gui["inv" .. item:GetData("id", "")])
	end
}
/*ITEM.functions.combine = {
	OnRun = function(item, data)
		ix.item.instances[data[1]]:Transfer(item:GetData("id"))

		return false
	end,
	OnCanRun = function(item, data)
		local index = item:GetData("id", "")

		if (index) then
			local inventory = ix.item.inventories[index]

			if (inventory) then
				return true
			end
		end

		return false
	end
}

if (CLIENT) then
	function ITEM:PaintOver(item, width, height)
		local panel = ix.gui["inv" .. item:GetData("id", "")]

		if (!IsValid(panel)) then
			return
		end

		if (vgui.GetHoveredPanel() == self) then
			panel:SetHighlighted(true)
		else
			panel:SetHighlighted(false)
		end
	end
end*/

-- Вызывается при создании нового экземпляра этого элемента.
function ITEM:OnInstanced(invID, x, y)
	local inventory = ix.item.inventories[invID]

	ix.inventory.New(inventory and inventory.owner or 0, self.uniqueID, function(inv)
		local client = inv:GetOwner()

		inv.vars.isBag = self.uniqueID
		self:SetData("id", inv:GetID())

		if (IsValid(client)) then
			inv:AddReceiver(client)
		end
	end)
end

function ITEM:GetInventory()
	local index = self:GetData("id")

	if (index) then
		return ix.item.inventories[index]
	end
end

ITEM.GetInv = ITEM.GetInventory

-- Вызывается, когда элемент впервые появляется для клиента.
function ITEM:OnSendData()
	local index = self:GetData("id")

	if (index) then
		local inventory = ix.item.inventories[index]

		if (inventory) then
			inventory.vars.isBag = self.uniqueID
			inventory:Sync(self.player)
			inventory:AddReceiver(self.player)
		else
			local owner = self.player:GetCharacter():GetID()

			ix.inventory.Restore(self:GetData("id"), self.invWidth, self.invHeight, function(inv)
				inv.vars.isBag = self.uniqueID
				inv:SetOwner(owner, true)

				if (!inv.owner) then
					return
				end

				for client, character in ix.util.GetCharacters() do
					if (character:GetID() == inv.owner) then
						inv:AddReceiver(client)
						break
					end
				end
			end)
		end
	else
		ix.inventory.New(self.player:GetCharacter():GetID(), self.uniqueID, function(inv)
			self:SetData("id", inv:GetID())
		end)
	end
end

ITEM.postHooks.drop = function(item, result)
	local index = item:GetData("id")

	local query = mysql:Update("ix_inventories")
		query:Update("character_id", 0)
		query:Where("inventory_id", index)
	query:Execute()

	net.Start("ixBagDrop")
		net.WriteUInt(index, 32)
	net.Send(item.player)
end

if (CLIENT) then
	net.Receive("ixBagDrop", function()
		local index = net.ReadUInt(32)
		local panel = ix.gui["inv"..index]

		if (panel and panel:IsVisible()) then
			panel:Close()
		end
	end)
end

-- Вызывается перед необратимым удалением элемента.
--[[function ITEM:OnRemoved()
	local index = self:GetData("id")

	if (index) then
		local query = mysql:Delete("ix_items")
			query:Where("inventory_id", index)
		query:Execute()

		query = mysql:Delete("ix_inventories")
			query:Where("inventory_id", index)
		query:Execute()
	end
end]]

-- Вызывается, когда предмет должен сообщить, можно ли его перемещать между запасами.
function ITEM:CanTransfer(oldInventory, newInventory)
	local index = self:GetData("id")

	if (newInventory) then
		if (newInventory.vars and newInventory.vars.isBag) then
			return false
		end

		local index2 = newInventory:GetID()

		if (index == index2) then
			return false
		end

		for _, v in pairs(self:GetInventory():GetItems()) do
			if (v:GetData("id") == index2) then
				return false
			end
		end
	end

	return !newInventory or newInventory:GetID() != oldInventory:GetID() or newInventory.vars.isBag
end

function ITEM:OnTransferred(curInv, inventory)
	local bagInventory = self:GetInventory()

	if (isfunction(curInv.GetOwner)) then
		local owner = curInv:GetOwner()

		if (IsValid(owner)) then
			bagInventory:RemoveReceiver(owner)
		end
	end

	if (isfunction(inventory.GetOwner)) then
		local owner = inventory:GetOwner()

		if (IsValid(owner)) then
			bagInventory:AddReceiver(owner)
			bagInventory:SetOwner(owner)
		end
	else
		-- it's not in a valid inventory so nobody owns this bag
		bagInventory:SetOwner(nil)
	end
end

-- Вызывается после регистрации элемента в таблицах элементов.
function ITEM:OnRegistered()
	ix.inventory.Register(self.uniqueID, self.invWidth, self.invHeight, true)
end

