# Using the class definition from step #3, let's create a few more people -- that is, Person objects.

class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  def same_name?(other_person)
    name == other_person.name
  end

  private

  def parse_full_name(full_name)
    names = full_name.split
    self.first_name = names.first
    self.last_name = names.size > 1 ? names.last : ''
  end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

# If we're trying to determine whether the two objects contain the same name,
# how can we compare the two objects?

p bob.name == rob.name
p bob.same_name?(rob) # => true
