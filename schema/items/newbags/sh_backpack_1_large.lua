ITEM.name = "UKR"
ITEM.description = "A large backpack. Features compartments for easy storage of your valuables."
ITEM.model = "models/kek1ch/sumka1.mdl"

ITEM.price = 12000
ITEM.width = 2
ITEM.height = 2
ITEM.weight = 1.350
ITEM.invWidth = 6
ITEM.invHeight = 6

ITEM.carryinc = 20
ITEM.outfitCategory = "backpack"

ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(0, -1, 200),
	ang = Angle(90, 0, 90),
	fov = 4.9
}

ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
				["Angles"] = Angle(0, -90.013, 90.004),
				["Position"] = Vector(-7.939, 0.021, 1.611),
					["UniqueID"] = "backpack_misery1xd",
					["Size"] = 1,
					["Bone"] = "chest",
					["Model"] = "models/kek1ch/sumka1.mdl",
					["ClassName"] = "model",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "backpack_misery1large",
			["EditorExpand"] = true,
		},
	},
}