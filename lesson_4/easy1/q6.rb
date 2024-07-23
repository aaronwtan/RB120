# What is the default return value of to_s when invoked on an object? Where could you go to find out if you want to be sure?
# The default is the name of the class along with an encoding of the object id.
# To check this, we can simply call #puts on the object, which automatically calls #to_s
