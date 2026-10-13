require 'pp'
def create_cart
  puts "How many products do you want to add?"
  nums_of_product = gets.chomp.to_i

  cart = []

  nums_of_product.times do
    puts " "
    puts "Enter product name:"
    products = gets.chomp

    puts "Enter Category:"
    category = gets.chomp

    puts "Enter price:"
    price = gets.chomp.to_f

    puts "Enter quantity:"
    quantity = gets.chomp.to_i

    puts "Enter available stock:"
    stock = gets.chomp.to_i

    puts "Enter discount percentage:"
    discount = gets.chomp.to_f

    products_hash = {
      product: products,
      category: category,
      price: price,
      quantity: quantity,
      stock: stock,
      discount: discount
    }

    cart << products_hash
  end

  cart
end


#1. Identify products that can be purchased. A product can be purchased only when the
# requested quantity is less than or equal to the available stock.
def valid_products(cart)
  cart.select { |item|
    item[:quantity] <= item[:stock]
  }
end


#2. Identify all out-of-stock or insufficient-stock products.
def get_insufficient_stock(cart)
  insufficient_stock_name = cart.select { |item|
    item[:quantity] > item[:stock]
  }

  insufficient_stock_name.map {|item|
    item[:product]
  }
end

#3,4,5
def calculate_items(valid_product)
  valid_product.map { |item|
    original_amount = item[:price] * item[:quantity]
    discount_amount = original_amount * item[:discount] / 100
    final_amount = original_amount - discount_amount

    {
      product: item[:product],
      original_amount: original_amount,
      discount_amount: discount_amount,
      final_amount: final_amount
    }
  }
end


# 6. Calculate the total cart amount before discount and after product-level discount.
def calculate_total(items)
  original_total = items.sum { |item| item[:original_amount] }

  product_discount = items.sum { |item|
    item[:discount_amount]
  }

  total_after_product_discount = items.sum {|item|
    item[:final_amount]
  }

  {
    original_total: original_total,
    product_discount: product_discount,
    total_after_product_discount: total_after_product_discount
  }
end

# 7. If the final cart amount is greater than Rs. 50,000, apply an additional 5% cart-level discount.
def calculate_cart_discount(total_after_product_discount)
  cart_discount = 0

  if total_after_product_discount > 50000
    cart_discount = total_after_product_discount * 0.05
  end

  final_cart_amount = total_after_product_discount - cart_discount

  {
    cart_discount: cart_discount,
    final_cart_amount: final_cart_amount
  }
end

#8. Group valid product names according to their category.
def get_grouped_catergoies(valid_product)
  valid_product.group_by { |item| item[:category] }.transform_values do |items| items.map { |item| item[:product] }
    end
end

# 9. Calculate how much money the customer is spending in each category.
def calculate_money_in_each_category(valid_product, items)
  category_money = valid_product.map.with_index do |item, index|
    {
      category: item[:category],
      final_amount: items[index][:final_amount]
    }
  end

  category_money
    .group_by { |item| item[:category] }
    .transform_values do |products|
      products.sum { |item| item[:final_amount] }
    end
end


#10 - Find the category on which the customer is spending the most money.
def find_highest_spending_category(category_money)
  category_money.max_by do |category, amount|
    amount
  end
end


# Q11 - Find the product that gives the customer the highest discount amount.
def get_highest_discount_product(items)
  items.max_by do |item|
    item[:discount_amount]
  end
end


# Q12 - Sort valid products from highest to lowest based on their final amount.
def sort_product(items)
  items.sort do |a, b|
    b[:final_amount] <=> a[:final_amount]
  end
end


#13 - Calculate the total number of units being purchased across all valid products.
def find_total_number_of_units(valid_product)
  valid_product.sum do |item|
    item[:quantity]
  end
end


#14 - Generate the final order summary Hash.
def create_summary(
  valid_products,
  out_of_stock,
  items,
  totals,
  cart_discount,
  products_by_category,
  category_spending,
  highest_spending_category,
  highest_discount_product,
  sorted_products,
  total_quantity
)
  {
    valid_products: valid_products,
    rejected_products: out_of_stock,
    items: items,
    original_total: totals[:original_total],
    product_discount: totals[:product_discount],
    total_after_product_discount: totals[:total_after_product_discount],
    cart_discount: cart_discount[:cart_discount],
    final_total: cart_discount[:final_cart_amount],
    products_by_category: products_by_category,
    category_spending: category_spending,
    highest_spending_category: highest_spending_category,
    highest_discount_product: highest_discount_product,
    sorted_products: sorted_products,
    total_quantity: total_quantity
  }
end


def entry
  cart = create_cart

  valid_product_list = valid_products(cart)

  out_of_stock = get_insufficient_stock(cart)

  items = calculate_items(valid_product_list)

  total = calculate_total(items)

  cart_discount = calculate_cart_discount(
    total[:total_after_product_discount]
  )

  grouped_catergoies = get_grouped_catergoies(valid_product_list)

  category_money = calculate_money_in_each_category(
    valid_product_list,
    items
  )

  highest_spending_category =
    find_highest_spending_category(category_money)

  highest_discount_product =
    get_highest_discount_product(items)

  sort_desc = sort_product(items)

  total_quantity =
    find_total_number_of_units(valid_product_list)

  order_summary = create_summary(
    valid_product_list,
    out_of_stock,
    items,
    total,
    cart_discount,
    grouped_catergoies,
    category_money,
    highest_spending_category,
    highest_discount_product,
    sort_desc,
    total_quantity
  )
  # puts order_summary
  order_summary.each do |key,value|
    puts "#{key}: #{value}"
  end
  sample_double_splat(**order_summary)
end
def sample_double_splat(valid_products:"", rejected_products:"",items:"", **option)
  puts "double_splat"
  puts valid_products
  puts rejected_products
  puts items
  puts option
end

entry




# def splat(*option)
#   [user, role, id]
# end

# def double_slpat(**option)
#   {
#     user: "smita",
#     role: developer
#   }
# end

# def unpacking(name, role, id)
  
# end


  
# splat(user, role, id)
# double_slpat(user: "smita", role: developer)



# array = ["smita", "dev", "3"]
# hash = {}

# unpacking(*array)

# def sample(array)
#   name = array[0]
# end

# def sample2(name, role, id)
#    name = name
# end

# array = [name, role, id]

# sample(array)
# sample2(**array)

