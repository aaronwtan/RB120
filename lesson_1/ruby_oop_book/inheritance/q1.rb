# Create a superclass called Vehicle for your MyCar class to inherit from
# and move the behavior that isn't specific to the MyCar class to the superclass.
# Create a constant in your MyCar class that stores information about the vehicle
# that makes it different from other types of Vehicles.

# Then create a new class called MyTruck that inherits from your superclass
# that also has a constant defined that separates it from the MyCar class in some way.

class Vehicle
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

  def full_name
    "#{color} #{year} #{model}"
  end

  def speed_up(num)
    @current_speed += num
    puts "You sped up your #{full_name} and accelerate #{num} mph."
  end

  def brake(num)
    @current_speed -= num
    puts "You braked your #{full_name} and decelerate #{num} mph."
  end

  def current_speed
    puts "Your #{full_name} is now going #{@current_speed} mph."
  end

  def shut_off
    @current_speed = 0
    puts "You shut off your #{full_name}."
  end

  def spray_paint(new_color)
    self.color = new_color
    puts "You painted your #{@year} #{@model} #{new_color}!"
  end

  def to_s
    "My #{TYPE_OF_VEHICLE} is a #{full_name}."
  end
end

class MyCar < Vehicle
  TYPE_OF_VEHICLE = 'car'
  NUMBER_OF_DOORS = 4

  def to_s
    "My #{TYPE_OF_VEHICLE} is a #{color} #{year} #{model} and has #{NUMBER_OF_DOORS} doors."
  end
end

class MyTruck < Vehicle
  TYPE_OF_VEHICLE = 'truck'
  NUMBER_OF_DOORS = 2

  def to_s
    "My #{TYPE_OF_VEHICLE} is a #{color} #{year} #{model} and has #{NUMBER_OF_DOORS} doors."
  end
end

my_car = MyCar.new(2017, 'white', 'Elantra')
puts my_car

my_truck = MyTruck.new(2020, 'silver', 'Chevy Silverado')
puts my_truck
