local enemy = ...

-- Lynel (boss): a lion who can shoot fire and run after the hero.

local can_shoot = true

function enemy:on_created()
  self:set_life(4); self:set_damage(2)
  self:create_sprite("enemies/outside/lynel")
  self:set_size(32, 32); self:set_origin(16, 27)
  self:set_pushed_back_when_hurt(false)
  self:set_attack_consequence ("arrow", "hurt")
  self:set_attack_consequence("boomerang", "protected")
  self:set_attack_consequence("fire", "protected")
end

local function go_random()
    going_hero = false
    local m = sol.movement.create("random_path")
    if m == nil then
      -- No movement.
      enemy:get_sprite():set_animation("stopped")
      m = enemy:get_movement()
      if m ~= nil then
        -- Stop the previous movement.
        m:stop()
      end
    else
			enemy:get_sprite():set_animation("walking")
      m:set_speed(32)
      m:set_ignore_obstacles(false)
      m:start(enemy)
    end
  end

local function go_hero()
  local sprite = enemy:get_sprite()
  sprite:set_animation("walking")
  local movement = sol.movement.create("target")
  local rand = math.random(5)
  if rand < 4 then movement:set_speed(32) else movement:set_speed(40) end
  movement:start(enemy)
end

local function shoot_fire()
  local sprite = enemy:get_sprite()
  local x, y, layer = enemy:get_position()
  local direction = sprite:get_direction()

  -- Where to start the fire from.
  local dxy = {
    {  8, -13 },
    {  0, -21 },
    { -8, -13 },
    {  0,  -8 },
  }

  sprite:set_animation("shooting")
  enemy:stop_movement()
  sol.timer.start(enemy, 500, function()
    sol.audio.play_sound("items/fire_rod/shoot")
    local flame = enemy:create_enemy({
      breed = "projectiles/fire_shot",
      x = dxy[direction + 1][1],
      y = dxy[direction + 1][2],
    })

    flame:go(direction)
    go_random()
  end)
end

function enemy:on_restarted()
  local map = enemy:get_map()
  local hero = map:get_hero()

  go_hero()
  can_shoot = true

  sol.timer.start(enemy, 200, function()
    local hero_x, hero_y = hero:get_position()
    local x, y = enemy:get_center_position()

    if can_shoot then
      local aligned = (math.abs(hero_x - x) < 16 or math.abs(hero_y - y) < 16) 
      if aligned and enemy:get_distance(hero) < 200 then
        shoot_fire()
        can_shoot = false
        sol.timer.start(enemy, 1500, function()
          can_shoot = true
        end)
      end
    end
    return true  -- Repeat the timer.
  end)
end

function enemy:on_movement_changed(movement)
  local direction4 = movement:get_direction4()
  local sprite = self:get_sprite()
  sprite:set_direction(direction4)
end