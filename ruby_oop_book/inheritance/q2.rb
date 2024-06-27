# Add a class variable to your superclass that can keep track of the number
# of objects created that inherit from the superclass. Create a method
# to print out the value of this class variable as well.

class Vehicle
  attr_accessor :color
  attr_reader :year, :model

  @@num_of_vehicles = 0

  def self.calculate_mpg(miles, gallons)
    puts "Your car gets #{miles / gallons} miles per gallon of gas."
  end

  def self.num_of_vehicles
    puts "There are currently #{@@num_of_vehicles} vehicles."
  end

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0

    @@num_of_vehicles += 1
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

Vehicle.num_of_vehicles
