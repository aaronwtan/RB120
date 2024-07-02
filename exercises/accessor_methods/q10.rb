# Modify the following code to accept a string containing a first and last name.
# The name should be split into two instance variables in the setter method,
# then joined in the getter method to form a full name.

class Person
  def name
    [@first_name, @last_name].join(' ')
  end

  def name=(name)
    @first_name, @last_name = name.split
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name

# Expected output:
# John Doe
