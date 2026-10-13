#1. positional arguments.
def test(*args)
  p args
end
# test("Ruby", "Rails")

#2. Default
def test2(price, quan=1)
  puts price*quan
end
# test2(500)
# test2(10,2)

#3.keyword
def test3(name:, category:)
  puts "#{name} belongs to #{category}"
end
# test3(name:"Laptop", category:"Electronics")

#4. Optional Key
def test4(name:, category:"Electronics", stock:10)
  puts "#{name}, #{category}, Stock:#{stock}"
  
end
# test4(name:"laptop")

#5. Splat operator
def test5(*num)
  num.sum

  puts num.inspect
end
# test5(5,4)

#6. double splat
def test6(**options)
  puts options.inspect
end
test6(color: "black", shape: "circle")