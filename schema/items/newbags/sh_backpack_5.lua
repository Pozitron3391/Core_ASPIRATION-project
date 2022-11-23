ITEM.name = "Zone Survival Backpack (Camouflaged)"
ITEM.description = "A backpack. Featuring large compartments for storage of items, as well as being very comfortable."
ITEM.model = "models/kek1ch/sumka5.mdl"

ITEM.price = 20000
ITEM.width = 2
ITEM.height = 2
ITEM.weight = 1.390

ITEM.carryinc = 25
ITEM.outfitCategory = "backpack"

ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(1.5, 0, 200),
	ang = Angle(90, 0, 180),
	fov = 7.6
}

ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
				["Angles"] = Angle(90, -90.016, 89.957),
				["Position"] = Vector(-6.333, 0.016, -1.611),
					["UniqueID"] = "backpack_misery5xd",
					["Size"] = 0.85,
					["Bone"] = "chest",
					["Model"] = "models/kek1ch/sumka5.mdl",
					["ClassName"] = "model",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "backpack_misery5",
			["EditorExpand"] = true,
		},
	},
}