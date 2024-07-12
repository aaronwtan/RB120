# Write a class that will display:
# ABC
# xyz

class Transform
  attr_reader :data

  def self.lowercase(str)
    str.downcase
  end

  def initialize(data)
    @data = data
  end

  def uppercase
    data.upcase
  end
end

# when the following code is run:
my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')