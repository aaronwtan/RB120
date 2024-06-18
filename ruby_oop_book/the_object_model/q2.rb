module MyModule
end

class MyClass
  include MyModule
end

my_obj = MyClass.new

# A module is a collection of behaviors that can be imported or "mixed in" to a class
# so that the class will acquire the behaviors defined in the module.
# A module is used by invoking the include method within a class
