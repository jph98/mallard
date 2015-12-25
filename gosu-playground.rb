#!/usr/bin/env ruby

require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Gosu Tutorial Game"
  end

  def update
  end

  def draw

  	draw_line(20, 20, Gosu::Color::RED, 0, 200, Gosu::Color::RED)
  end
end

window = GameWindow.new
window.show