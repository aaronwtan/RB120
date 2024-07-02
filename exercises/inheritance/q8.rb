# Using the following code, determine the lookup path used when invoking cat1.color.
# Only list the classes and modules that Ruby will check when searching for the #color method.
class Animal
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new
cat1.color
# cat1.color Lookup Path
# ----------------------
# Cat
# Animal
# Object
# Kernel
# BasicObject

# Note an exception will be raised because Ruby will not find any color method after
# traversing through the entire class hierarchy 
