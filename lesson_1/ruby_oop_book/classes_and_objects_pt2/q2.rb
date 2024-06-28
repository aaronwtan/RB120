class MyCar
  attr_accessor :color
  attr_reader :year, :model

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

  def to_s
    "My car is a #{color} #{year} #{model}."
  end
end

elantra = MyCar.new(2017, 'white', 'Elantra')
puts elantra

sonata = MyCar.new(2013, 'black', 'Sonata')
puts sonata
