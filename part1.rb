
puts "How many products do you want to add?"

number_of_pdt = gets.chomp.to_i

cart = []

number_of_pdt.times do 
    puts "Enter product name: "
    product = gets.chomp

    puts "Enter category: "
    category=gets.chomp

    puts "Enter price: "
    price=gets.chomp.to_f

    puts "Enter quantity: "
    quantity=gets.chomp.to_i

    puts "Enter available stock: "
    stock = gets.chomp.to_i

    puts "Enter discount percentage: "
    discount=gets.chomp.to_f

    product_hash = {
        product:product,
        category:category,
        price: price,
        quantity:quantity,
        stock:stock,
        discount:discount
    }

cart << product_hash
end
puts cart

#1.Identify products that can be purchased. A product can be purchased only when the
# requested quantity is less than or equal to the available stock.
# processing cart
valid_products= cart.select do |item|
    item[:quantity] <= item[:stock]
end

#2 Identify all out-of-stock or insufficient-stock products.
insufficient_stock = cart.select do |item|
    item[:quantity] >item[:stock]
end
insufficient_stock_name= insufficient_stock.map do |item|
    item[:product]
end



# 3,4,5 
#3. Calculate the original amount of every valid product using price x quantity.
#4. Calculate the discount amount and final price of every valid product.
#5. Create a new Array containing each valid product's name, original amount, discount amount,
#and final amount.

items = valid_products.map do |item|
    original_amt= item[:price]*item[:quantity]
    discount_amt= original_amt * item[:discount]/100
    final_amt= original_amt-discount_amt
    {
        product: item[:product],
        original_amount: original_amt,
        discount_amount: discount_amt,
        final_amount: final_amt
    }
end

#6. Calculate the total cart amount before discount and after product-level discount.
original_total =items.sum{ |item| item[:original_amount] }
product_discount = items.sum{ |item| item[:discount_amount] }
total_after_product_discount = items.sum{ |item| item[:final_amount] }
total_amount_before_and_after ={ original_total:original_total,
total_after_product_discount: total_after_product_discount
}
#7.If the final cart amount is greater than Rs. 50,000, apply an additional 5% cart-level discount.
discount_amt = 0
if total_after_product_discount > 50000 
    discount_amount_after = total_after_product_discount * (5/100)
end

final_cart_amount = total_after_product_discount - discount_amount_after


#8. Group valid product names according to their category.
grouped_valid_products_categorywise = valid_products.group_by { |item| item[:category]}.transform_values{|item| item.map{|item| item[:product]} }

#9Calculate how much money the customer is spending in each category.
# category_money= valid_products.map{|item| item[:category]}.transform_values{items.sum {|item| item[:final_amount]}}
# 
#1.Combine Category and final amt
category_money = valid_products.map.with_index {|item,index| {
    category: item[:category],
    final_amount: items[index][:final_amount]
}}

#2. group_by on basis of category
category_money= category_money.group_by{|item| item[:category]}
#3. transform value
category_money = category_money.transform_values{|product| product.sum{|item| item[:final_amount]}}

#10. Find the category on which the customer is spending the most money.

category_max= category_money.max_by{|category, amount| amount}

#11. Find the product that gives the customer the highest discount amount.
max_discount = items.max_by{|item| item[discount_amt]}

#12.Sort valid products from highest to lowest based on their final amount.
#1st method by spaceship operator
sort_desc= items.sort{|a,b| b[:final_amount] <=> a[:final_amount]}
# final_desc = sort_desc.map {|item| item[:final_amount]}

#2nd method by sort_by
# sort_desc=items.sort_by{|item| -item[:final_amount]}
# final_desc = sort_desc.map{|item| item[:final_amount]}

#13.Calculate the total number of units being purchased across all valid products.
purchase_quantity = valid_products.sum{|item| item[:quantity]}

#14.Generate the final order summary Hash.
order_summary= {
    valid_products: valid_products,
    insufficient_stock_name:insufficient_stock_name,
    items:items,
    total_amount_before_and_after:total_amount_before_and_after,
    final_cart_amount:final_cart_amount,
    grouped_valid_products_categorywise: grouped_valid_products_categorywise,
    category_money: category_money,
    category_max:category_max,
    max_discount:max_discount,
    sort_desc:sort_desc,
    purchase_quantity:purchase_quantity
}
order_summary.each do |key, value|
  puts "#{key}: #{value}"
end
