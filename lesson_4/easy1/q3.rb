# In the last question we had a module called Speed which contained a go_fast method.
# We included this module in the Car class as shown below.
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

# When we called the go_fast method from an instance of the Car class (as shown below)
# you might have noticed that the string printed when we go fast includes the name
# of the type of vehicle we are using. How is this done?
small_car = Car.new
small_car.go_fast
# I am a Car and going super fast!

# The #go_fast instance method referencing self.class during string interpolation.
# self when used within an instance method references the calling object,
# which in this case is a Car object or instance. Since the object itself is referenced,
# calling #class on self will simply return the class of the object that is calling #go_fast,
# which allows us to know the class of vehicle being used
