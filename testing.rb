load "ProxyClass.rb"

# some testing examples
a = ProxyClass.new("a", 10)
b = ProxyClass.new("b", 5)
c = ProxyClass.new("c", 2)
print "a = 10, b = 5\n\n"
print "a = ", a, "\n\n"
print "a+b = ", a+b, "\n\n"
print "a/b = ", a / b, "\n\n"
print "30/a = ", 30/a, "\n\n" # = 1 because a/a
print "1.3 + a = ", 1.3 + a, "\n\n" # = 20 because a+a
print "a + 1.3 = ", a + 1.3, "\n\n"
puts " ------------- "
puts a + b + c

puts a < 3
puts a < b

puts "---------------------------"

ProxyClass.assert("a < 3")
ProxyClass.assert("a < b")
ProxyClass.assert("2 >= c")
ProxyClass.assert_equal(a, 3)

puts "---------------------------"

class TestClass
	def initialize(somevar)
		# want the name of whatever this variable is
		puts "i am:",self.object_id,"var is:",somevar.object_id
	end
end

def somfunc(a)
	puts "hello #{a}"
	puts Kernel.caller
end

somfunc(10)

puts "---------------------------"
tvar = TestClass.new(23)
intvar = 10
ttvvaarr = TestClass.new(intvar)
ttvvaarr2 = TestClass.new(intvar)