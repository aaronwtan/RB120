# Add an accessor method to your MyCar class to change and view the color
# of your car. Then add an accessor method that allows you to view,
# but not modify, the year of your car.

class MyCar
  attr_accessor :color
  attr_reader :year

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
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
hyundai.color = 'black'
puts hyundai.color
puts hyundai.year
