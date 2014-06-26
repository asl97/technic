-- Configuration
local chainsaw_max_charge      = 30000 -- 30000 - Maximum charge of the saw
local chainsaw_charge_per_node = 12    -- 12    - Gives 2500 nodes on a single charge (about 50 complete normal trees)
local chainsaw_leaves          = true  -- true  - Cut down entire trees, leaves and all

-- The default stuff
local timber_nodenames={["default:jungletree"] = true,
                        ["default:papyrus"]    = true,
                        ["default:cactus"]     = true,
                        ["default:tree"]       = true,
                        ["default:apple"]      = true
}

if chainsaw_leaves == true then
    timber_nodenames["default:leaves"] = true
    timber_nodenames["default:jungleleaves"] = true
end

-- technic_worldgen defines rubber trees if moretrees isn't installed
if minetest.get_modpath("technic_worldgen") or
    minetest.get_modpath("moretrees") then
    timber_nodenames["moretrees:rubber_tree_trunk_empty"] = true
    timber_nodenames["moretrees:rubber_tree_trunk"]       = true
    if chainsaw_leaves then
        timber_nodenames["moretrees:rubber_tree_leaves"] = true
    end
end

-- Support moretrees if it is there
if( minetest.get_modpath("moretrees") ~= nil ) then
    timber_nodenames["moretrees:apple_tree_trunk"]                 = true
    timber_nodenames["moretrees:apple_tree_trunk_sideways"]        = true
    timber_nodenames["moretrees:beech_trunk"]                      = true
    timber_nodenames["moretrees:beech_trunk_sideways"]             = true
    timber_nodenames["moretrees:birch_trunk"]                      = true
    timber_nodenames["moretrees:birch_trunk_sideways"]             = true
    timber_nodenames["moretrees:fir_trunk"]                        = true
    timber_nodenames["moretrees:fir_trunk_sideways"]               = true
    timber_nodenames["moretrees:oak_trunk"]                        = true
    timber_nodenames["moretrees:oak_trunk_sideways"]               = true
    timber_nodenames["moretrees:palm_trunk"]                       = true
    timber_nodenames["moretrees:palm_trunk_sideways"]              = true
    timber_nodenames["moretrees:pine_trunk"]                       = true
    timber_nodenames["moretrees:pine_trunk_sideways"]              = true
    timber_nodenames["moretrees:rubber_tree_trunk_sideways"]       = true
    timber_nodenames["moretrees:rubber_tree_trunk_sideways_empty"] = true
    timber_nodenames["moretrees:sequoia_trunk"]                    = true
    timber_nodenames["moretrees:sequoia_trunk_sideways"]           = true
    timber_nodenames["moretrees:spruce_trunk"]                     = true
    timber_nodenames["moretrees:spruce_trunk_sideways"]            = true
    timber_nodenames["moretrees:willow_trunk"]                     = true
    timber_nodenames["moretrees:willow_trunk_sideways"]            = true
    timber_nodenames["moretrees:jungletree_trunk"]                 = true
    timber_nodenames["moretrees:jungletree_trunk_sideways"]        = true

    if chainsaw_leaves then
        timber_nodenames["moretrees:apple_tree_leaves"]        = true
        timber_nodenames["moretrees:oak_leaves"]               = true
        timber_nodenames["moretrees:fir_leaves"]               = true
        timber_nodenames["moretrees:fir_leaves_bright"]        = true
        timber_nodenames["moretrees:sequoia_leaves"]           = true
        timber_nodenames["moretrees:birch_leaves"]             = true
        timber_nodenames["moretrees:birch_leaves"]             = true
        timber_nodenames["moretrees:palm_leaves"]              = true
        timber_nodenames["moretrees:spruce_leaves"]            = true
        timber_nodenames["moretrees:spruce_leaves"]            = true
        timber_nodenames["moretrees:pine_leaves"]              = true
        timber_nodenames["moretrees:willow_leaves"]            = true
        timber_nodenames["moretrees:jungletree_leaves_green"]  = true
        timber_nodenames["moretrees:jungletree_leaves_yellow"] = true
        timber_nodenames["moretrees:jungletree_leaves_red"]    = true
    end
end

-- Support growing_trees if it is there
if( minetest.get_modpath("growing_trees") ~= nil ) then
    timber_nodenames["growing_trees:trunk"]         = true
    timber_nodenames["growing_trees:medium_trunk"]  = true
    timber_nodenames["growing_trees:big_trunk"]     = true
    timber_nodenames["growing_trees:trunk_top"]     = true
    timber_nodenames["growing_trees:trunk_sprout"]  = true
    timber_nodenames["growing_trees:branch_sprout"] = true
    timber_nodenames["growing_trees:branch"]        = true
    timber_nodenames["growing_trees:branch_xmzm"]   = true
    timber_nodenames["growing_trees:branch_xpzm"]   = true
    timber_nodenames["growing_trees:branch_xmzp"]   = true
    timber_nodenames["growing_trees:branch_xpzp"]   = true
    timber_nodenames["growing_trees:branch_zz"]     = true
    timber_nodenames["growing_trees:branch_xx"]     = true

    if chainsaw_leaves == true then
        timber_nodenames["growing_trees:leaves"] = true
    end
end

-- Support growing_cactus if it is there
if( minetest.get_modpath("growing_cactus") ~= nil ) then
    timber_nodenames["growing_cactus:sprout"]                       = true
    timber_nodenames["growing_cactus:branch_sprout_vertical"]       = true
    timber_nodenames["growing_cactus:branch_sprout_vertical_fixed"] = true
    timber_nodenames["growing_cactus:branch_sprout_xp"]             = true
    timber_nodenames["growing_cactus:branch_sprout_xm"]             = true
    timber_nodenames["growing_cactus:branch_sprout_zp"]             = true
    timber_nodenames["growing_cactus:branch_sprout_zm"]             = true
    timber_nodenames["growing_cactus:trunk"]                        = true
    timber_nodenames["growing_cactus:branch_trunk"]                 = true
    timber_nodenames["growing_cactus:branch"]                       = true
    timber_nodenames["growing_cactus:branch_xp"]                    = true
    timber_nodenames["growing_cactus:branch_xm"]                    = true
    timber_nodenames["growing_cactus:branch_zp"]                    = true
    timber_nodenames["growing_cactus:branch_zm"]                    = true
    timber_nodenames["growing_cactus:branch_zz"]                    = true
    timber_nodenames["growing_cactus:branch_xx"]                    = true
end

-- Support farming_plus if it is there
if( minetest.get_modpath("farming_plus") ~= nil ) then
    if chainsaw_leaves == true then
        timber_nodenames["farming_plus:cocoa_leaves"] = true
    end
end


local S = technic.getter

technic.register_power_tool("technic:chainsaw", chainsaw_max_charge)

local function chainsaw_nodeupdate(np_list)
    local np_node, p, n
    for _, np_node in pairs(np_list) do
        p = np_node[1]
        n = np_node[2]
        if minetest.get_item_group(n.name, "falling_node") ~= 0 then
            p_bottom = {x=p.x, y=p.y-1, z=p.z}
            n_bottom = minetest.get_node(p_bottom)
            -- Note: walkable is in the node definition, not in item groups
            if minetest.registered_nodes[n_bottom.name] and
                    (minetest.get_item_group(n.name, "float") == 0 or
                        minetest.registered_nodes[n_bottom.name].liquidtype == "none") and
                    (n.name ~= n_bottom.name or (minetest.registered_nodes[n_bottom.name].leveled and
                        minetest.get_node_level(p_bottom) < minetest.get_node_max_level(p_bottom))) and
                    (not minetest.registered_nodes[n_bottom.name].walkable or
                        minetest.registered_nodes[n_bottom.name].buildable_to) then
                if delay then
                    minetest.after(0.1, nodeupdate_single, {x=p.x, y=p.y, z=p.z}, false)
                else
                    n.level = minetest.get_node_level(p)
                    minetest.remove_node(p)
                    spawn_falling_node(p, n)
                    nodeupdate(p)
                end
            end
        end

        if minetest.get_item_group(n.name, "attached_node") ~= 0 then
            if not check_attached_node(p, n) then
                drop_attached_node(p)
                nodeupdate(p)
            end
        end
    end
end

-- This function does all the hard work. Recursively we dig the node at hand
-- if it is in the table and then search the surroundings for more stuff to dig.
local function get_recursive_dig_function(pos, remaining_charge, player)
    local node=minetest.get_node(pos)
    local pos=pos
    local remaining_charge = remaining_charge
    local player = player
    local produced_item = {}
    local pos_list = {}
    local itemstack = nil
    local name = nil
    local number = nil
    -- Lookup node name in timber table:
    if timber_nodenames[node.name] then
        node_drops = minetest.get_node_drops(node.name)
        for _, itemstack in ipairs(node_drops) do
            get_name_and_number = itemstack:gmatch("%S+")
            name = get_name_and_number()
            number = get_name_and_number()
            if number then
                produced_item[name] = tonumber(number)
            else
                produced_item[name] = 1
            end
        end
        return function()
            local function recursive_dig(pos, remaining_charge)
                -- Return if we are out of power
                if remaining_charge < chainsaw_charge_per_node then
                    return 0
                end

                -- wood found - remove it instead of dig cause dig is slow cause it has lots of callback hooks
                -- we will handle the drop below inline for more speed
                minetest.remove_node(pos)

                remaining_charge=remaining_charge-chainsaw_charge_per_node
                -- check surroundings and run recursively if any charge left

                local nplist = {
                    {x=pos.x+1, y=pos.y, z=pos.z},
                    {x=pos.x+1, y=pos.y, z=pos.z+1},
                    {x=pos.x+1, y=pos.y, z=pos.z-1},
                    {x=pos.x-1, y=pos.y, z=pos.z},
                    {x=pos.x-1, y=pos.y, z=pos.z+1},
                    {x=pos.x-1, y=pos.y, z=pos.z-1},
                    {x=pos.x, y=pos.y, z=pos.z+1},
                    {x=pos.x, y=pos.y, z=pos.z-1},
                    {x=pos.x, y=pos.y+1, z=pos.z}
                }

                for _, np in ipairs(nplist) do
                    -- only check new pos
                    if not pos_list[dump(np)] then
                        local node = minetest.get_node(np)
                        pos_list[dump(np)] = {np,node}
                        if timber_nodenames[node.name] then
                            node_drops = minetest.get_node_drops(node.name)
                            for _, itemstack in ipairs(node_drops) do
                                get_name_and_number = itemstack:gmatch("%S+")
                                name = get_name_and_number()
                                number = get_name_and_number()
                                if produced_item[name] then
                                    if number then
                                        produced_item[name] = produced_item[name] + tonumber(number)
                                    else
                                       produced_item[name] = produced_item[name] + 1
                                    end
                                else
                                    if number then
                                        produced_item[name] = tonumber(number)
                                    else
                                       produced_item[name] = 1
                                    end
                                end
                            end
                            remaining_charge = recursive_dig(np, remaining_charge)
                        end
                    end
                end
                return remaining_charge
            end
            remaining_charge = recursive_dig(pos, remaining_charge)
            -- finally run falling code
            chainsaw_nodeupdate(pos_list)
            return {["charge"]=remaining_charge,["produced"]=produced_item}
        end
    end
    -- Nothing sawed down
    return function() return {["charge"]=remaining_charge,["produced"]=produced_item} end
end

local function get_drop_function(pos)
    local minp, maxp, pos_list
    minp = {x=pos.x-4,y=pos.y-1,z=pos.z-4}
    maxp = {x=pos.x+4,y=pos.y+4,z=pos.z+4}
    pos_list = minetest.find_nodes_in_area(minp, maxp, "air")
    if pos_list == nil then
        --if there no air node anywhere near by
        return function () return pos end
    end
    return function()
        local drop_pos
        drop_pos = pos_list[math.random(#pos_list)]
        while true do
            --look down after getting an air node instead of up
            drop_pos.y = drop_pos.y - 1
            if minetest.get_node(drop_pos).name ~= "air" then
                -- Add some variation to the previously integer-only position
                drop_pos.y = drop_pos.y + 1
                drop_pos.x = drop_pos.x + math.random() - .5
                drop_pos.z = drop_pos.z + math.random() - .5
                return drop_pos
            end
        end
    end
end

-- Saw down trees entry point
local function chainsaw_dig_it(pos, player,current_charge)
    if minetest.is_protected(pos, player:get_player_name()) then
        minetest.record_protection_violation(pos, player:get_player_name())
        return current_charge
    end
    local remaining_charge=current_charge

    -- Save default mechanisms so we can restore it.
    local original_nodeupdate = nodeupdate

    -- A bit of trickery here: use a different callback
    -- and restore the original afterwards.

    -- dummying out falling code, it's very slow
    -- we will run chainsaw_nodeupdate with lots of duplicates pos remove
    nodeupdate = function(p, delay) end

    -- clear result and start sawing things down
    local t1 = os.clock()
    local recursive_dig_function = get_recursive_dig_function(pos, remaining_charge, player)
    local output_table = recursive_dig_function()
    print(string.format("elapsed time: %.2fms", (os.clock() - t1) * 1000))
    minetest.sound_play("chainsaw", {pos = pos, gain = 1.0, max_hear_distance = 10,})

    -- Restore the original mechanisms
    nodeupdate = original_nodeupdate

    -- Now drop items for the player
    local number, produced_item, p, get_drop_pos
    get_drop_pos = get_drop_function(pos)
    for produced_item,number in pairs(output_table["produced"]) do
        --print("ADDING ITEM: " .. produced_item .. " " .. number)
        -- Drop stacks of 99 or less
        p = get_drop_pos()
        while number > 99 do
            minetest.add_item(p, produced_item .. " 99")
            p = get_drop_pos()
            number = number - 99
        end
        minetest.add_item(p, produced_item .. " " .. number)
    end
    return output_table["charge"]
end


minetest.register_tool("technic:chainsaw", {
    description = S("Chainsaw"),
    inventory_image = "technic_chainsaw.png",
    stack_max = 1,
    wear_represents = "technic_RE_charge",
    on_refill = technic.refill_RE_charge,
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then
            return itemstack
        end
        local meta = minetest.deserialize(itemstack:get_metadata())
        if not meta or not meta.charge then
            return
        end
        -- Send current charge to digging function so that the chainsaw will stop after digging a number of nodes.
        if meta.charge < chainsaw_charge_per_node then
            return
        end

        local pos = minetest.get_pointed_thing_position(pointed_thing, above)
        meta.charge = chainsaw_dig_it(pos, user, meta.charge)
        technic.set_RE_wear(itemstack, meta.charge, chainsaw_max_charge)
        itemstack:set_metadata(minetest.serialize(meta))
        return itemstack
    end,
})

minetest.register_craft({
    output = 'technic:chainsaw',
    recipe = {
        {'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:battery'},
        {'technic:stainless_steel_ingot', 'technic:motor',                 'technic:battery'},
        {'',                               '',                             'default:copper_ingot'},
    }
})

