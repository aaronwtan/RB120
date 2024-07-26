# What is used in this class but doesn't add any value?
class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    return "I want to turn on the light with a level of super high and a color of green"
  end

end

# The Light::information method is a class method, so it won't ever use any data tied to instances
# created from Light. This method needs to be changed to an instance method to make
# use of the brightness and color attributes associated with newly created Light objects.
# The explict return in ::information is also unnecessary since Ruby implicitly returns the last line
# of any method
