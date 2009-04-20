require 'rubygems'
require 'gosu'
require 'weapon'
require 'map'

module Sprite
  TEX_WIDTH  = 64
  TEX_HEIGHT = 64
  
  attr_accessor :x
  attr_accessor :y
  attr_accessor :window
  attr_accessor :slices
  attr_accessor :z_order
end

class SpritePool
  @@files = {}
  
  def self.get(window, file_path, sprite_height)
    file_path = File.expand_path(file_path)
    if !@@files[file_path]
      @@files[file_path] = Gosu::Image::load_tiles(window, file_path, 1, Sprite::TEX_HEIGHT, true)
    end
    
    return @@files[file_path]
  end
end

class Lamp
  include Sprite
  
  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @slices = SpritePool::get(window, 'lamp.bmp', TEX_HEIGHT)
  end
end

class Rails
  include Sprite
  
  @@interact_sound = nil
  
  def initialize(window, map, x, y)
    @window = window
    @x = x
    @y = y
    @map = map
    @slices = SpritePool::get(window, 'rails.bmp', TEX_HEIGHT)
    
    @@interact_sound = Gosu::Sample.new(@window, 'ammo.mp3') if @@interact_sound.nil?
  end
  
  def interact(player)
    my_row, my_column = Map.matrixify(@y, @x)
    player_row, player_column = Map.matrixify(player.y, player.x)
    
    if my_row == player_row && my_column == player_column && player.health < Player::MAX_HEALTH
      @@interact_sound.play
      player.health = (player.health + 5 >= Player::MAX_HEALTH) ? Player::MAX_HEALTH : player.health + 5
      @map.items.delete(self)
    end
  end
end