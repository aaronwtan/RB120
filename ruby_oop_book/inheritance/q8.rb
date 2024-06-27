# class Person
#   private

#   def hi
#     puts 'Hello!'
#   end
# end

# class Person
#   def hi
#     puts 'Hello!'
#   end

#   private
# end

class Person
  def public_hi
    hi
  end

  private

  def hi
    puts 'Hello!'
  end
end

# Given the following code...
bob = Person.new
# bob.hi
bob.public_hi

# And the corresponding error message...
# NoMethodError: private method `hi' called for #<Person:0x007ff61dbb79f0>
# from (irb):8
# from /usr/local/rvm/rubies/ruby-2.0.0-rc2/bin/irb:16:in `<main>'

# What is the problem and how would you go about fixing it?
# Person#hi is a private method, so it cannot be called outside of the class.
# This can be fixed by moving the #hi instance method before the private method
# call within the Person class or by making sure #hi is only called
# from within the Person class
