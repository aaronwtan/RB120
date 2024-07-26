# In the last question Alan showed Alyssa this code
# which keeps track of items for a shopping cart application:
class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    quantity = updated_count if updated_count >= 0
  end
end

# Alyssa noticed that this will fail when update_quantity is called.
# Since quantity is an instance variable, it must be accessed
# with the @quantity notation when setting it. One way to fix this is
# to change attr_reader to attr_accessor and change quantity to self.quantity.

# Is there anything wrong with fixing it this way?

# if attr_reader is simply changed to attr_accessor as is, this will add setter
# methods for both the quantity and product_name attributes. Since we most
# likely do not want to allow product_name to be changed, attr_accessor
# should only be defined for quantity, while keeping only attr_reader defined
# for product_name. attr_accessor is also defined publicly, which will
# allows quantity to be changed directly without passing through the check
# defined in the #update_quantity method. This can be mitigated by only
# defining attr_accessor privately
