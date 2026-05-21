-- example mod that gives you a springboard sized jump when using space

local boost = 0

return {

  -- called once when the game loads (or when your mod is marked 'active')
  load = function(mod_id)
    print('Hello world!', mod_id)
    return true
  end,

  -- called on key press
  key = function(key, scancode, is_repeat)
    -- space pressed, check in-game and player exists or you'll get crashes!
    if game.g.state == 'game' and game.g.player and key == 'space' and boost <= 0 then
      -- run same spring jump code from the game's `player.lua`, accounting for dt
      print('spring jump!')
      game.g.player.physics.jumping = 0
      game.g.player.physics.can_jump = false
      game.g.player.physics.spring = true
      game.g.player.physics.grounded = false
      game.g.player.physics.accl = 0
      game.g.sound:playSound('net')
      -- initisal push
      game.g.player.y = game.g.player.y - (game.g.player.physics.jump * 0.05)
      -- used for pfx
      boost = 0.3
    end
  end,

  -- called every frame
  step = function(dt)
    -- check we are in a level and player exists
    if game.g.state == 'game' and game.g.player then
      -- count down boost with dt, we set to 0.3 when we jump
      -- this means we run this code for 0.3s
      if boost > 0 then
        -- create some particles (defined in the game's `ev_load` if you want to see more types!)
        game.g.psystem_aobj:createRegion('respawn', game.g.player.x, game.g.player.y, 17, 17, 5)
        boost = boost - dt
        if boost <= 0 then
          boost = 0
        end
      end
    end
  end

}
