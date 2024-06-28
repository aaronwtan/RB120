# Create a class called MyCar. When you initialize a new instance or object of the class,
# allow the user to define some instance variables that tell us the year, color,
# and model of the car. Create an instance variable that is set to 0 during instantiation
# of the object to track the current speed of the car as well. Create instance methods
# that allow the car to speed up, brake, and shut the car off.

class MyCar
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
hyundai.current_speed
hyundai.speed_up(20)
hyundai.current_speed
hyundai.speed_up(20)
hyundai.current_speed
hyundai.brake(20)
hyundai.current_speed
hyundai.brake(20)
hyundai.current_speed
hyundai.shut_off
hyundai.current_speed
