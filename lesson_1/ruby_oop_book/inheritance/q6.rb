# Write a method called age that calls a private method to calculate the age of the vehicle.
# Make sure the private method is not available from outside of the class.
# You'll need to use Ruby's built-in Time class to help.

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

  def print_age
    puts "Your #{full_name} is #{age} years old."
  end

  private

  def age
    Time.now.year - year.to_i
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

my_truck = MyTruck.new(2020, 'silver', 'Chevy Silverado', 2500)
puts my_truck

my_car.print_age
my_truck.print_age
