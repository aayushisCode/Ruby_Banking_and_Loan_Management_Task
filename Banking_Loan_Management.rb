class BankAccount
  attr_reader :account_number,  :balance, :transactions
  attr_accessor :customer_name, :account_type

  @@account_number=[] #stores all generated acc_num so diff BA obj can check for duplicates
  @@transaction_counter =0 #to make unique trans id
  MIN_SAVING_BALANCE = 1000

  def initialize
    @account_number=nil #1 account's account number
    @customer_name = nil
    @account_type = nil
    @balance = 0.0
    @transactions = []
    
  end
#GENERATE ACCOUNT NUMBERwhy
  def generate_account_number
    loop do 
      letter = ("A".."Z").to_a.sample
      number= rand(10000..99999)
      account_number = "#{letter}#{number}"

      unless @@account_number.include?(account_number)
      @@account_number << account_number
      return account_number
      end
    end
  end

#CREATE_AMOUNT
  def create_account(customer_name, account_type, opening_balance)
    @customer_name = customer_name
    @account_type = account_type.downcase
    opening_balance = opening_balance.to_f

    unless ["savings", "current"].include?(@account_type)
      puts "Invalid account type"
      return false
    end

    if opening_balance < 0
      puts "Opening balance cannot be negative"
      return false
    end

    if @account_type == "savings" &&
      opening_balance < MIN_SAVING_BALANCE
      puts "Savings account requires a minimum balance of 1000"
      return false
    end

    @balance = opening_balance
    @account_number = generate_account_number

    puts "Account created successfully"
    puts "Account number: #{@account_number}"
    puts "Account holder: #{@customer_name}"
    puts "Account type: #{@account_type}"
    puts "Opening balance: #{@balance}"

    true
  end

#DEPOSITE AMOUNT 
  def deposite(amount)
    amount = amount.to_f

    unless amount > 0
      puts "Deposite rejected: amount must be greater than zero"
      return false
    end
    @balance += amount
    record_transaction("Deposite", amount)
    puts "Deposite successful"
    puts "Deposite amount #{amount}"
    puts "Current balance #{@balance}"
    true
  end
#CHECK WITHDRAWAL AMOUNT EVERYTIME BEFORE WITHDRAWING AN  AMOUNT
  def withdraw?(amount)
    amount = amount.to_f

    return false if amount <=0
    return false if amount > @balance
    if @account_type == "savings"
      return false if(@balance - amount) < MIN_SAVING_BALANCE
    end
    if @account_type == "current"
      return false if (@balance - amount) < 0
    end
    true
  end
#WITHDRAW AMOUNT
  def withdraw(amount)
    amount = amount.to_f

    unless withdraw?(amount)
      puts "Withdrawal rejected: insufficient balance"
      return false
    end
    @balance -= amount
    record_transaction("Withdrawal", amount)
    puts "Withdrawal successful"
    puts "withdrawn amount: #{amount}"
    puts "current balance: #{@balance}"
    true
  end
#RECORD TRANSACTIONS
  def record_transaction(type, amount)
    @@transaction_counter += 1 
    transaction ={
      transactions_id: "TID#{@@transaction_counter }",
      account_number: @account_number,
      type: type,
      amount: amount,
      date_time: Time.now,
      balance_after: @balance
    }
    @transactions << transaction
  end
#SHOW SUMMARY 
  def show_transactions(account_number)
    account_transactions = @transactions.select {|transaction| transaction[:account_number]== account_number}

    if account_transactions.empty?
      puts " No transactions found"
      return
    end
    account_transactions.each { |transaction| 
                          puts "-------------"
                          puts "Transaction ID: #{transaction[:transactions_id]}" 
                          puts "Account: #{transaction[:account_number]}" 
                          puts "Date and Time: #{transaction[:date_time]}"
                          puts "Amount before transaction #{transaction[:amount]}"
                          puts "Balance after successful transaction: #{transaction[:balance_after]}"}
  end
  
  def loan_summary(type,amount,time)
    type=type.to_s.downcase
    if time <=0 
      puts "Time tenure should be greater than zero"
      return
    end
    #calc loan
    loan = 
    if type == "personal"
      (amount * 12* time)/100
    else
      (amount * 8 * time)/100
    end
    puts "Loan interest: #{loan}"
    puts "Total paybale amount: #{amount + loan}"
  end
  ###########

def current_to_saving(saving_account, amount)
  amount = amount.to_f
#@account_type belongs to the object calling the method
  unless @account_type == "current" && saving_account.account_type == "savings"
      puts "Invalid account types for transfer"
      return false
  end
#if sender can afford the transfer , #executed when false/nil
  unless withdraw?(amount)
    puts "Transfer rejected: insufficient balance"
    return false
  end

  @balance -= amount
  saving_account.transfer_without_validation(amount)

  record_transaction("Transfer to savings", amount)
  saving_account.record_transaction("Transfer from current", amount)

  puts "Transfer successful: #{amount}"
  true
end

def transfer_without_validation(amount)
  @balance += amount
end


#############
  def saving_to_current(current_account, amount)
    amount = amount.to_f
    unless @account_type == "savings" && current_account.account_type == "current"
      puts "Inavlid account types for transfer"
      return false
    end
#executed when false/nil
    unless withdraw?(amount)
      puts "Transfer rejected: insufficient balance"
      return false
    end

    @balance -= amount
    #Add money to the receiver
    current_account.transfer_without_validation(amount)
    record_transaction("Transfer to current", amount)
    current_account.record_transaction("Transfer from savings", amount)

    puts "Transfer successful: #{amount}"
    true
end

def transfer_without_validation(amount)
  @balance += amount
end
end

#Test 1, 2, 11#################
# obj1 =BankAccount.new
# obj1.create_account("ABC","current", 5000)
# # obj1.deposite(10000)
# obj1.withdraw(5001)

#test 12###############
# obj1.loan_summary("personal",2000,2)
# obj1.show_transactions(obj1.account_number)


savings_account = BankAccount.new
savings_account.create_account("XYZ", "savings", 10000)

current_account = BankAccount.new
current_account.create_account("ABC", "current", 500)

# current_account.current_to_saving(savings_account, 2000)

# puts current_account.balance  
# puts savings_account.balance  

##########################################################
#tc 06
# res = current_account.deposite(0)
# puts "Deposite: #{current_account.balance}"

#test 14###########################
# current_account.loan_summary("home", 0, -1)

#test 15######################
# savings_account.saving_to_current(current_account, 2000)
# puts " Success"
# puts "current balance: #{current_account.balance}"
# puts "saving balance: #{savings_account.balance}"


#testcase 16 ##############################################
# puts "Saving before: #{savings_account.balance}"
#  puts "Current before: #{current_account.balance}"

# result = savings_account.withdraw(9500)
# puts "Transfer result: #{result}"
# puts "saving: #{savings_account.balance}"

# #tc 18######################################
# puts "Transaction history:"
# savings_account.show_transactions(savings_account.account_number)
