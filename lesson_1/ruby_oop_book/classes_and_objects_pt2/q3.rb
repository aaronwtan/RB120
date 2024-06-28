# When running the following code...

# class Person
#   attr_reader :name
#   def initialize(name)
#     @name = name
#   end
# end

# bob = Person.new("Steve")
# bob.name = "Bob"

# We get the following error...
# undefined method `name=' for #<Person:0x007fef41838a28 @name="Steve"> (NoMethodError)

# Why do we get this error and how do we fix it?
# We get this error because the attr_reader method only defines a getter name method,
# and line 9 calls a setter method name= which has not been defined. This can be fixed
# by replacing attr_reader with attr_accessor to create both a getter and setter method

class Person
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
bob.name = "Bob"
