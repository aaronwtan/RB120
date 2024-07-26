# If I have the following class:
class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

# What would happen if I called the methods like shown below?
tv = Television.new
tv.manufacturer # undefined method error because tv is an instance of Television
                # and ::manufacturer is a class method
tv.model # the #model instance method would be invoked

Television.manufacturer # the ::manufacturer class method would be invoked
Television.model # undefined method error because Television is a class
                 # and #model is an instance method
