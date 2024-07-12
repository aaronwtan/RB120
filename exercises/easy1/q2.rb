# Take a look at the following code:
class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    "My name is #{@name.upcase}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name # Fluffy
puts fluffy # My name is FLUFFY.
puts fluffy.name # FLUFFY
puts name # FLUFFY

# What output does this code print? Think about any undesirable effects occurring
# due to the invocation on line 20. Fix this class so that there are no surprises
# waiting in store for the unsuspecting developer.

# Further Exploration
# What would happen in this case?
name = 42
fluffy = Pet.new(name)
name += 1
puts fluffy.name # 42
puts fluffy # My name is 42.
puts fluffy.name # 42
puts name # 43

# This code "works" because of that mysterious to_s call in Pet#initialize.
# However, that doesn't explain why this code produces the result it does. Can you?
# When #to_s is called on the 42 Integer object assigned to the name parameter in the #initialize instance method,
# it returns a new String object '42', which is assigned to the @name instance variable.
# This @name instance variable points at a different object from the name local variable initialized
# in the main code, so the name local variable can be changed without affecting @name.
# Furthermore, integers are immutable so there wouldn't be a way to mutate @name anyways
