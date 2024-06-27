# Move all of the methods from the MyCar class that also pertain to the MyTruck class
# into the Vehicle class. Make sure that all of your previous method calls are working
# when you are finished.

module Towable
  def tow(vehicle)
    if can_tow?(vehicle.weight)
      puts "Your vehicle is towing your #{vehicle.full_name}."
    else
      puts "Too heavy to tow!"
    end
  end

  def can_tow?(weight)
    weight < 2000
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :year, :model, :weight

  @@num_of_vehicles = 0

  def self.calculate_mpg(miles, gallons)
    puts "Your vehicle gets #{miles / gallons} miles per gallon of gas."
  end

  def self.num_of_vehicles
    puts "There are currently #{@@num_of_vehicles} vehicles."
  end

  def initialize(year, color, model, weight)
    @year = year
    @color = color
    @model = model
    @weight = weight
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
  include Towable

  TYPE_OF_VEHICLE = 'truck'
  NUMBER_OF_DOORS = 2

  def to_s
    "My #{TYPE_OF_VEHICLE} is a #{color} #{year} #{model} and has #{NUMBER_OF_DOORS} doors."
  end
end

my_car = MyCar.new(2017, 'white', 'Elantra', 1500)
puts my_car

my_heavy_car = MyCar.new(2013, 'black', 'Sonata', 2200)
puts my_heavy_car

my_truck = MyTruck.new(2020, 'silver', 'Chevy Silverado', 2500)
puts my_truck

Vehicle.calculate_mpg(300, 16)

my_car.color
my_car.spray_paint('black')
my_car.speed_up(25)
my_car.current_speed
my_car.brake(25)
my_car.current_speed
my_car.shut_off
my_car.current_speed

my_truck.color
my_truck.spray_paint('gold')
my_truck.speed_up(30)
my_truck.current_speed
my_truck.brake(30)
my_car.current_speed
my_truck.shut_off
my_car.current_speed
