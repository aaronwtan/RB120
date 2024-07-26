# If we have these two methods in the Computer class:
class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

# and
class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    self.template
  end
end

# What is the difference in the way the code works?

# The code will work in exactly the same way. Both will call the
# template getter method defined by attr_accessor, which will return the value
# of the @template getter method. self in the second example refers to
# instances of the Computer class, so the template getter method which is
# also an instance method will be available to the #show_template instance method.
# Unlike for setter methods, using self is optional, since omitting it
# will not instantiate a local variable
