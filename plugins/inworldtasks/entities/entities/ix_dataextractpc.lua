
ENT.Type = "anim"
ENT.PrintName = "Компьютер"
ENT.Category = "IX-AST | Разное"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "PCColor")
end

ENT.PCColors = {"зеленым", "синим", "красным", "желтым", "пурпурным", "оранжевым"}
ENT.ColorCycleTimestamp = 0

if (SERVER) then
	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.receivers = {}

		self:SetPCColor(self.PCColors[ math.random( #self.PCColors ) ])

		self:SetModel("models/props_lab/harddrive02.mdl")

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		end
	end

	function ENT:Think()
		if self.ColorCycleTimestamp < CurTime() then
			self:SetPCColor(self.PCColors[ math.random( #self.PCColors ) ])
			self.ColorCycleTimestamp = CurTime() + 3600
		end
	end

else

	local GLOW_MATERIAL = Material("sprites/glow04_noz.vmt")
	local colors = {
		["зеленым"] 	= (Color(0, 255, 0)),
		["синим"] 	= (Color(0, 130, 200)),
		["красным"] 	= (Color(255, 0, 0)),
		["желтым"] 	= (Color(255, 255, 0)),
		["пурпурным"] 	= (Color(128, 0, 128)),
		["оранжевым"] 	= (Color(255, 165, 0)),
	}

	function ENT:Draw(flags)
        if LocalPlayer():GetPos():Distance(self:GetPos()) < 2048 then
            self:DrawModel()

            local position = self:GetPos() + self:GetForward() * 10 + self:GetUp() * 9 - self:GetRight() * 2

			render.SetMaterial(GLOW_MATERIAL)
			render.DrawSprite(position, 14, 14, colors[self:GetPCColor()])
        end
    end

	function ENT:OnPopulateEntityInfo(tooltip)
		if self:GetNoDraw() then return end

		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText("Старый компьютер")
		title:SetBackgroundColor(ix.config.Get("color"))
		title:SizeToContents()

		local description = tooltip:AddRow("description")
		description:SetText(string.format("Компьютер, который, кажется, в рабочем состоянии.\nМаленький индикатор на ПК мигает %s.", self:GetPCColor()))
		description:SizeToContents()
	end
end