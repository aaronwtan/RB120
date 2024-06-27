# Add a class method to your MyCar class that calculates the gas mileage
# (i.e. miles per gallon) of any car.

class MyCar
  attr_accessor :color
  attr_reader :year

  def self.calculate_mpg(miles, gallons)
    puts "Your car gets #{miles / gallons} miles per gallon of gas."
  end

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

MyCar.calculate_mpg(300, 16)
MyCar.calculate_mpg(100, 10)
