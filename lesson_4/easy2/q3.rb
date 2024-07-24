# How do you find where Ruby will look for a method when that method is called?
# How can you find an object's ancestors?
module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end

puts "Orange Lookup Path"
puts "----------"
puts Orange.ancestors

puts ''

puts "HotSauce Lookup Path"
puts "----------"
puts HotSauce.ancestors

# What is the lookup chain for Orange and HotSauce?
# Ruby will traverse the Method Lookup Path to search for a method
# when one is called. This path can be found by calling the #ancestors method
# on an object's class to display its ancestors in order of its lookup path

# Orange Lookup Path
# Orange
# Taste
# Object
# Kernel
# BasicObject

# HotSauce Lookup Path
# HotSauce
# Taste
# Object
# Kernel
# BasicObject
