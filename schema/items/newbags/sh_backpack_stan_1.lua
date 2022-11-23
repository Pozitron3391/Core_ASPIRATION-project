ITEM.name = "Обычный рюкзак"
ITEM.description = "Большой рюкзак. Имеет отделения для удобного хранения ваших ценностей."
ITEM.model = "models/vex/seventysix/backpacks/backpack_01.mdl"

ITEM.price = 0
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
				["Angles"] = Angle(0, 180.013, 0.004),
				["Position"] = Vector(-3.939, 0.021, -3.611),
					["UniqueID"] = "backpack_misery1xd",
					["Size"] = 1,
					["Bone"] = "chest",
					["Model"] = "models/vex/seventysix/backpacks/backpack_01.mdl",
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