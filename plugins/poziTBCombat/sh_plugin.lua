PLUGIN.name = "Пошаговая боевая система"
PLUGIN.author = "SHOOTER#5269, POZITRON#2407"
PLUGIN.description = "Реализует пошаговую боевую систему, которая работает для PvE, PvP, PvPvE"

--[[
Known Bugs (Известные ошибки):

- The plugin will not work on singleplayer. I have no clue why It just don't. (Плагин не будет работать в одиночной игре. Я понятия не имею, почему это просто не так.)
- The server may spit out nul values when players are flip flopping between turns. The combat works normally but it's still going to spit it out. (Сервер может выдавать нулевые значения, когда игроки переворачиваются между ходами. Бой работает нормально но все равно выплюнет.)
- Some NPC won't freeze properly and will continue to attack even when frozen (Некоторые NPC не зависают должным образом и продолжают атаковать даже будучи замороженными.)
- Projectile based weapons can not initiate ranged combat (Оружие на основе снарядов не может инициировать дальний бой.)
- Granades will still explode. (I'd love to have them join the turn order but for some reason they aren't counted as true NPCs) (Гранаты все равно будут взрываться. (Я бы хотел, чтобы они присоединились к порядку хода, но по какой-то причине они не считаются настоящими NPC))

Notes (Заметки): 

- If I get more freetime/plan on reworking this plugin undo the massive think hook, people will dislike my use of it. i'm aware think hooks have a massive hit to preformance. (Если у меня будет больше свободного времени/план по доработке этого плагина, который избавит меня от массивного мыслительного крючка, людям не понравится, что я его использую. Я знаю, что хуки сильно ударили по производительности.)
--]]


ix.config.Add("ВКЛ/ВЫКЛ", true, "Пошаговый бой включен глобально или нет", nil, {
	category = "Пошаговая боевая система"
})

ix.config.Add("Радиус", 1000, "Радиус, в котором другие NPC/игроки присоединятся к боевому столкновению..", nil, {
	data = { min = 100, max = 2000 },
	category = "Пошаговая боевая система"
})

ix.config.Add("movementradius", 30, "Как далеко игрок может пройти от начальной точки своего хода, прежде чем потеряет AP. Это действует как множитель расстояния.", nil, {
	data = { min = 10, max = 2000 },
	category = "Пошаговая боевая система"
})

ix.config.Add("warmuptimer", 5, "Количество времени до фактического начала боя.", nil, {
	data = { min = 1, max = 60 },
	category = "Пошаговая боевая система"
})

ix.config.Add("playeractionpoints", 3, "Количество действий, которые игрок может совершить за один ход", nil, {
	data = { min = 1, max = 100 },
	category = "Пошаговая боевая система"
})

ix.config.Add("playertimeammount", 10, "Количество времени, которое есть у игрока до того, как он поднимется.", nil, {
	data = { min = 1, max = 60 },
	category = "Пошаговая боевая система"
})

ix.config.Add("npctimeammount", 5, "Количество времени, в течение которого NPC находится в бою.", nil, {
	data = { min = 1, max = 60 },
	category = "Пошаговая боевая система"
})


PLUGIN.TotalCombats = PLUGIN.TotalCombats or {  }

PLUGIN.Data = {  }

PLUGIN.IgnoredNPCs = { -- NPC, с которыми вы не вступаете в пошаговый бой, большинство летающих NPC должны быть добавлены, потому что они не любят замирать, когда не активен ход.
	['npc_turret_floor'] = true,
	['npc_rollermine'] = true,
	['npc_manhack'] = true,
	['npc_clawscanner'] = true,
	['npc_cscanner'] = true,
	['npc_crow'] = true,
	['npc_pigeon'] = true,
	['npc_seagull'] = true,
	['npc_grenade_frag'] = true,
	['npc_combine_camera'] = true,
	['npc_stalker'] = true,
	['npc_helicopter'] = true,
	['worldspawn'] = true,
	['env_fire'] = true,
}

function PLUGIN:StartCommand( ply, cmd )
	if ply:GetNWBool( "IsInCombat", false ) then
		if ply:GetNWBool( "WarmUp", false) or !ply:GetNWBool( "MyTurn", false) then
			cmd:ClearMovement() 
			cmd:ClearButtons()
		end
	end
end

if (SERVER) then
	function PLUGIN:ResetCombatStatus(client)
		timer.Simple( 0.1, function()
			client:SetNWBool( "WarmUpBegin", false )
			client:SetNWBool( "MyTurn", false )
			client:SetNWBool( "IsInCombat", false )
			client:SetNWBool( "WarmUp", false)
			client:SetNWFloat( "Timeramount", 0 )
			client:SetNWBool("TryingToLeave", false)
			client:SetNWBool("PlayerTurnCheck", false)
			client:SetNWBool("TryingToLeave", false)			
		end)
	end
	
	function PLUGIN:PlayerSpawn(client)
		if !table.IsEmpty(self.TotalCombats) then 
			for k, v in pairs(self.TotalCombats) do
				for k2, v2 in pairs(v) do
					if IsEntity( v2 ) then
						if IsValid( v2 ) then
							if v2 == client then
								table.remove( v, k2 )
								table.insert( v, k2 , NULL  )
							end
						end
					end
				end
			end
		end
		self:ResetCombatStatus(client)
	end

	function PLUGIN:PlayerDeath(client)
		if !table.IsEmpty(self.TotalCombats) then 
			for k, v in pairs(self.TotalCombats) do
				for k2, v2 in pairs(v) do
					if IsEntity( v2 ) then
						if IsValid( v2 ) then
							if v2 == client then
								table.remove( v, k2 )
								table.insert( v, k2 , NULL )
							end
						end
					end
				end
			end
		end
		self:ResetCombatStatus(client)
	end

	function PLUGIN:EntityTakeDamage( target, dmg ) -- чтобы это работало лучше, IE игнорирует NPC, которые находятся в списке игнорирования
		target:SetNWBool("TryingToLeave", false)
		if ix.config.Get("Turn Based Combat On/Off", true) then
			if (self.IgnoredNPCs[dmg:GetInflictor():GetClass( )] == nil) == (self.IgnoredNPCs[target:GetClass( )] == nil) then
				-- добавляет NPC/игрока в бой, если они стреляют в игрока/игрока, уже участвующего в этом бою
				if !dmg:GetInflictor():GetNWBool( "IsInCombat", false ) then
					if !table.IsEmpty(self.TotalCombats) then
						for k, v in pairs(self.TotalCombats) do
							for k2, v2 in pairs(v) do
								if target == v2 then
									if dmg:GetInflictor():GetClass() == "player" and dmg:GetInflictor():Alive() then
										dmg:GetInflictor():SetNWBool( "WarmUpBegin", true )
										--ent:SetMaterial("models/shiny") -- просто для тестирования
										dmg:GetInflictor():SetNWBool( "WarmUp", true) 
										dmg:GetInflictor().btimer = false
										table.insert( v, #v, dmg:GetInflictor() )
										if v[1] == "Combat" then
											dmg:GetInflictor():SetNWBool( "WarmUpBegin", false )
										end
										dmg:GetInflictor():SetNWBool( "IsInCombat", true )
										break
									elseif dmg:GetInflictor():IsNPC() then
										--dmg:GetInflictor():SetMaterial("models/shiny") -- просто для тестирования
										dmg:GetInflictor():SetNWBool( "WarmUp", true)
										dmg:GetInflictor():SetNWBool("MyTurn", false)
										table.insert( v, #v, dmg:GetInflictor() )
										dmg:GetInflictor():GetNWBool("MyTurn", false)
										dmg:GetInflictor():SetNWBool( "IsInCombat", true )
										break
									end
								end
							end
						end
					end
				end
				
				-- предотвращает получение урона, если игрок не в бою
				if !dmg:GetInflictor():GetNWBool( "IsInCombat", false ) and (dmg:GetInflictor():IsNPC() or dmg:GetInflictor():GetClass() == "player") then
					dmg:SetDamage( 0 )
				end

				if !target:GetNWBool( "IsInCombat", false ) then
					if !(target:IsNPC() and dmg:GetInflictor():IsNPC()) then
						if target:GetClass() == "player" or target:IsNPC() then
							for k, v in pairs(ents.GetAll()) do
								if v:GetClass() == "player" or v:IsNPC() and self.IgnoredNPCs[v:GetClass( )] == nil then
									timer.Simple( 0.01, function()
										local trace = util.TraceLine{
											start = target:EyePos(),
											endpos = v:EyePos(),
											mask  = MASK_SOLID_BRUSHONLY,
										}
										if !trace.Hit then
											if target:EyePos():Distance( v:EyePos() ) <= ix.config.Get("radius", 500) then
												self:BeginWarmUp( v )
											end
										end
									end)
								end
							end
						end
					end
				elseif target:GetNWBool( "IsInCombat", false ) and !dmg:GetInflictor():GetNWBool( "IsInCombat", false ) then
					self:AutoJoinCombat( dmg:GetInflictor() )
				end
			end
		end
	end
	
	function PLUGIN:BeginWarmUp( entity )
		self.Data[1] = "WarmUp" -- current state (Текущее состояние)
		self.Data[2] = ix.config.Get("warmuptimer", 5) + CurTime() -- timer for warmup, and turns (таймер для прогрева и поворотов)
		self.Data[3] = 0 -- player counter
		self.Data[4] = 0 -- NPC counter
		self.Data[5] = 6 -- turn pointer
		if entity:GetClass() == "player" then
			entity:SetNWBool( "IsInCombat", true )
			entity:SetNWBool( "WarmUpBegin", true )
			--entity:SetMaterial("models/shiny") -- just for testing
			entity:SetNWBool( "WarmUp", true) 
			table.insert( self.Data, entity )
		elseif entity:IsNPC() then
			entity:SetNWBool( "IsInCombat", true )
			--entity:SetMaterial("models/shiny") -- just for testing
			entity:SetNWBool( "WarmUp", true)
			entity:SetNWBool("MyTurn", false)
			table.insert( self.Data, entity )
		end
	end
	
	function PLUGIN:AutoJoinCombat( ent )
		if ix.config.Get("Turn Based Combat On/Off", true) then
			if !ent:GetNWBool( "IsInCombat", false ) then
				if self.IgnoredNPCs[ent:GetClass()] == nil then
					if IsValid( ent ) then
						timer.Simple( 0.01, function()
							if !table.IsEmpty(self.TotalCombats) then -- just for server starts
								for k, v in pairs(self.TotalCombats) do 
									for k2, v2 in pairs(v) do
										if IsEntity( v2 ) then
											if IsValid( v2 ) then
												local trace = util.TraceLine{
													start = ent:EyePos(),
													endpos = v2:EyePos(),
													mask  = MASK_SOLID_BRUSHONLY,
												}
												if !trace.Hit then
													if ent:EyePos():Distance( v2:EyePos() ) <= ix.config.Get("radius", 500) then
														if ent:GetClass() == "player" and ent:Alive() then
															ent:SetNWBool( "WarmUpBegin", true )
															--ent:SetMaterial("models/shiny") -- just for testing
															ent:SetNWBool( "WarmUp", true) 
															ent.btimer = false
															table.insert( v, #v, ent )
															if v[1] == "Combat" then
																ent:SetNWBool( "WarmUpBegin", false )
															end
															ent:SetNWBool( "IsInCombat", true )
															break
														elseif ent:IsNPC() then
															--ent:SetMaterial("models/shiny") -- just for testing
															ent:SetNWBool( "WarmUp", true)
															ent:SetNWBool("MyTurn", false)
															table.insert( v, #v, ent )
															ent:GetNWBool("MyTurn", false)
															ent:SetNWBool( "IsInCombat", true )
															break
														end
													end
												end
											end
										end
									end
								end
							end
						end)
					end
				end
			end
		end
	end
	
	function PLUGIN:PlayerTick( player, mv )
		self:AutoJoinCombat( player )
	end
	
	function PLUGIN:OnEntityCreated( entity )
		if entity:IsNPC() then
			self:AutoJoinCombat( entity )
		end
	end

	function PLUGIN:Think()
		timer.Simple( 0.01, function()
			for k, v in pairs(ents.GetAll()) do
				if v:IsNPC() then 
					if v:IsMoving() then
						self:AutoJoinCombat( v )
					end
				end
			end
			-- Multidimential table setup
			if !table.IsEmpty(self.Data) then -- A TON OF BULLSHIT JUST TO GET MULTIDIMENTIONAL TABLES TO BE CREATED
				local NewTable = {}
				for i, v in pairs( self.Data ) do
					NewTable[ #NewTable + 1 ] = v
				end
				table.Empty(self.Data)
				self.TotalCombats[ #self.TotalCombats + 1 ] = NewTable
			end

			-- A work around for players getting bugged into constantly being in combat
			if table.IsEmpty(self.TotalCombats) then 
				for k, v in pairs(player.GetAll()) do
					self:ResetCombatStatus(v)
				end
			end

			if !table.IsEmpty(self.TotalCombats) then -- just for server starts
				if ix.config.Get("Turn Based Combat On/Off", true) then
					for k, v in pairs(self.TotalCombats) do -- Goes through the every single combat encounter table
						-- Warmup Timer
						if v[1] == "WarmUp" then
							if v[2] < CurTime() then
								v[1] = "Combat"
								v[#v + 1] = "."
								self:BeginCombat( v )
							end
						end
						
						
						-- Player and NPC counter
						v[3] = 0
						v[4] = 0
						for k2, v2 in pairs(v) do
							if IsEntity( v2 ) then
								if IsValid( v2 ) then
									if IsEntity( v2 ) then
										if v2:GetClass() == "player" then
											v[3] = v[3] + 1
											v2:SetNWFloat("Timeramount", v[2])
										elseif v2:IsNPC() then
											v[4] = v[4] + 1
										end
									end
								end
							end
						end
						for k2, v2 in pairs(v) do
							if IsEntity( v2 ) then
								if IsValid( v2 ) then
									if v2:GetClass() == "player" then
										v2:SetNWInt("CombatNPCCount", v[4])
										v2:SetNWInt("CombatPlayerCount", v[3])
									else
										if !v2:GetNWBool("MyTurn", false) then -- freeze NPCs
											v2:SetCondition( 67 )
										else -- unfreeze NPCs
											v2:SetCondition( 68 )
										end
									end
								--else
								--	table.remove( v, k2 )
								end
							end
						end
						
						-- Remove dups
						timer.Simple( 0.1, function()
							for k2, v2 in pairs(v) do
								for k3, v3 in pairs(v) do
									if v2 == v3 and !(k2 == k3) and IsEntity( v2 ) and IsEntity( v3 ) then
										table.remove( v, k3 )
									end
								end
							end
						end)
						
						-- the end condition/table remover
						timer.Simple( 0.1, function()
							if ((v[4] == 0 and v[3] <= 1) or (v[4] >= 0 and v[3] == 0)) or v[1] == "End Combat" then
								for k2, v2 in pairs(v) do
									if IsEntity( v2 ) then
										if IsValid( v2 ) then
											if v2:GetClass() == "player" then
												self:ResetCombatStatus(v2)
											else
												timer.Simple( 1, function()
													v2:SetCondition( 68 )
													v2:SetNWBool( "IsInCombat", false )
													--v2:SetMaterial("") -- just for testing
													v2:SetNWBool( "MyTurn", true )
													v2:SetNWBool( "WarmUp", false)
												end)
											end
										end
									end
								end
								table.remove( self.TotalCombats, k )
							end	
						end)

						-- Пошаговый бой
						if v[1] == "Combat" then
							if IsEntity(v[v[5]]) and IsValid( v[v[5]] ) then
								if v[v[5]]:GetClass() == "player" then
									-- the code that allows the player to do their turn
									
									-- at the start of the players turn ran once
									if v[2] - ix.config.Get("playertimeammount", 10) + 0.1 >= CurTime() then 
										v[v[5]]:SetNWInt("AP", ix.config.Get("playeractionpoints", 3))
										v[v[5]]:SetNWVector( "StartPos", v[v[5]]:GetPos() )
										v[v[5]]:SetNWFloat("TurnTimer", v[2])
										
										-- Проверяет, пытался ли игрок покинуть это место в прошлом ходу, и проверяет, хотят ли все игроки в бою завершить бой
										if v[v[5]]:GetNWBool("PlayerTurnCheck", true) and v[v[5]]:GetNWBool("TryingToLeave", false) then 
											for k2, v2 in pairs(v) do
												if IsEntity( v2 ) and v2:IsPlayer() then
													if v2:GetNWBool("TryingToLeave", false) then
														v[1] = "End Combat"
													else
														v[1] = "Combat"
														break
													end
												end 
											end
										else 
											v[v[5]]:SetNWBool("PlayerTurnCheck", false)	
										end	
									end
									
									-- The lose of AP when the player moves
									if v[v[5]]:GetNWVector( "StartPos", v[v[5]]:GetPos() ):Distance( v[v[5]]:GetPos() ) > ix.config.Get("movementradius", 10) * v[v[5]]:GetNWInt("AP", ix.config.Get("playeractionpoints", 3)) then
										local trace = util.TraceLine( {
											start = v[v[5]]:GetPos()+Vector(0,0,30),
											endpos = v[v[5]]:GetPos()-Vector(0,0,10000),
											filter = v[v[5]]
										})
										
										v[v[5]]:SetNWVector( "StartPos", trace.HitPos )
										v[v[5]]:SetNWInt("AP", v[v[5]]:GetNWInt("AP", 3) - 1)
									end
									
									-- пропустить свою очередь с прогулкой
									if v[v[5]]:KeyPressed( IN_WALK ) and IsValid(v[v[5]]) and v[v[5]]:Alive() and IsValid(v[v[5]]:GetActiveWeapon()) then
										-- если игрок использует AP, а затем пропускает, это не считается попыткой уйти
										if v[v[5]]:GetNWInt("AP", 3) == ix.config.Get("playeractionpoints", 3) then
											v[v[5]]:SetNWBool("TryingToLeave", true)
										end 
										v[v[5]]:SetNWInt("AP", 0)
									end
									
									-- если игрок стреляет/удерживает триггер, он теряет AP каждую секунду (время между выстрелами)
									if v[v[5]]:KeyPressed( IN_ATTACK ) then
										v[v[5]]:SetNWInt("AP", v[v[5]]:GetNWInt("AP", 3) - 1)
										v[v[5]]:SetNWFloat("TimeBetweenShots", CurTime() + 0.4)
									end
									
									if v[v[5]]:KeyDown( IN_ATTACK ) and IsValid(v[v[5]]) and v[v[5]]:Alive() and IsValid(v[v[5]]:GetActiveWeapon()) then
										timer.Simple( 0.01, function()
											if v[v[5]]:GetNWFloat("TimeBetweenShots", 0) <= CurTime() then
												v[v[5]]:SetNWInt("AP", v[v[5]]:GetNWInt("AP", 3) - 1)
												v[v[5]]:SetNWFloat("TimeBetweenShots", CurTime() + 0.4)
											end
										end)
									end
									

									--ran constantly in the turn
									--timer.Simple( 0.11, function()
										v[v[5]]:SetNWBool( "MyTurn", true )
										v[v[5]]:SetNWBool( "WarmUp", false )
									--end)	
									
									-- ran at the end of the players turn
									if v[2] < CurTime() or v[v[5]]:GetNWInt("AP", 0) <= 0 then -- The timer to count how long the player has till their turn is up
										if v[v[5]]:GetNWInt("AP", 0) == ix.config.Get("playeractionpoints", 3) then
											v[v[5]]:SetNWBool("TryingToLeave", true)
										end

										if IsValid(v[v[5] + 1]) then
											if v[v[5] + 1]:IsNPC() then
												v[2] = ix.config.Get("npctimeammount", 5) + CurTime()
											else
												v[2] = ix.config.Get("playertimeammount", 10) + CurTime()
											end
										else
											if v[6]:IsNPC() and IsValid(v[6]) then
												v[2] = ix.config.Get("npctimeammount", 5) + CurTime()
											else
												v[2] = ix.config.Get("playertimeammount", 10) + CurTime()
											end
										end
										if v[v[5]]:GetNWBool("TryingToLeave", false) then
											v[v[5]]:SetNWBool("PlayerTurnCheck", true)
										end	
										v[v[5]]:SetNWBool( "MyTurn", false )
										v[5] = v[5] + 1
									end
								elseif v[v[5]]:IsNPC() then
									-- the code that allows the NPC to do their turn
									
									v[v[5]]:SetNWBool( "MyTurn", true )
									
									
									if v[2] < CurTime() then -- The timer to count how long the NPC has till their turn is up
										if IsValid(v[v[5] + 1]) then
											if v[v[5] + 1]:IsNPC() then
												v[2] = ix.config.Get("npctimeammount", 5) + CurTime()
											else
												v[2] = ix.config.Get("playertimeammount", 10) + CurTime()
											end
										else
											if v[6]:IsNPC() and IsValid(v[6]) then
												v[2] = ix.config.Get("npctimeammount", 5) + CurTime()
											else
												v[2] = ix.config.Get("playertimeammount", 10) + CurTime()
											end
										end
										v[v[5]]:SetNWBool( "MyTurn", false )
										v[5] = v[5] + 1
									end
								end
							elseif !IsEntity(v[v[5]]) then
								v[5] = 6
							else
								if IsValid(v[v[5] + 1]) then
									if v[v[5] + 1]:IsNPC() then
										v[2] = ix.config.Get("npctimeammount", 5) + CurTime()
									else
										v[2] = ix.config.Get("playertimeammount", 10) + CurTime()
									end
								end
								v[5] = v[5] + 1
							end
						end
					end
				end
			end
		end)
	end
	
	
	
	function PLUGIN:BeginCombat( tab )
		for k, v in pairs(tab) do
			if IsEntity( v ) then
				if IsValid( v ) and v:GetClass() == "player" then
					v:SetNWBool( "WarmUpBegin", false )
				end
			end
		end
		tab[2] = ix.config.Get("playertimeammount", 10) + CurTime()
	end
end

if (CLIENT) then
	local w, h = ScrW(), ScrH()
	surface.CreateFont( "TBCWarmUpFont", {
	font = "Arial",
	extended = false,
	size = 20 * h/500,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
	} )

	local w, h = ScrW(), ScrH()
	surface.CreateFont( "arial_pozi_27", {
	font = "Patsy Sans Italic",
	extended = false,
	size = 27 * h/500,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
	} )
	
	local w, h = ScrW(), ScrH()
	surface.CreateFont( "TBCSmallFont", {
	font = "Arial",
	extended = false,
	size = 14 * h/500,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
	} )
	
	local w, h = ScrW(), ScrH()
	surface.CreateFont( "TBCTinyFont", {
	font = "Arial",
	extended = false,
	size = 7 * h/500,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
	} )
	
	function PLUGIN:factorial(n)
		if (n <= 1) then
			return 1
		else
			return n + self:factorial(n - 1)
		end
	end
	
	function draw.Circle( x, y, radius, seg )
		local cir = {}

		table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
		for i = 0, seg do
			local a = math.rad( ( i / seg ) * -360 )
			table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
		end

		local a = math.rad( 0 ) -- This is needed for non absolute segment counts
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

		surface.DrawPoly( cir )
	end
	
	
	function PLUGIN:PostDrawOpaqueRenderables( )
		local ply = LocalPlayer()
		if ply:GetNWBool( "IsInCombat", false ) then
			if ply:GetNWBool( "MyTurn", false ) then
				local trace = util.TraceLine( {
					start = ply:GetPos()+Vector(0,0,30),
					endpos = ply:GetPos()-Vector(0,0,1000),
					filter = ply
				})
				
				cam.Start3D2D( ply:GetNWVector( "StartPos", ply:GetPos() ) + trace.HitNormal, trace.HitNormal:Angle() + Angle( 90, 0, 0 ), 1 )
					
					surface.SetDrawColor( 0, 0, 0, 200)
					draw.NoTexture()
					draw.Circle( 0, 0, ix.config.Get("movementradius", 10) * self:factorial(ply:GetNWInt("AP", ix.config.Get("playeractionpoints", 3), 50 )), 25)
					
				cam.End3D2D()
				
				cam.Start3D2D( ply:GetNWVector( "StartPos", ply:GetPos() ) + trace.HitNormal, trace.HitNormal:Angle() + Angle( 90, 0, 0 ), 1 )
				
					surface.SetDrawColor( 94, 180, 255, 255)
					draw.NoTexture()
					draw.Circle( 0, 0, ix.config.Get("movementradius", 10) * ply:GetNWInt("AP", ix.config.Get("playeractionpoints", 3)), 25 )
					
				cam.End3D2D()
				
				
			end
		else
			for k, v in pairs(ents.GetAll()) do
				if v:IsNPC() or v:GetClass() == "player" then 
					if v:GetNWBool( "IsInCombat", false ) then
						render.SetColorMaterial()
						render.DrawSphere( v:GetNWVector( "StartPos", v:EyePos() ), ix.config.Get("radius", 500), 50, 50,Color(0,0,0,100))
					end
				end
			end
		end
	end
	
	function PLUGIN:HUDPaint()
		local lclient = LocalPlayer()
		
		if lclient:GetNWBool( "IsInCombat", false ) then
			if lclient:GetNWBool( "WarmUpBegin", false ) then
				draw.SimpleText("БОЙ НАЧНЕТСЯ ЧЕРЕЗ: "..  math.Round(lclient:GetNWFloat("Timeramount", 0) - CurTime(), 1) .." СЕКУНД", "TBCSmallFont", w/2, h/5, Color(250, 50, 50, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
				
				draw.SimpleText("ПОДГОТОВКА", "arial_pozi_27", w/2, h/7, Color(250, 50, 50, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			    if lclient:GetNWBool( "MyTurn", false ) then
				    draw.SimpleText("ТВОЙ ХОД", "arial_pozi_27", w/2, h/7, Color(255, 165, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
				    draw.SimpleText("ОЧКОВ ДЕЙСТВИЙ: ".. lclient:GetNWInt("AP", 3), "TBCSmallFont", w/2, h/1.1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				    draw.SimpleText("ОСТАЛОСЬ ВРЕМЕНИ: "..  math.Round(lclient:GetNWFloat("TurnTimer", 0) - CurTime(), 1) .." СЕКУНД", "TBCSmallFont", w/2, h/5, Color(255, 165, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
		        elseif lclient:GetNWBool( "AP", 0) then
			        draw.SimpleText("ПЕРЕДАЧА ХОДА", "TBCSmallFont", w/2, h/4, Color(255, 165, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
			        --draw.SimpleText("Очки 1действий: ".. lclient:GetNWInt("AP", 3), "TBCSmallFont", w/2, h/1.25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			        --draw.SimpleText("Осталось 1времени: "..  math.Round(lclient:GetNWFloat("TurnTimer", 0) - CurTime(), 1) .." секунд", "TBCWarmUpFont", w/2, h/5, Color(255, 165, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
		        end

		    
			
			local walkBind = input.LookupBinding("+walk") or "ALT"
			draw.SimpleText("ИНСТРУКЦИЯ | Пропустить ход: " ..walkBind.. " | ЕСЛИ ВСЕ ИГРОКИ ПРОПУСТИЛИ СВОИ ХОДЫ, БОЙ ЗАКОНЧИТСЯ", "TBCTinyFont", w/2, h/1.02, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			draw.SimpleText("NPC: "..lclient:GetNWInt("CombatNPCCount", 0).." | Игроки: "..lclient:GetNWInt("CombatPlayerCount", 0).." |", "TBCSmallFont", w/2, h/1.05, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

