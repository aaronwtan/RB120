# Consider the following class:

class Machine
  def initialize
    stop
  end

  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def status
    puts "The machine is #{switch}!"
  end

  private

  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

# Modify this class so both flip_switch and
# the setter method switch= are private methods.

# Further Exploration
# Add a private getter for @switch to the Machine class,
# and add a method to Machine that shows how to use that getter.

machine = Machine.new
machine.status
machine.start
machine.status
machine.stop
machine.status
