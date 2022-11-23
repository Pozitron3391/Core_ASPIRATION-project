ITEM.name = "Exohelm"
ITEM.description = "A high-end helmet."
ITEM.longdesc = "This helmet resembles that of an ordinary exoskeleton, but differs sightly from its standard counterpart and has differing protective characteristics. Good protection from gunfire and high calibre rounds in combination with anomaly protection make this helmet one of the best in its category."
ITEM.model = "models/kek1ch/helm_tactic.mdl"
ITEM.price = 125000
--ITEM.busflag = {"ARMOR4", "SPECIAL6_1"}
ITEM.busflag = {"headgear1_1_1"}
ITEM.br = 0.18
ITEM.fbr = 1
ITEM.ar = 0
ITEM.far = 0
ITEM.radProt = 0
ITEM.isGasmask = false
ITEM.isHelmet = true
ITEM.ballisticlevels = {"lll-a"}
ITEM.repairCost = ITEM.price/100*1
ITEM.img = ix.util.GetMaterial("cotz/ui/icons/headgear_radsuit.png")


ITEM.weight = 6.100

ITEM.pacData = {
[1] = {
	["children"] = {
		[1] = {
			["children"] = {
			},
			["self"] = {
				["Skin"] = 0,
				["Invert"] = false,
				["LightBlend"] = 1,
				["CellShade"] = 0,
				["OwnerName"] = "self",
				["AimPartName"] = "",
				["IgnoreZ"] = false,
				["AimPartUID"] = "",
				["Passes"] = 1,
				["Name"] = "",
				["NoTextureFiltering"] = false,
				["DoubleFace"] = false,
				["PositionOffset"] = Vector(0, 0, 0),
				["IsDisturbing"] = false,
				["Fullbright"] = false,
				["EyeAngles"] = false,
				["DrawOrder"] = 0,
				["TintColor"] = Vector(0, 0, 0),
				["UniqueID"] = "4086462223",
				["Translucent"] = false,
				["LodOverride"] = -1,
				["BlurSpacing"] = 0,
				["Alpha"] = 1,
				["Material"] = "",
				["UseWeaponColor"] = false,
				["UsePlayerColor"] = false,
				["UseLegacyScale"] = false,
				["Bone"] = "head",
				["Color"] = Vector(255, 255, 255),
				["Brightness"] = 1,
				["BoneMerge"] = false,
				["BlurLength"] = 0,
				["Position"] = Vector(-73.03099822998, -10.041000366211, -1.7330000400543),
				["AngleOffset"] = Angle(0, 0, 0),
				["AlternativeScaling"] = false,
				["Hide"] = false,
				["OwnerEntity"] = false,
				["Scale"] = Vector(1.0299999713898, 1, 1),
				["ClassName"] = "model",
				["EditorExpand"] = true,
				["Size"] = 1.1499999761581,
				["ModelFallback"] = "",
				["Angles"] = Angle(1.9980000257492, -82.575248718262, -88.762619018555),
				["TextureFilter"] = 3,
				["Model"] = "models/projectpt/headwear_radsuit.mdl",
				["BlendMode"] = "",
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "1121170306",
		["AimPartUID"] = "",
		["Hide"] = false,
		["Duplicate"] = false,
		["ClassName"] = "group",
		["OwnerName"] = "self",
		["IsDisturbing"] = false,
		["Name"] = "radsuit",
		["EditorExpand"] = false,
	},
},
}

ITEM.pacDataExpedition = {
[1] = {
	["children"] = {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Jiggle"] = false,
						["DrawOrder"] = 0,
						["AlternativeBones"] = false,
						["FollowPartName"] = "",
						["Angles"] = Angle(0, 0, 0),
						["OwnerName"] = "self",
						["AimPartName"] = "",
						["FollowPartUID"] = "",
						["Bone"] = "spine 4",
						["InvertHideMesh"] = false,
						["ScaleChildren"] = false,
						["ClassName"] = "bone",
						["FollowAnglesOnly"] = false,
						["Position"] = Vector(0, 0, 0),
						["AimPartUID"] = "",
						["UniqueID"] = "2144846675",
						["Hide"] = false,
						["Name"] = "",
						["Scale"] = Vector(1, 1, 1),
						["MoveChildrenToOrigin"] = false,
						["EditorExpand"] = false,
						["Size"] = 1,
						["PositionOffset"] = Vector(0, 0, 0),
						["IsDisturbing"] = false,
						["AngleOffset"] = Angle(0, 0, 0),
						["EyeAngles"] = false,
						["HideMesh"] = true,
					},
				},
				[2] = {
					["children"] = {
					},
					["self"] = {
						["Jiggle"] = false,
						["DrawOrder"] = 0,
						["AlternativeBones"] = true,
						["FollowPartName"] = "",
						["Angles"] = Angle(0, 7.4000000953674, 0),
						["OwnerName"] = "self",
						["AimPartName"] = "",
						["FollowPartUID"] = "",
						["Bone"] = "head",
						["InvertHideMesh"] = false,
						["ScaleChildren"] = false,
						["ClassName"] = "bone",
						["FollowAnglesOnly"] = false,
						["Position"] = Vector(-0.60000002384186, -0.80000001192093, 0),
						["AimPartUID"] = "",
						["UniqueID"] = "3387404245",
						["Hide"] = false,
						["Name"] = "",
						["Scale"] = Vector(1, 1.0599999427795, 0.95999997854233),
						["MoveChildrenToOrigin"] = false,
						["EditorExpand"] = false,
						["Size"] = 1,
						["PositionOffset"] = Vector(0, 0, 0),
						["IsDisturbing"] = false,
						["AngleOffset"] = Angle(0, 0, 0),
						["EyeAngles"] = false,
						["HideMesh"] = false,
					},
				},
			},
			["self"] = {
				["Invert"] = false,
				["EyeTargetName"] = "",
				["NoLighting"] = false,
				["OwnerName"] = "self",
				["AimPartName"] = "",
				["IgnoreZ"] = false,
				["AimPartUID"] = "",
				["Materials"] = "",
				["Name"] = "",
				["LevelOfDetail"] = 0,
				["NoTextureFiltering"] = false,
				["PositionOffset"] = Vector(0, 0, 0),
				["NoCulling"] = false,
				["Translucent"] = false,
				["DrawOrder"] = 0,
				["Alpha"] = 1,
				["Material"] = "",
				["Bone"] = "head",
				["UniqueID"] = "2815537229",
				["BoneMerge"] = true,
				["EyeTargetUID"] = "",
				["Position"] = Vector(0, 0, 0),
				["BlendMode"] = "",
				["Angles"] = Angle(0, 0, 0),
				["Hide"] = false,
				["EyeAngles"] = false,
				["Scale"] = Vector(1, 1, 1),
				["AngleOffset"] = Angle(0, 0, 0),
				["EditorExpand"] = false,
				["Size"] = 0.94999998807907,
				["Color"] = Vector(1, 1, 1),
				["ClassName"] = "model2",
				["IsDisturbing"] = false,
				["ModelModifiers"] = "",
				["Model"] = "models/stalkerisaac/outfits/radsuit_helm.mdl",
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "1121170306",
		["AimPartUID"] = "",
		["Hide"] = true,
		["Duplicate"] = false,
		["ClassName"] = "group",
		["OwnerName"] = "self",
		["IsDisturbing"] = false,
		["Name"] = "radsuit",
		["EditorExpand"] = false,
	},
},
}

ITEM.pacDataBerill1 = {
[18] = {
	["children"] = {
		[1] = {
			["children"] = {
			},
			["self"] = {
				["Skin"] = 0,
				["Invert"] = false,
				["LightBlend"] = 1,
				["CellShade"] = 0,
				["OwnerName"] = "self",
				["AimPartName"] = "",
				["IgnoreZ"] = false,
				["AimPartUID"] = "",
				["Passes"] = 1,
				["Name"] = "",
				["NoTextureFiltering"] = false,
				["DoubleFace"] = false,
				["PositionOffset"] = Vector(0, 0, 0),
				["IsDisturbing"] = false,
				["Fullbright"] = false,
				["EyeAngles"] = false,
				["DrawOrder"] = 0,
				["TintColor"] = Vector(0, 0, 0),
				["UniqueID"] = "4086462223",
				["Translucent"] = false,
				["LodOverride"] = -1,
				["BlurSpacing"] = 0,
				["Alpha"] = 1,
				["Material"] = "",
				["UseWeaponColor"] = false,
				["UsePlayerColor"] = false,
				["UseLegacyScale"] = false,
				["Bone"] = "head",
				["Color"] = Vector(255, 255, 255),
				["Brightness"] = 1,
				["BoneMerge"] = false,
				["BlurLength"] = 0,
				["Position"] = Vector(-70.430999755859, -10.440999984741, -1.7330000400543),
				["AngleOffset"] = Angle(0, 0, 0),
				["AlternativeScaling"] = false,
				["Hide"] = false,
				["OwnerEntity"] = false,
				["Scale"] = Vector(1, 1, 1),
				["ClassName"] = "model",
				["EditorExpand"] = true,
				["Size"] = 1.1,
				["ModelFallback"] = "",
				["Angles"] = Angle(1.9980000257492, -82.575248718262, -88.762619018555),
				["TextureFilter"] = 3,
				["Model"] = "models/projectpt/headwear_radsuit.mdl",
				["BlendMode"] = "",
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "1121170306",
		["AimPartUID"] = "",
		["Hide"] = false,
		["Duplicate"] = false,
		["ClassName"] = "group",
		["OwnerName"] = "self",
		["IsDisturbing"] = false,
		["Name"] = "radsuit",
		["EditorExpand"] = false,
	},
},	
}

ITEM.pacDataNBC = {
[1] = {
	["children"] = {
		[1] = {
			["children"] = {
			},
			["self"] = {
				["Skin"] = 0,
				["Invert"] = false,
				["LightBlend"] = 1,
				["CellShade"] = 0,
				["OwnerName"] = "self",
				["AimPartName"] = "",
				["IgnoreZ"] = false,
				["AimPartUID"] = "",
				["Passes"] = 1,
				["Name"] = "",
				["NoTextureFiltering"] = false,
				["DoubleFace"] = false,
				["PositionOffset"] = Vector(0, 0, 0),
				["IsDisturbing"] = false,
				["Fullbright"] = false,
				["EyeAngles"] = false,
				["DrawOrder"] = 0,
				["TintColor"] = Vector(0, 0, 0),
				["UniqueID"] = "4086462223",
				["Translucent"] = false,
				["LodOverride"] = -1,
				["BlurSpacing"] = 0,
				["Alpha"] = 1,
				["Material"] = "",
				["UseWeaponColor"] = false,
				["UsePlayerColor"] = false,
				["UseLegacyScale"] = false,
				["Bone"] = "head",
				["Color"] = Vector(255, 255, 255),
				["Brightness"] = 1,
				["BoneMerge"] = false,
				["BlurLength"] = 0,
				["Position"] = Vector(-73.231002807617, -8.5410003662109, -1.6130000352859),
				["AngleOffset"] = Angle(0, 0, 0),
				["AlternativeScaling"] = false,
				["Hide"] = false,
				["OwnerEntity"] = false,
				["Scale"] = Vector(1.0299999713898, 1, 1),
				["ClassName"] = "model",
				["EditorExpand"] = true,
				["Size"] = 1.1499999761581,
				["ModelFallback"] = "",
				["Angles"] = Angle(1.9980000257492, -82.575248718262, -88.762619018555),
				["TextureFilter"] = 3,
				["Model"] = "models/projectpt/headwear_radsuit.mdl",
				["BlendMode"] = "",
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "1121170306",
		["AimPartUID"] = "",
		["Hide"] = false,
		["Duplicate"] = false,
		["ClassName"] = "group",
		["OwnerName"] = "self",
		["IsDisturbing"] = false,
		["Name"] = "radsuit",
		["EditorExpand"] = false,
	},
},	
}