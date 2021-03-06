local S = technic.getter

local tube = {
	insert_object = function(pos, node, stack, direction)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:add_item("src", stack)
	end,
	can_insert = function(pos, node, stack, direction)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:room_for_item("src", stack)
	end,
	connect_sides = {left=1, right=1, back=1, top=1, bottom=1},
}

function generator_receive_fields(pos, formname, fields, sender)
	playername = sender:get_player_name()
	if not minetest.is_protected(pos, playername) then
		if ( fields.protected ) then
			local meta = minetest.get_meta(pos)
			local protected = meta:get_int("protected")
			local formspec = meta:get_string("raw_formspec")
			local label = nil
			if ( protected == nil or protected == 0 ) then
				protected = 1
				label = "Protected"
			else
				protected = 0
				label = "Not Protected"
			end	
			meta:set_string("formspec", string.format(formspec,"",label))
			meta:set_int("protected",protected)
		end
	end
end

function technic.register_generator(data) 
	local tier = data.tier
	local ltier = string.lower(tier)

	local groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2, technic_machine=1}
	local active_groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2, technic_machine=1, not_in_creative_inventory=1}
	if data.tube then
		groups.tubedevice = 1
		groups.tubedevice_receiver = 1
		active_groups.tubedevice = 1
		active_groups.tubedevice_receiver = 1
	end

	local generator_formspec =
		"invsize[8,9;]"..
		"label[0,0;"..S("Fuel-Fired %s Generator"):format(tier).."]"..
		"list[current_name;src;3,1;1,1;]"..
		"image[4,1;1,1;default_furnace_fire_bg.png%s]"..
		"list[current_player;main;0,5;8,4;]"..
		"button[4,0;.8,.8;protected;]"..
		"label[4.8,0; %s]"

	local desc = S("Fuel-Fired %s Generator"):format(tier)

	local run = function(pos, node)
		local meta = minetest.get_meta(pos)
		local burn_time = meta:get_int("burn_time")
		local burn_totaltime = meta:get_int("burn_totaltime")
		-- If more to burn and the energy produced was used: produce some more
		if burn_time > 0 then
			meta:set_int(tier.."_EU_supply", data.supply)
			burn_time = burn_time - 1
			meta:set_int("burn_time", burn_time)
		end
		-- Burn another piece of fuel
		if burn_time == 0 then
			local inv = meta:get_inventory()
			if not inv:is_empty("src") then 
				local fuellist = inv:get_list("src")
				local fuel
				local afterfuel
				fuel, afterfuel = minetest.get_craft_result(
						{method = "fuel", width = 1,
						items = fuellist})
				if not fuel or fuel.time == 0 then
					meta:set_string("infotext", S("%s Out Of Fuel"):format(desc))
					technic.swap_node(pos, "technic:"..ltier.."_generator")
					meta:set_int(tier.."_EU_supply", 0)
					return
				end
				meta:set_int("burn_time", fuel.time)
				meta:set_int("burn_totaltime", fuel.time)
				inv:set_stack("src", 1, afterfuel.items[1])
				technic.swap_node(pos, "technic:"..ltier.."_generator_active")
				meta:set_int(tier.."_EU_supply", data.supply)
			else
				technic.swap_node(pos, "technic:"..ltier.."_generator")
				meta:set_int(tier.."_EU_supply", 0)
			end
		end
		if burn_totaltime == 0 then burn_totaltime = 1 end
		local percent = math.floor((burn_time / burn_totaltime) * 100)
		local protected = meta:get_int("protected")
		local formspec = meta:get_string("raw_formspec")
		local label = nil
		if ( protected == nil or protected == 0 ) then
			label = "Not Protected"
		else
			label = "Protected"
		end	
		meta:set_string("infotext", desc.." ("..percent.."%)")
		meta:set_string("formspec", string.format(formspec,
			"^[lowpart:"..(percent)..":default_furnace_fire_fg.png]",
			label
			)
		)
	end
	
	minetest.register_node("technic:"..ltier.."_generator", {
		description = desc,
		tiles = {"technic_"..ltier.."_generator_top.png", "technic_machine_bottom.png",
		         "technic_"..ltier.."_generator_side.png", "technic_"..ltier.."_generator_side.png",
		         "technic_"..ltier.."_generator_side.png", "technic_"..ltier.."_generator_front.png"}, 
		paramtype2 = "facedir",
		groups = groups,
		legacy_facedir_simple = true,
		sounds = default.node_sound_wood_defaults(),
		tube = data.tube and tube or nil,
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext", desc)
			meta:set_int(data.tier.."_EU_supply", 0)
			meta:set_int("burn_time", 0)
			meta:set_int("tube_time",  0)
			meta:set_int("protected",  0)
			meta:set_string("raw_formspec", generator_formspec)
			meta:set_string("formspec", string.format(generator_formspec,"","Not Protected"))
			local inv = meta:get_inventory()
			inv:set_size("src", 1)
		end,
		on_receive_fields = generator_receive_fields,
		can_dig = technic.machine_can_dig,
		allow_metadata_inventory_put = technic.machine_inventory_put,
		allow_metadata_inventory_take = technic.machine_inventory_take,
		allow_metadata_inventory_move = technic.machine_inventory_move,
		technic_run = run,
		after_place_node = data.tube and pipeworks.after_place,
		after_dig_node = technic.machine_after_dig_node
	})

	minetest.register_node("technic:"..ltier.."_generator_active", {
		description = desc,
		tiles = {"technic_"..ltier.."_generator_top.png", "technic_machine_bottom.png",
		         "technic_"..ltier.."_generator_side.png", "technic_"..ltier.."_generator_side.png",
		         "technic_"..ltier.."_generator_side.png", "technic_"..ltier.."_generator_front_active.png"},
		paramtype2 = "facedir",
		groups = active_groups,
		legacy_facedir_simple = true,
		sounds = default.node_sound_wood_defaults(),
		tube = data.tube and tube or nil,
		drop = "technic:"..ltier.."_generator",
		on_receive_fields = generator_receive_fields,
		can_dig = technic.machine_can_dig,
		allow_metadata_inventory_put = technic.machine_inventory_put,
		allow_metadata_inventory_take = technic.machine_inventory_take,
		allow_metadata_inventory_move = technic.machine_inventory_move,
		technic_run = run,
		technic_on_disable = function(pos, node)
			local timer = minetest.get_node_timer(pos)
			timer:start(1)
		end,
		on_timer = function(pos, node)
			local meta = minetest.get_meta(pos)
			
			-- Connected back?
			if meta:get_int(tier.."_EU_timeout") > 0 then return false end
			
			local burn_time = meta:get_int("burn_time") or 0

			if burn_time <= 0 then
				meta:set_int(tier.."_EU_supply", 0)
				meta:set_int("burn_time", 0)
				technic.swap_node(pos, "technic:"..ltier.."_generator")
				return false
			end

			local burn_totaltime = meta:get_int("burn_totaltime") or 0
			if burn_totaltime == 0 then burn_totaltime = 1 end
			burn_time = burn_time - 1
			meta:set_int("burn_time", burn_time)
			local percent = math.floor(burn_time / burn_totaltime * 100)
			local protected = meta:get_int("protected")
			local formspec = meta:get_string("raw_formspec")
			local label = nil
			if ( protected == nil or protected == 0 ) then
				label = "Not Protected"
			else
				label = "Protected"
			end	
			meta:set_string("formspec", string.format(formspec,
				"^[lowpart:"..(percent)..":default_furnace_fire_fg.png]",
				label
				)
			)
			return true
		end,
	})

	technic.register_machine(tier, "technic:"..ltier.."_generator",        technic.producer)
	technic.register_machine(tier, "technic:"..ltier.."_generator_active", technic.producer)
end

