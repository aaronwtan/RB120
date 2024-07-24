# If I have the following class:
class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end
# Which one of these is a class method (if any) and how do you know?
# How would you call a class method?
# Television::manufacturer is a class method because the method name
# is prefixed with self., self here referring to the Television class itself.
# The method can be called by invoking the method on the class itself,
# like so: Television.manufacturer
