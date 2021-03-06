-- Bow
local item = ...

function item:on_created()

  self:set_savegame_variable("possession_bow")
  self:set_amount_savegame_variable("amount_bow")
  self:set_assignable(true)
  item:set_sound_when_brandished("common/big_item")
end

function item:on_using()

  if self:get_amount() == 0 then
    sol.audio.play_sound("wrong")
  else
    -- we remove the arrow from the equipment after a small delay because the hero
    -- does not shoot immediately
    sol.timer.start(300, function()
      self:remove_amount(1)
    end)
    self:get_map():get_entity("hero"):start_bow()
  end
  self:set_finished()

end

function item:on_amount_changed(amount)

  if self:get_variant() ~= 0 then
    if amount == 0 then
      self:set_variant(1)
    else
      self:set_variant(2)
    end
  end

end

function item:on_obtaining(variant, savegame_variable)

  local quiver = self:get_game():get_item("quiver")
  if not quiver:has_variant() then
    quiver:set_variant(1)
  end

end

