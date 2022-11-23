--[[
	PLUGIN.buffs[ << string, Buff's Unique Name>> ] = { -- This is the unique name for identifying the buff.
		name =<< string, Buff's Display Name>>, -- This is the display name of the buff. 
		desc = << string, Buff's Description>>, -- This is the description of this buff.
		nodisp = << boolean, Buff's Display Factor >>, -- This is the factor for displaying this buff. ( For advaced scripters )
		func = << function, Buff's Think Function >>,
		onbuffed = << function, Buff's Function that executes on buffed >>, 
		onunbuffed = << function, Buff's Function that executes on Unbuffed >>, 
	}
]]--

local PLUGIN = PLUGIN

PLUGIN.buffs[ "buff_slowheal" ] = {
	name = "Выздоровление",
	desc = "Ты исцеляешься.",
	func = function( player, parameter)
		player.timeNextHeal = player.timeNextHeal or CurTime()
		if player.timeNextHeal < CurTime() then
			player:SetHealth(math.Clamp(player:Health() + (parameter.amount or 1), 0, player:GetMaxHealth()))

			player.timeNextHeal = CurTime() + 0.5
		end
	end,
}

PLUGIN.buffs[ "buff_rapidheal" ] = {
	name = "Выздоровление",
	desc = "Ты исцеляешься.",
	func = function( player, parameter)
		player.timeNextFastHeal = player.timeNextFastHeal or CurTime()
		if player.timeNextFastHeal < CurTime() then
			player:SetHealth(math.Clamp(player:Health() + (parameter.amount or 1), 0, player:GetMaxHealth()))

			player.timeNextFastHeal = CurTime() + 0.5
		end
	end,
}

PLUGIN.buffs[ "buff_staminarestore" ] = {
	name = "Энергия",
	desc = "Вы быстрее восстанавливаете энергию.",
	func = function( player, parameter)
		player.timeNextTickStam = player.timeNextTickStam or CurTime()
		if player.timeNextTickStam < CurTime() then
			player:SetLocalVar("stm", math.min(player:GetLocalVar("stm", 100) + (parameter.amount or 1), 100))

			player.timeNextTickStam = CurTime() + 0.5
		end
	end,
}

PLUGIN.buffs[ "buff_radiationremoval" ] = {
	name = "Антирад",
	desc = "Вы становитесь менее радиоактивным.",
	func = function( player, parameter)
		player.timeNextTickRadRem = player.timeNextTickRadRem or CurTime()
		if player.timeNextTickRadRem < CurTime() then
			player:addRadiation(-parameter.amount)

			player.timeNextTickRadRem = CurTime() + 0.5
		end
	end,
}

PLUGIN.buffs[ "buff_psyheal" ] = {
	name = "Психическое исцеление", -- Psyheal
	desc = "Ваш разум проясняется.",
	func = function( player, parameter)
		player.timeNextTickPsyHeal = player.timeNextTickPsyHeal or CurTime()
		if player.timeNextTickPsyHeal < CurTime() then
			player:HealPsyHealth(parameter.amount)

			player.timeNextTickPsyHeal = CurTime() + 0.5
		end
	end,
}

PLUGIN.buffs[ "buff_radprotect" ] = {
	name = "Радиационная защита",
	desc = "Вы защищены от радиации.",
	func = function( player, parameter)
		
	end,
}

PLUGIN.buffs[ "buff_psysuppress" ] = {
	name = "Пси-подавление",
	desc = "Психические эффекты подавляются.",
	func = function( player, parameter)
		
	end,
	onbuffed = function( player, parameter )
		player:SetNWBool("ix_psysuppressed", true)
	end,
	ondebuffed = function( player, parameter )
		player:SetNWBool("ix_psysuppressed", false)
	end,
}

PLUGIN.buffs[ "buff_psyblock" ] = {
	name = "Псиблок",
	desc = "Вы защищены от психических атак.",
	func = function( player, parameter)
		
	end,
	onbuffed = function( player, parameter )
		player:SetNWFloat("ix_psyblock", player:GetNWFloat("ix_psyblock",0) + parameter.amount )
	end,
	ondebuffed = function( player, parameter )
		player:SetNWFloat("ix_psyblock", player:GetNWFloat("ix_psyblock",0) - parameter.amount )
	end,
}

PLUGIN.buffs[ "debuff_radiation" ] = {
	name = "Радиация",
	desc = "Вы становитесь радиоактивным.",
	func = function( player, parameter)
		player.timeNextTickRad = player.timeNextTickRad or CurTime()
		if player.timeNextTickRad < CurTime() then
			player:addRadiation(parameter.amount)

			player.timeNextTickRad = CurTime() + 0.5
		end
	end,
}

PLUGIN.buffs[ "debuff_psy" ] = {
	name = "Экстрасенс", -- Psychic
	desc = "Ты становишься менее разумным.",
	func = function( player, parameter)
		player.timeNextTickPsyDmg = player.timeNextTickPsyDmg or CurTime()
		if player.timeNextTickPsyDmg < CurTime() then
			player:DamagePsyHealth(parameter.amount)

			player.timeNextTickPsyDmg = CurTime() + 0.5
		end
	end,
}

/*
PLUGIN.buffs[ "leghurt" ] = {
	name = "Leg Injury",
	desc = "Your legs are injured and your movement has been handicapped.",
	onbuffed = function( player, parameter )
		if !player:HasBuff( "leghurt" ) then
			player:ChatPrint( nut.lang.Get("buff_legs_injured") )
		end
	end,
	ondebuffed = function( player, parameter )
		if !player:Alive() then return end
		if player:HasBuff( "leghurt" ) then
			player:ChatPrint( nut.lang.Get("buff_legs_restored") )
		end
	end,
	func = function( player, parameter)
		player.timeNextMoan = player.timeNextMoan or CurTime()
		if player.timeNextMoan < CurTime() then
			local gender = player.character:GetVar( "gender" )
			player:EmitSound( Format( "vo/npc/%s01/pain0%d.wav", gender, math.random( 1, 9 ) ) )
			player.timeNextMoan = CurTime() + 5
			player:ScreenFadeOut(.5, Color(255, 50, 50, 50))
		end
	end,
}
*/

PLUGIN.buffs[ "buff_hijump" ] = {
	name = "Высокий прыжок",
	desc = "Вы можете прыгать высоко.",
	func = function( player, parameter)
		
	end,
	onbuffed = function( player, parameter )
		local jumpval = player:GetJumpPower()
		player:SetJumpPower(jumpval + parameter.amount)
	end,
	ondebuffed = function( player, parameter )
		local jumpval = player:GetJumpPower()
		player:SetJumpPower(jumpval - parameter.amount)
	end,
}