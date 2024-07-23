# If we have a Car class and a Truck class and we want to be able to go_fast,
# how can we add the ability for them to go_fast using the module Speed?
# How can you check if your Car or Truck can now go fast?
module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed

  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed

  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

puts Car.method_defined?(:go_fast)
puts Truck.method_defined?(:go_fast)

car = Car.new
car.go_fast
truck = Truck.new
truck.go_fast

# The Speed module needs to be mixed into the Car and Truck class.
# We can check if the #go_fast method is available to Car and Truck objects
# by calling Car::instance_methods and Truck::instance_methods,
# or by instantiating Car and Truck objects and test if these instances can
# call #go_fast
