# Further Exploration
# This exercise can be solved in a similar manner by using inheritance; a Noble is a Person, and a Cheetah is a Cat,
# and both Persons and Cats are Animals. What changes would you need to make to this program
# to establish these relationships and eliminate the two duplicated #to_s methods?

# Is to_s the best way to provide the name and title functionality we needed for this exercise?
# Might it be better to create either a different name method (or say a new full_name method)
# that automatically accesses @title and @name? There are tradeoffs with each choice -- they are worth considering.

module Walkable
  def walk
    puts "#{full_name} #{gait} forward"
  end
end

class Animal
  include Walkable

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def full_name
    name
  end
end

class Person < Animal
  private

  def gait
    "strolls"
  end
end

class Noble < Person
  attr_reader :title

  def initialize(name, title)
    super(name)
    @title = title
  end

  def full_name
    "#{title} #{name}"
  end

  private

  def gait
    'struts'
  end
end

class Cat < Animal
  private

  def gait
    "saunters"
  end
end

class Cheetah < Cat
  private

  def gait
    "runs"
  end
end

mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
flash.walk
# => "Flash runs forward"

byron = Noble.new("Byron", "Lord")
byron.walk
# => "Lord Byron struts forward"
puts byron.name
# => "Byron"
puts byron.title
# => "Lord"
