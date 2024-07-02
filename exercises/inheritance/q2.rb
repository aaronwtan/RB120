# Change the following code so that creating a new Truck
# automatically invokes #start_engine.
class Vehicle
  attr_reader :year

  def initialize(year)
    @year = year
    start_engine
  end

  def start_engine
    puts 'Ready to go!'
  end
end

class Truck < Vehicle  
end

truck1 = Truck.new(1994)
puts truck1.year

# Expected output:
# Ready to go!
# 1994
