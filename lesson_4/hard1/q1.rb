# Ben and Alyssa are working on a vehicle management system. So far,
# they have created classes called Auto and Motorcycle
# to represent automobiles and motorcycles.
# After having noticed common information and calculations
# they were performing for each type of vehicle, they decided
# to break out the commonality into a separate class called WheeledVehicle.
# This is what their code looks like so far:
module Movable
  attr_accessor :speed, :heading
  attr_writer :fuel_efficiency, :fuel_capacity

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle
  include Movable

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

# Now Alan has asked them to incorporate a new type of vehicle
# into their system - a Catamaran defined as follows:
class Catamaran
  include Movable

  attr_reader :propeller_count, :hull_count

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    @propeller_count = num_propellers
    @hull_count = num_hulls
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end
end

car = Auto.new
moto = Motorcycle.new
cata = Catamaran.new(4, 2, 50, 80)
puts car.range
puts moto.range
puts cata.range
cata.speed = 9000
puts cata.speed

# This new class does not fit well with the object hierarchy defined so far.
# Catamarans don't have tires. But we still want common code to track fuel efficiency
# and range. Modify the class definitions and move code into a Module, as necessary,
# to share code among the Catamaran and the wheeled vehicles.
