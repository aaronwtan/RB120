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

  def to_s
    name
  end
end

# Continuing with our Person class definition, what does the below code print out?
bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"

# the above code would print out the name of the class along with an object code,
# which is the default behavior of calling #to_s on any object without
# another #to_s method to override it
