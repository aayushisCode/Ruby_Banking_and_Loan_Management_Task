#1. Encapsulation
class BankAccount
  def initialize(balance)
    @balance = balance 
    
  end
  def deposite(amount)
    @balance +=amount
  end

  def withdraw(amount)
    if amount > 0 && amount <= @balance
      @balance -= amount

    else 
      puts "Insufficient Balance"
    end
  end
  def show_balance
    puts "Your account balance is #{@balance}"
  end
end

account = BankAccount.new(1000)
# account.deposite(5000)
# account.withdraw(2000)
# account.show_balance

#-------------------Inheritance--------------
class Car 
  def accelerate
    puts "speedup!!"
  end
  def break
    puts "Stop the car"
  end

end
class Bmw < Car
  def sound
    puts "PeepPeep"
  end
end
car= Bmw.new
# car.accelerate
# car.break
# car.sound
# puts "----"
# car2=Car.new
# car2.break
# 
#--------------3.Polymorphism-----------
class UPI
  def pay(amount)
    puts "successful payment via upi of amount:$#{amount}"
  end
end
class CreditCard
  def pay(amount)
    puts "successful payment via creditcard of amount:$#{amount}"
  end
end

payment=[UPI.new, CreditCard.new]
# payment.each {|p| p.pay(1000)}
# puts "------"
# #--accessing 1 obj only from array
# payment.find { |p| p.is_a?(UPI) }.pay(500)

#----------4.Abstraction---------

class Order
  def check_out
      validate_order
      total_amount
      process_payment
  end
  private
  def validate_order
    puts "Validating orders..."
  end
  def total_amount
    puts "Calculating total amount.."
  end
  def process_payment
    puts "Processing payments..."
  end
end
# order=Order.new
# order.check_out

#----------Super---------
class Animal
  def sound
    puts "This is animal sound"
  end
end
class Dog < Animal
  
  def sound
    super
    puts "Dog barks"
  end
end
# Dog.new.sound
# dog= Dog.new
# dog.sound

#-----super with arguments-----
class Manager
  def initialize(name)
    @name=name
  end
end
class Employee < Manager
  def initialize(name, department)
    super(name) #taking from manager
    @department=department
  end
  def display
    puts "#{@name} and #{@department}"
  end
end
# emp = Employee.new("Aayushi","IT")
# emp.display

#-------Compostion: Type- Strong---------

class Engine
  def start
    puts "Main Engine started"
  end
end

class Car
  def initialize
    @engine = Engine.new
  end
  def start
    @engine.start
    puts " Car engine stared"
  end
end
# Car.new.start

#------Association----
class Student
  attr_reader :name
  def initialize(name)
    @name=name
  end
end
class Teacher
  attr_reader :name
  def initialize(name)
    @name = name
  end
  def teach(student)
    puts " #{@name} is teaching #{student.name}"
  end
end

teacher=Teacher.new("Priya")
student= Student.new("Rahul")
# teacher.teach(student)