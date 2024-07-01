# Modify the class definition from above to facilitate the following methods.
# Note that there is no name= setter method now.

class Person
  attr_accessor :first_name, :last_name

  def initialize(first_name, last_name = '')
    @first_name = first_name
    @last_name = last_name
  end

  def name
    "#{first_name} #{last_name}".strip
  end
end

bob = Person.new('Robert')
bob.name                  # => 'Robert'
bob.first_name            # => 'Robert'
bob.last_name             # => ''
bob.last_name = 'Smith'
bob.name                  # => 'Robert Smith'
