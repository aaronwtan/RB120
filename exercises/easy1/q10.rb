# Consider the following classes:
class Vehicle
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end

  def to_s
    "#{make} #{model}"
  end
end

class Car < Vehicle
  def wheels
    4
  end
end

class Motorcycle < Vehicle
  def wheels
    2
  end
end

class Truck < Vehicle
  attr_reader :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end

  def wheels
    6
  end
end

# Refactor these classes so they all use a common superclass, and inherit behavior as needed.

# Further Exploration
# Would it make sense to define a wheels method in Vehicle even though all of the remaining
# classes would be overriding it? Why or why not? If you think it does make sense,
# what method body would you write?
# It would make sense if we can know if all Vehicle objects will have wheels. If they do,
# then one approach is to define a constant for the number of wheels within each of the subclasses,
# then having the wheels method in Vehicle return these constants

# class Vehicle
#   def wheels
#     self.class::NUM_OF_WHEELS
#   end
# end

# class Motorcycle < Vehicle
#   NUM_OF_WHEELS = 2
# end
