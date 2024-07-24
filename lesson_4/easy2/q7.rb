# If we have a class such as the one below:
class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

puts Cat.cats_count

fluffy = Cat.new('fluffy')
puts Cat.cats_count

black = Cat.new('black')
floofy = Cat.new('floofy')
puts Cat.cats_count

# Explain what the @@cats_count variable does and how it works.
# What code would you need to write to test your theory?
# @@cats_count is a class variable which will keep track of the 
# number of Cat objects that have been instantiated. This works
# because every time a Cat object is created, the #initialize instance
# method is called, which has been defined to increment @@cats_count by 1
# This can be verfied by creating some Cat objects and then calling
# the class method Cat::cats_count, which will return the value
# of the @@cats_count class variable
