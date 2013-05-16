load "proxyclass.rb"

# basic testing examples
a = FixnumProxy.new(10)
b = FixnumProxy.new(5)
c = FixnumProxy.new(2)
print "a = 10, b = 5\n\n"
print "a = ", a, "\n\n"
print "a+b = ", a+b, "\n\n"
print "a/b = ", a / b, "\n\n"
print "30/a = ", 30/a, "\n\n" # = 1 because a/a
print "3 + a = ", 3 + a, "\n\n" # = 20 because a+a
print "a + 3 = ", a + 3, "\n\n"
puts " ------------- "
puts a + b + c

puts a < 3
puts a < b
ProxyClass.assert_equal(a, 3)

# true
puts ProxyClass.assert_less_than(a, 15)

# false
puts ProxyClass.assert_greater_than_or_equal(a, 15)

# false
puts ProxyClass.assert_equal(b, c)

puts "---------------------------"

# FixnumProxy testing

x = FixnumProxy.new(5)
y = 3
z = x + y
Z3.printContext()
