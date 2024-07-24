# What could you add to this class to simplify it and remove two methods
# from the class definition while still maintaining the same functionality?
# class BeesWax
#   def initialize(type)
#     @type = type
#   end

#   def type
#     @type
#   end

#   def type=(t)
#     @type = t
#   end

#   def describe_type
#     puts "I am a #{@type} of Bees Wax"
#   end
# end

class BeesWax
  attr_accessor :type

  def initialize(type)
    @type = type
  end

  def describe_type
    puts "I am a #{type} of Bees Wax"
  end
end
