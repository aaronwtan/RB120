# Alan created the following code to keep track of items
# for a shopping cart application he's writing:
class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end

# Alyssa looked at the code and spotted a mistake.
# "This will fail when update_quantity is called", she says.

# Can you spot the mistake and how to address it?

# quantity in the #update_quantity instance method will
# instantiate a new quantity local variable and assign it the value
# of the updated_count parameter rather than calling a setter method
# or reassigning the @quantity instance variable. To address this,
# either quantity needs to be changed to @quantity to reassign the
# @quantity instance variable directly, or a quantity setter
# method needs to be added via attr_accessor and invoked within
# #update_quantity using self.quantity = updated_count
class InvoiceEntry
  attr_reader :product_name
  attr_accessor :quantity

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    self.quantity = updated_count if updated_count >= 0
  end
end
