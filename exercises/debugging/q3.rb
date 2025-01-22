# On lines 37 and 38 of our code, we can see that grace and ada are located
# at the same coordinates. So why does line 39 output false?
# Fix the code to produce the expected output.

class Person
  attr_reader :name
  attr_accessor :location

  def initialize(name)
    @name = name
  end

  def teleport_to(latitude, longitude)
    @location = GeoLocation.new(latitude, longitude)
  end
end

class GeoLocation
  attr_reader :latitude, :longitude

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def to_s
    "(#{latitude}, #{longitude})"
  end

  def ==(other)
    latitude == other.latitude && longitude == other.longitude
  end
end

# Example

ada = Person.new('Ada')
ada.location = GeoLocation.new(53.477, -2.236)

grace = Person.new('Grace')
grace.location = GeoLocation.new(-33.89, 151.277)

ada.teleport_to(-33.89, 151.277)

puts ada.location                   # (-33.89, 151.277)
puts grace.location                 # (-33.89, 151.277)
puts ada.location == grace.location # expected: true
                                    # actual: false

# The @location instance variables for ada and grace both reference separate
# GeoLocation objects. Even when the Person#teleport_to instance method
# is called on ada, ada's @location instance variable is reassigned to a
# new GeoLocation object. Calling puts on the @location instance variables
# of ada and grace with automatically call the custom #to_s method
# defined in the GeoLocation class, which are the strings outputed when
# calling puts ada.location and puts grace.location. However, they
# are still separate GeoLocation objects that happen to have the same
# values stored in the @latitude and @longitude instance variables,
# which is why testing ada.location and grace.location for equivalence
# yields false. The expected output can be achieved by defining a
# custom GeoLocation#== method that will override the default #== method
# and will instead check for equivalence by comparing values of the latitude
# and longitude attributes
