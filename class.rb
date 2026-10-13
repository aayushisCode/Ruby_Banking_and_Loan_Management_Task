class Product
  def display
    puts "This is a product"
  end
end
# p1=Product.new
# p1.display

#using inilialize
class Product2
  def initialize(name, price)
    @name=name
    @price=price
  end

  def display
    puts "Products: #{@name} , Price: #{@price}"
  end
end

# p2= Product2.new("Laptop", 55000)
# p2.display

class Product3
  def self.category
    puts "Electronics"
  end
end

# Product3.category
#-----------------------------------ALL IN ONE---------------------------
class Product4
  TAX = 0.05
  attr_accessor :name
  attr_reader :price

  def initialize(name, price)
    @name = name
    @price = price
  end
  def display
    puts "Prodduct name: #{@name}, $#{@price}"
  end

  def self.strore_info
    puts " Ruby store"
  end
  def final_price
    final_price= @price + (@price + TAX)
    puts "This is the final price:$ #{final_price} "
  end


end
# Object1=Product4.new("Laptop", 55000)
# Object1.display
# Object1.final_price
# Product4.strore_info
# puts Product4::TAX

#----------------Module-------------
module CustomerApp
  class User
    def role
      "Customer"
    end
  end
end

module AdminApp
  class User
    def role
      "Admin"
    end
  end
end
# obj1=CustomerApp::User.new
# puts obj1.role

# obj2= AdminApp::User.new
# puts obj2.role

#---------------Mixins------------
#A way to reuse methods from module in 1/+ classes
module Notification
  def send_notification
    puts "Notification sent!"
    # super
  end
end

class User
  include Notification
  # prepend Notification
  def send_notification
    puts " Super executed in class!!"
    super
  end
end
class Order
  include Notification
  extend Notification

end
# user = User.new
# user.send_notification
# order = Order.new
# order.send_notification
# Order.send_notification

#----------------Nested Module--------
module Company
  module Quickinsure
    class Insurance
      attr_accessor :name
      attr_accessor :category
      def initialize(name,category)
        @name=name
        @category=category
      end
      def role(category:"IT")
        puts "#{@name}, #{@category}"
      end
    end
  end
end
# obj=Company::Quickinsure::Insurance.new("Aayushi","CSE")
# puts obj.role

#--------moduleFunction----------
module Calculator 
  module_function
  def add(a,b)
    a+b
  end
  module_function
  def sub(a,b)
    a-b
  end
end
class MathTool
  include Calculator
  def calculate 
    add(10,20)
    sub(20,10)
  end
  
end
tool = MathTool.new
puts tool.calculate