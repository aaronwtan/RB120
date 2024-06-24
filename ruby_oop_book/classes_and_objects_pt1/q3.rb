# You want to create a nice interface that allows you to accurately describe the action
# you want your program to perform. Create a method called spray_paint
# that can be called on an object and will modify the color of the car.

class MyCar
  attr_accessor :color
  attr_reader :year

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
  end

  def spray_paint(new_color)
    self.color = new_color
    puts "You painted your #{@year} #{@model} #{new_color}!"
  end

  def speed_up(num)
    @current_speed += num
    puts "You sped up and accelerate #{num} mph."
  end

  def brake(num)
    @current_speed -= num
    puts "You braked and decelerate #{num} mph."
  end

  def current_speed
    puts "You are now going #{@current_speed} mph."
  end

  def shut_off
    @current_speed = 0
    puts "You shut off your car."
  end
end

hyundai = MyCar.new(2017, 'white', 'elantra')
puts hyundai.color
hyundai.spray_paint('black')
puts hyundai.color
